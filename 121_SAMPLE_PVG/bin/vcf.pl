#!/usr/bin/env perl

$in1 = $ARGV[0]."/VCF/path1";
open(IN, $in1);
$ain=<IN>;
print "$ain\n";
chomp($ain);

open(OUT, ">./variation_map.txt");

for $a (1000..148000){ 
    #
    print "~/bin/gfautil -i $ARGV[0]/*.gfa snps --ref $ain --snps $a >> temp2  \n";
    system("~/bin/gfautil -i $ARGV[0]/*.gfa snps --ref $ain --snps $a >> temp2 ");
}

open(IN2, "more temp2 | sort -nk 3 | ");

while(<IN2>){
    if($_ =~ /path/) { ; }
    else { print OUT "$_"; }
}
exit; 
