#!/usr/bin/env perl

open(IN,"$ARGV[0]"); # input FASTA 
$b = join("",<IN>);
@a=split(//,$b);
$b=~ s/N//g;
@a2=split(//,$b);
print "Total length  = ";
print ($#a-10);
print "\tGap-free length  = ";
print ($#a2-10); print "\n";

exit;
