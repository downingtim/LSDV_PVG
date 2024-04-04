#!/bin/bash -euo pipefail
ref=$(echo "KX894508.1_155920_2012_Israel_19_Dec_2012[:0][" | cut -f 1 -d:)
if [[ "KX894508.1_155920_2012_Israel_19_Dec_2012[:0][" == *":"* ]]; then
    pop_length=$(echo "KX894508.1_155920_2012_Israel_19_Dec_2012[:0][" | cut -f 2 -d:)
else
    pop_length=""
fi

if [[ -z $pop_length ]]; then
    pop_length=0
fi

vcf="LSDV_genomes.fasta.gz.squeeze.unchop.Ygs.view.gfa".$(echo $ref | tr '/|' '_').vcf
vg deconstruct -P $ref -H "#" -e -a -t "6" "LSDV_genomes.fasta.gz.squeeze.unchop.Ygs.view.gfa" > $vcf
bcftools stats $vcf > $vcf.stats

if [[ $pop_length -gt 0 ]]; then
    vcf_decomposed=LSDV_genomes.fasta.gz.squeeze.unchop.Ygs.view.gfa.final.$(echo $ref | tr '/|' '_').decomposed.vcf
    vcf_decomposed_tmp=$vcf_decomposed.tmp.vcf
    bgzip -c -@ 6 $vcf > $vcf.gz
    vcfbub -l 0 -a $pop_length --input $vcf.gz | vcfwave -I 1000 -t 6 > $vcf_decomposed_tmp
    #TODO: to remove when vcfwave will be bug-free
    # The TYPE info sometimes is wrong/missing
    # There are variants without the ALT allele
    bcftools sort $vcf_decomposed_tmp | bcftools annotate -x INFO/TYPE | awk '$5 != "."' > $vcf_decomposed
    rm $vcf_decomposed_tmp $vcf.gz
    bcftools stats $vcf_decomposed > $vcf_decomposed.stats
fi

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:VG_DECONSTRUCT":
    pggb: $(pggb --version 2>&1 | grep -o 'pggb .*' | cut -f2 -d ' ')
END_VERSIONS
