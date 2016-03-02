#!env perl
use strict;
use warnings;
use File::Spec;
use Bio::SeqIO;

my $Min_aln_percent = 0.30;

my $dbfolder = 'chytrid_proteomes';
my @dbs = map { File::Spec->catfile($dbfolder,$_) } qw(blastocladiomycota.aa chytridiomycota.aa);
$dbfolder = 'dikarya_zygo_proteomes';
push @dbs, map { File::Spec->catfile($dbfolder,$_) } qw(dikayra_zygo.aa);
 
for my $file ( @dbs ) {
    next if $file =~ /dikarya_zygo/; # we didn't do the reciprocal search
    my $in = Bio::SeqIO->new(-format => 'fasta',
			     -file => $file);    
    my %seqnames;
    while( my $s = $in->next_seq ) {
	$seqnames{$s->display_id} = $s->length;	
    }
    warn(scalar keys %seqnames, " unique sequences in $file\n");
    my $unique_count = scalar keys %seqnames;
    my (undef,$qdbdir,$qname) = File::Spec->splitpath($file);
    my ($filepref) = split('\.',$qname);
    open( my $ofh => ">$filepref.lst") || die "cannot open $filepref.lst. $!";
    warn("opened $filepref.lst\n");
    my %seen;
    for my $target ( @dbs ) {
	my (undef,$tdbdir,$tname) = File::Spec->splitpath($target);
	my ($tf) = split('\.',$tname); # target fungi clade
	my $blastfile = sprintf("%s.%s.BLASTP.tab", $filepref,$tf);
	warn("opening $blastfile\ for $file\n");
	open(my $fh => $blastfile) || die "cannot open $blastfile: $!";	
	
	while(<$fh>) {
	    next if /^\#/;
	    my ($q,$t,$pid,$alnlen,$pos,$gaps,
		$qs,$qe,$ts,$te, $evalue,$bits) = split(/\t/,$_);	    
	    next if $q eq $t;	# ignore self hits.
	    my ($sp_q) = split(/\|/,$q);
	    my ($sp_t) = split(/\|/,$t);
	                            	    
	    # some filtering could take place here
	    if( exists $seqnames{$q} ) {		
		my $aln_Frac = abs($qe - $qs) / $seqnames{$q};
		#if( $aln_Frac >= $Min_aln_percent ) {	    
		    if( $sp_q eq $sp_t) {
			# ignore paralogs within species to count as a hit	    
			$seen{$q}->{'Paralog'}++;
		    } else {
			$seen{$q}->{$tf}++; # gene $q has a hit in the db $file	   
#		    warn("$q -> $t aln frac is $aln_Frac for $qs..$qe and qlen=$seqnames{$q}\n");
		    }
		#} else {
#		    warn("skipping -- $q $t aln frac is $aln_Frac for $qs..$qe and qlen=$seqnames{$q}\n");
		#}
	    } else {
		warn("No seqname info for $q\n");
	    }
	}		
    }
    
    for my $q ( keys %seqnames ) {
	if( ! exists $seen{$q} ) {
	    warn("No hits for $q\n");
	    print $ofh join("\t", $q, qw(NONE)), "\n";
	} elsif( keys %{$seen{$q}} == 1 ) {
	    print $ofh join("\t", $q,join(",",keys %{$seen{$q}})), "\n";
	}
    }
}
