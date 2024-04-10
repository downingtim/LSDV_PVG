#!/usr/bin/env nextflow

/*
Download datasets of interest, perform QC and construct a phylogeny.
/*

/*
#==============================================
Enable DSL2
#==============================================
*/

nextflow.enable.dsl = 2

/*
#==============================================
Download dataset to examine (eg LSDV)
#==============================================
*/

process download {
    input:
    path (faS)

    output:
//    val true
    publishDir ".", mode: "copy"
    path("*2_2_.fasta"), emit: "write"

    script:
    """
    module load R
    Rscript ${workflow.projectDir}/bin/download.R
    """
}

process make_pvg {
    tag {"index reference FASTA"}
    label 'pvg'

    input:
    path (refFasta)
    
    output:
    publishDir ".", mode: "copy"
//    path("${refFasta}.gz.fai"), emit: sam_fai
    path("CURRENT/*.gfa"), emit: gfa
    
    script:
    """
    # create Blast indexes for self-self blast
    # makeblastdb -dbtype nucl -in ${refFasta} -out ${workflow.projectDir}/BLAST/fasta.db 
    # blastall -p blastn -d ${workflow.projectDir}/BLAST/fasta.db -i ${refFasta} -e 1.0 -outfmt 6 > self-blast.out
    
    # SAMtools index
    bgzip ${refFasta}
    samtools faidx ${refFasta}.gz > ${refFasta}.gz.fai

    # run pangenome in nf-core - don't work as reliably as PGGB, so best avoided
    # nextflow run nf-core/pangenome --input ${refFasta}.gz --n_haplotypes 5 --outdir \
    #   ${workflow.projectDir}/CURRENT  --communities  --wfmash_segment_length 1000
    #odgi stats -m -i ${workflow.projectDir}/CURRENT/FINAL_ODGI/${refFasta}.gz.squeeze.og -S > ${workflow.projectDir}/odgi.stats.txt 

    # alternative to nf-core pangenome
    pggb -i ${refFasta}.gz -m -S -o CURRENT/ -t 46 -p 90 -s 1k -n 5
    """
}

process odgi {
    tag {"odgi"}
    label 'odgi'

    input:
    path (refFasta)
    path (outDir2)
//    path (gfa_in)

    output:
    publishDir ".", mode: "copy"
//    path("*.fasta.og"), emit: og

    script:
    """
    odgi build -g ${projectDir}/${outDir2}/*.gfa -o ${projectDir}/${outDir2}/${refFasta}.og 
    odgi stats -m -i ${projectDir}/${outDir2}/${refFasta}.og -S > ${projectDir}/odgi.stats.txt 
    """
}

process openness_panacus {
    tag {"get PVG openness panacus"}
    label 'openness_panacus'

    input:
    val ready
    path (outDir2)
    path (gfa_in)
    
    output:
    publishDir ".", mode: "copy"
    
    script:
    """
    # mamba install -c conda-forge -c bioconda panacus
    # get haplotypes
    grep '^P' $gfa_in | cut -f2 > ${workflow.projectDir}/${outDir2}/PANACUS/haplotypes.txt
    
    # run panacus to get data
    RUST_LOG=info panacus histgrowth -t4 -l 1,2,1,1,1 -q 0,0,1,0.5,0.1 -S -s ${workflow.projectDir}/${outDir2}/PANACUS/haplotypes.txt $gfa_in > ${workflow.projectDir}/${outDir2}/PANACUS/histgrowth.node.tsv
 
    # visualise plot as PDF
    panacus-visualize -e ${workflow.projectDir}/${outDir2}/PANACUS/histgrowth.node.tsv > ${workflow.projectDir}/${outDir2}/PANACUS/histgrowth.node.pdf
    """
}

process openness_pangrowth {
    tag {"get PVG openness pangrowth"}
    label 'openness_pangrowth'

    input:
    path (refFasta)
    path (outDir2)

    output:
    publishDir "${outDir}", mode: "copy"
    
    script:
    """
    # need to split files into individual files in folder SEQS
    # wget https://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/faSplit and chmod it
    #   ./${faSplit} byname ${refFasta} ${outDir}/${outDir2}/PANGROWTH/SEQS/

    # run pangrowth
     ~/pangrowth/pangrowth hist -k 17 -t 12 ${outDir}/${outDir2}/PANGROWTH/SEQS/*a > ${outDir}/${outDir2}/PANGROWTH/hist.txt

    # plot AFS for single dataset - not very useful! 
     python ~/pangrowth/scripts/plot_single_hist.py ${outDir}/${outDir2}/PANGROWTH/hist.txt ${outDir}/${outDir2}/PANGROWTH/LSDV.pangrowth.pdf

    # model growth - prepare dataset 1 - not useful
     ~/pangrowth/pangrowth growth -h ${outDir}/${outDir2}/PANGROWTH/hist.txt > ${outDir}/${outDir2}/PANGROWTH/LSDV
     python ~/pangrowth/scripts/plot_growth.py ${outDir}/${outDir2}/PANGROWTH/LSDV ${outDir}/${outDir2}/PANGROWTH/LSDV.growth.pdf

    # do core
     ~/pangrowth/pangrowth core -h ${outDir}/${outDir2}/PANGROWTH/hist.txt -q 0.5 > ${outDir}/${outDir2}/PANGROWTH/LSDV_core
     python ~/pangrowth/scripts/plot_core.py ${outDir}/${outDir2}/PANGROWTH/LSDV_core ${outDir}/${outDir2}/PANGROWTH/LSDV_core.pdf
    """
}

process get_vcf {
    tag {"get VCFs"}
    label 'vcf'

    input:
    val true
    path (refFasta)
    path (outDir2)
    path (gfa_in)
    path (vcf1)

    output:
    publishDir "${outDir}", mode: "copy"
    
    script:
    """
    ~/bin/gfautil -i $gfa_in gfa2vcf > ${outDir}/${outDir2}/VCF/${refFasta}.vcf
    # https://lib.rs/crates/gfautil

    # need to get paths from GFA
    odgi paths -i ${outDir}/${outDir2}/${refFasta}.og -L > ${outDir}/${outDir2}/VCF/paths.txt
    head -n 1 ${outDir}/${outDir2}/VCF/paths.txt > ${outDir}/${outDir2}/VCF/path1
    # these correspond to the samples, eg "K303/83_g001_s001"
    # get first sample name
    # then give to gfautil
    # Outputs a tab-delimited list in the format:
    # <query-path-name>\t<reference base>\t<reference pos>\t<query base>\t<query pos>
    # script to create initial file 

    perl ${vcf1} ${outDir2} #  sort out coordinates
    Rscript ${outDir}/bin/plot_variation_map.R # plot image of variation map in PDF
    """
}

process getbases {
    tag {"get bases"}
    label 'bases'

    input:
    val ready
    path (refFasta)
    path (outDir2)
    path (og_in)

    output:
    publishDir "${outDir}", mode: "copy"

    """
    odgi flatten -i ${outDir}/${og_in} -f ${refFasta} -b ${refFasta}.bed -t 22
    """
}

