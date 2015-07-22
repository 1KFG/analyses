use strict;
use warnings;

my $header = <>;
chomp($header);
my ($dom,@hdr) = split(/\t/,$header);
# throw away description cols
pop @hdr;
pop @hdr;
pop @hdr;
my %allzero = map { $_ => 1 } @hdr;
while(<>) {
    my ($dom,@row) = split(/\t/,$_);
    # throw away desc cols
    pop @row;
    pop @row; 
    pop @row;
    for(my $i =0; $i < scalar @row; $i++ ) {
	if( $row[$i] != 0 ) {
	    delete $allzero{$hdr[$i]};
	}
    }
}

print join("\n",sort keys %allzero),"\n";
