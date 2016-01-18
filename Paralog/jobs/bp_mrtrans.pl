#!/opt/linux/centos/7.x/x86_64/pkgs/perl/5.20.2/bin/perl 

use constant CODONSIZE => 3;
our $GAP       = '-';
our $CODONGAP  = $GAP x CODONSIZE;

eval 'exec /opt/linux/centos/7.x/x86_64/pkgs/perl/5.20.2/bin/perl  -S $0 ${1+"$@"}'
    if 0; # not running under some shell
use strict;

# Author:      Jason Stajich <jason-at-bioperl-dot-org>
# Description: Perl implementation of Bill Pearson's mrtrans
#              to project protein alignment back into cDNA coordinates
#

=head1 NAME

bp_mrtrans - implement a transformer of alignments from protein to mrna coordinates

=head1 SYNOPSIS

Usage:
  bp_mrtrans -i inputfile -o outputfile [-if input format] [-of output format] [-s cDNA sequence database]  [-sf cDNA sequence format] [-h]

=head1 DESCRIPTION

This script will convert a protein alignment back into a cDNA.  Loosely
based on Bill Pearson's mrtrans.

The options are:

   -o filename          - the output filename [default STDOUT]
   -of format           - output sequence format
                          (multiple sequence alignment)
                          [default phylip]
   -i filename          - the input filename [required]
   -if format           - input sequence format
                          (multiple sequence alignment)
                          [ default clustalw]
   -s --seqdb filename  - the cDNA sequence database file
   -sf --seqformat      - the cDNA seq db format (flatfile sequence format)
   -h                   - this help menu

=head1 AUTHOR

Jason Stajich, jason-at-bioperl-dot-org

=cut

use strict;
use warnings;
use Bio::AlignIO;
use Bio::SeqIO;
use Getopt::Long;

# TODO - finish documentation,
#      - add support for extra options in output alignment formats
#        such as idnewline in phylip out to support Molphy input files

my ($iformat,$seqformat,$oformat,$seqdb,$input,$output) = ('clustalw','fasta',
							   'phylip');
my ($help,$usage);

$usage = "usage: bp_mrtrans.pl -i prot_alignment -if align_format -o out_dna_align -of output_format -s cDNA_seqdb -sf fasta\n".
"defaults: -if clustalw
          -of phylip
          -sf fasta\n";

GetOptions(
	   'if|iformat:s'  => \$iformat,
	   'i|input:s'     => \$input,
	   'o|output:s'    => \$output,
	   'of|outformat:s'=> \$oformat,
	   's|seqdb|db:s'  => \$seqdb,
	   'sf|seqformat:s'=> \$seqformat,
	   'h|help'        => sub{ exec('perldoc',$0);
				   exit(0)
				   },
	   );

$input ||= shift;
$seqdb ||= shift;
$output ||= shift;
if( ! defined $seqdb ) {
    die("cannot proceed without a valid seqdb\n$usage");
}
if( ! defined $input ) {
    die("cannot proceed without an input file\n$usage");
}
my $indb = new Bio::SeqIO(-file => $seqdb,
			  -format=>$seqformat);
my %seqs;
while( my $seq = $indb->next_seq ) {
    $seqs{$seq->id} = $seq;
}

my $in = new Bio::AlignIO(-format => $iformat,
			  -file   => $input);
my $out = new Bio::AlignIO(-format => $oformat,
			   -idlength => 22,
			   -interleaved => 0,
			   defined $output ? (-file   => ">$output") : () );

while( my $aln = $in->next_aln ) {
    my $dnaaln = my_aa_to_dna_aln($aln,\%seqs);
    $dnaaln->set_displayname_flat(1);
    $out->write_aln($dnaaln);
}

sub my_aa_to_dna_aln {
    my ( $aln, $dnaseqs ) = @_;
    unless ( defined $aln
        && ref($aln)
        && $aln->isa('Bio::Align::AlignI') )
    {
        croak(
'Must provide a valid Bio::Align::AlignI object as the first argument to aa_to_dna_aln, see the documentation for proper usage and the method signature'
        );
    }
    my $alnlen   = $aln->length;
    my $dnaalign = Bio::SimpleAlign->new();
    #$aln->map_chars( '\.', $GAP );

    foreach my $seq ( $aln->each_seq ) {
        my $aa_seqstr = $seq->seq();
        my $id        = $seq->display_id;
        my $dnaseq =
          $dnaseqs->{$id} || $aln->throw( "cannot find " . $seq->display_id );
        my $start_offset = ( $seq->start - 1 ) * CODONSIZE;

        $dnaseq = $dnaseq->seq();
        my $dnalen = $dnaseqs->{$id}->length;
        my $nt_seqstr;
        my $j = 0;
	my $seqend = $seq->end;
        for ( my $i = 0 ; $i < $alnlen ; $i++ ) {
            my $char = substr( $aa_seqstr, $i + $start_offset, 1 );
            if ( $char eq $GAP || $char eq '.' || $j >= $dnalen ) {
                $nt_seqstr .= $CODONGAP;
            } elsif ( $char eq '*' || $char eq 'X' ) {
	        $nt_seqstr .= $CODONGAP;
                $j += CODONSIZE;
		$seqend--;
	    } else {
                $nt_seqstr .= substr( $dnaseq, $j, CODONSIZE );
                $j += CODONSIZE;
            }
        }
        $nt_seqstr .= $GAP x ( ( $alnlen * 3 ) - length($nt_seqstr) );

        my $newdna = Bio::LocatableSeq->new(
            -display_id => $id,
            -alphabet   => 'dna',
            -start      => $start_offset + 1,
            -end        => ( $seqend * CODONSIZE ),
            -strand     => 1,
            -seq        => $nt_seqstr
        );
        $dnaalign->add_seq($newdna);
    }
    return $dnaalign;
}

__END__
