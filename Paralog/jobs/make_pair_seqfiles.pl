#!/usr/bin/perl 
use strict;
use warnings;

use Bio::SeqIO;
use Bio::DB::Fasta;
use File::Spec;

my $cdsfolder = 'transcripts';
my $pepfolder = 'pep';
my $outfolder = 'pairs';
my $file = shift || die"need a file";

open(my $fh => $file) || die "cannot open $file";
my (undef,undef,$filename) = File::Spec->splitpath($file);
my $basename;
if ( $filename =~ /(\S+)\.FASTA.tab$/ ) {
 $basename = $1;
} else {
 die "input report unexpected name: $filename"
}

my $pairct = 0;
my $pepdb = Bio::DB::Fasta->new(sprintf("%s/%s.pep.fasta",$pepfolder,$basename));
my $cdsdb = Bio::DB::Fasta->new(sprintf("%s/%s.CDS.fasta",$cdsfolder,$basename));
my $min_aligned = 0.60;
my %seen;
while(<$fh>) {
 next if /^\#/;
 my ($q,$t,$pid,$alnlen) = split;
 next if $q eq $t; # skip self-vs-self
 my ($sp) = split(/\|/,$q);
 my $outfile = File::Spec->catdir($outfolder,$sp);
 mkdir($outfile);
 my $qseq = $pepdb->get_Seq_by_acc($q);
 my $tseq = $pepdb->get_Seq_by_acc($t); 
 if ( ! $qseq ) {
   warn("no qseq $q");
   next;
 }
 if ( ! $tseq ) {
   warn("no tseq $t");
   next;
 }
 if(( $alnlen / $qseq->length)  < $min_aligned ) {
   next;
 }
 next if $seen{$q}++ || $seen{$t}++;
 $outfile = File::Spec->catfile($outfile,sprintf("p%06d",$pairct++));
 my $cdsout = Bio::SeqIO->new(-format => 'fasta', -file => ">$outfile.cds");
 my $pepout = Bio::SeqIO->new(-format => 'fasta', -file => ">$outfile.pep");
 my $qcds = $cdsdb->get_Seq_by_acc($q);
 my $tcds = $cdsdb->get_Seq_by_acc($t);
 
 if( $qseq->seq =~ /\*/ ) { 
    my $s = $qseq->seq;
    $s = substr($s,0,$qseq->length - 1);
    $s =~ s/\*/X/g;
    $qseq = Bio::PrimarySeq->new(-id => $qseq->id, -seq => $s, -desc => $qseq->description);
    $s = $qcds->seq;
    $s = substr($s,0,$qcds->length - 3);
    $qcds = Bio::PrimarySeq->new(-id => $qcds->id, -seq => $s, -desc => $qcds->description);
 } 
if( $tseq->seq =~ /\*/ ) {
    my $s = $tseq->seq;
    $s = substr($s,0,$tseq->length - 1);
    $s =~ s/\*/X/g;
    $tseq = Bio::PrimarySeq->new(-id => $tseq->id, -seq => $s, -desc => $tseq->description);
    $s = $tcds->seq;
    $s = substr($s,0,$tcds->length - 3);
    $tcds = Bio::PrimarySeq->new(-id => $tcds->id, -seq => $s, -desc => $tcds->description);
 }
 $cdsout->write_seq($qcds);
 $cdsout->write_seq($tcds);
 $pepout->write_seq($qseq);
 $pepout->write_seq($tseq);
}
