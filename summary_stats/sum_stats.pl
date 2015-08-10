#!env perl
use strict;
use warnings;
use Bio::SeqIO;

# these are extracted from files - will be available when release is public
# http://1000.fungalgenomes.org/data/1KFG_genomes/
my $dir = '../../genomes/final_combine';
# hard-code to biocluster for now
my $seqstat = "/opt/linux/centos/7.x/x86_64/pkgs/hmmer/3.1b2/bin/esl-seqstat";
opendir(DIR,"$dir/DNA") || die $!;
my %info;
for my $file ( readdir(DIR) ) {
    if( $file =~ /(\S+)\.fasta$/) {
	my $sp = $1;
	open(my $fh => "$seqstat $dir/DNA/$file |" ) || die $!;
	while(<$fh>) {
	    if (/^Total # residues:\s+(\d+)/ ) {
		$info{$sp}->{genome} += $1 / 1_000_000;
	    }
#	my $in = Bio::SeqIO->new(-format => 'fasta',
#				 -file   => "$dir/DNA/$file");
#	while(my $s =$in->next_seq ) {
#	    $info{$sp}->{genome} += $s->length;
#	}
	}
    }
}

opendir(DIR,"$dir/CDS") || die $!;
for my $file ( readdir(DIR) ) {
    if ( $file =~ /(\S+)\.CDS\.fasta$/ ) {
	my $sp = $1;
	open(my $fh => "grep -c '^>' $dir/CDS/$file |") || die $!;
	my $line = <$fh>;
	my ($n) = split(/\s+/,$line);
	$info{$sp}->{CDS} = $n;
    }
}

# later add gene count
my @cols = qw(genome CDS);
print join(",", qw(Species genome CDS)), "\n";
for my $sp ( sort keys %info ) {
    my $ln = 0;
    for my $c ( @cols ) {
	if( ! exists $info{$sp}->{$c} ) {
	    warn("no $c for $sp\n");
	    $ln = 1;
	}
    }
    next if $ln == 1;
    print join(",", $sp, map { $info{$sp}->{$_} } @cols),"\n";
}


