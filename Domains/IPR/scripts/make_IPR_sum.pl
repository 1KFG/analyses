#!env perl
use List::Util qw(sum);
use strict;
use warnings;
use File::Spec;

my $min_count = 1;
my $min_Evalue = 1e-5;
my @files = @ARGV;
my %domains;
my %domains_genes;
my @species;
my %dom2desc;
my %dom2ipr;
for my $file ( @files ) {
    my (undef,$path,$fname) = File::Spec->splitpath($file);
    #chop($path);
    my ($species) = split(/\./,$fname); 
    push @species, $species;
#    warn("path is $path\n");
    my $fh;
    if( $file =~ /\.gz$/ ) { 
	open($fh => "zcat $file |") || die $!;
    } else {
	open($fh => $file) || die $!;
    }
    my %seen;
    while(<$fh>) {
	chomp;

	my @row = split(/\t/,$_);
	my $domain_src = $row[3];
	my $domain_acc = $row[4];
	my $combo = join(":",$domain_src,$domain_acc);
	$dom2desc{$domain_src}->{$domain_acc} = $row[5] if defined $row[5];
	my $score = $row[8];
	next if( $score ne '-' && $score > $min_Evalue);
	next if ( $row[9] ne 'T' );
	$dom2ipr{$domain_src}->{$domain_acc} = [ $row[11], $row[12] ] if ! exists $dom2ipr{$domain_src}->{$domain_acc};
	$domains_genes{$domain_src}->{$domain_acc}->{$species}++ unless $seen{$combo."--".$row[0]}++;
	$domains{$domain_src}->{$domain_acc}->{$species}++;
    }
}


for my $domain_src ( sort keys %domains ) {
    open(my $ofh => ">IPR.$domain_src.counts.tab") || die $!;
    open(my $ofh_genes => ">IPR.$domain_src.gene_counts.tab") || die $!;
    print $ofh join("\t",qw(Domain), @species, qw(Desc IPR_Acc IPR_Desc)), "\n";
    print $ofh_genes join("\t",qw(Domain), @species, qw(Desc IPR_Acc IPR_Desc)), 
    "\n";
    for my $domain_acc ( sort keys %{$domains{$domain_src}} ) {
	my $sum = sum(map { exists $domains{$domain_src}->{$domain_acc}->{$_} ? 
				$domains{$domain_src}->{$domain_acc}->{$_} : '0' } 
		      @species);
	next if( $sum < $min_count);
	my $desc = $dom2desc{$domain_src}->{$domain_acc} || '';
	my ($ipr_acc,$ipr_desc) =  @{$dom2ipr{$domain_src}->{$domain_acc} || ['','']};
	print $ofh join("\t", ($domain_acc, 
			       map { exists $domains{$domain_src}->{$domain_acc}->{$_} ? 
					 $domains{$domain_src}->{$domain_acc}->{$_} : '0' } 
			       @species), $desc, $ipr_acc,$ipr_desc),
	"\n";
	print $ofh_genes join("\t", 
			      ($domain_acc, 
			       map { exists $domains_genes{$domain_src}->{$domain_acc}->{$_} ? 
					 $domains_genes{$domain_src}->{$domain_acc}->{$_} : '0' } 
			       @species), $desc, $ipr_acc, $ipr_desc),

	"\n";
    }
}
