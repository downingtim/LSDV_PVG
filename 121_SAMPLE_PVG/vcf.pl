

open(IN, "goatpox_CURRENT/VCF/path1");
$ain=<IN>;
chomp($ain);

open(OUT, ">./variation_map.txt");

for $a (300..1350){ 
	system("~/bin/gfautil -i goatpox_CURRENT/*.gfa snps --ref $ain --snps $a >> temp ");
}

open(IN2, "temp | sort -nk 3 | ");

while(<IN2>){
    if($_ =~ /path/) { ; }
    else { print OUT "$_"; }
}
exit; 
