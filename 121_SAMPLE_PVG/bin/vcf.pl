
$in1 = $ARGV[0]."/VCF/path1";
open(IN, $in1);
$ain=<IN>;
chomp($ain);

open(OUT, ">./variation_map.txt");

for $a (300..150000){ 
	system("~/bin/gfautil -i $ARVG[0]/*.gfa snps --ref $ain --snps $a >> temp2 ");
}

open(IN2, "more temp | sort -nk 3 | ");

while(<IN2>){
    if($_ =~ /path/) { ; }
    else { print OUT "$_"; }
}
exit; 
