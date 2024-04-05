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
    output:
    path("*.fasta"), emit: "write"

    script:
    """
    module load R
    download.R
    """
}

process make_pvg {
    tag {"index reference FASTA"}
    label 'pvg'

    input:
    path (refFasta)
    path (outDir)
    
    output:
    publishDir "${outDir}", mode: "copy"
    path("${refFasta}.gz.fai"), emit: sam_fai
    path("${outDir}/LSDV_CURRENT/*.gfa"), emit: gfa
    
    script:
    """
    # mkdir BLAST
    # creat Blast indexes for self-self blast
    # makeblastdb -dbtype nucl -in ${refFasta} -out BLAST/fasta.db 
    # blastall -p blastn -d BLAST/fasta.db -i ${refFasta} -e 1.0 -outfmt 6 > self-blast.out
    
    # SAMtools index
    bgzip ${refFasta}
    samtools faidx ${refFasta}.gz > ${refFasta}.gz.fai

    # run pangenome in nf-core - don't work as reliably as PGGB, so best avoided
    # nextflow run nf-core/pangenome --input ${refFasta}.gz --n_haplotypes 135 --outdir \
    #   ${outDir}/LSDV_CURRENT  --communities  --wfmash_segment_length 1000
    #odgi stats -m -i ${outDir}/LSDV_CURRENT/FINAL_ODGI/${refFasta}.gz.squeeze.og -S > ${outDir}/odgi.stats.txt 

    # alternative to nf-core pangenome
    pggb -i ${refFasta}.gz -m -S -o ${outDir}/LSDV_CURRENT -t 16 -p 90 -s 1k -n 135 
    """
}

process rename {
    tag {"rename"}
    label 'pvg2'

    input:
    path (refFasta)
    path (outDir)
    path (gfa_in)

    output:
    publishDir "${outDir}", mode: "copy"

    script:
    """
    odgi build -g $gfa_in -o ${outDir}/LSDV_CURRENT/${refFasta}.og 
    odgi stats -m -i ${outDir}/LSDV_CURRENT/${refFasta}.og -S > ${outDir}/odgi.stats.txt 
    """
}

process openness_panacus {
    tag {"get PVG openness panacus"}
    label 'openness_panacus'

    input:
    path (refFasta)
    path (outDir)
    path (gfa_in)
    
    output:
    publishDir "${outDir}", mode: "copy"
    
    script:
    """
    # mamba install -c conda-forge -c bioconda panacus
    # get haplotypes
    # mkdir PANACUS
    grep '^P' $gfa_in | cut -f2 > ${outDir}/PANACUS/haplotypes.txt
    
    # run panacus to get data
    RUST_LOG=info panacus histgrowth -t4 -l 1,2,1,1,1 -q 0,0,1,0.5,0.1 -S -s ${outDir}/PANACUS/haplotypes.txt $gfa_in > ${outDir}/PANACUS/histgrowth.node.tsv
 
    # visualise plot as PDF
    panacus-visualize -e ${outDir}/PANACUS/histgrowth.node.tsv > ${outDir}/PANACUS/histgrowth.node.pdf
    """
}

process openness_pangrowth {
    tag {"get PVG openness pangrowth"}
    label 'openness_pangrowth'

    input:
    path (refFasta)
    path (outDir)
    path (faSplit)

    output:
    publishDir "${outDir}", mode: "copy"
    
    script:
    """
    mkdir PANGROWTH
    # need to split files into individual files in folder SEQS
    mkdir PANGROWTH/SEQS/
    # wget https://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/faSplit and chmod it
    echo    ./${faSplit} byname ${refFasta} PANGROWTH/SEQS/
    ./${faSplit} byname ${refFasta} PANGROWTH/SEQS/

    # run pangrowth
    ~/pangrowth/pangrowth hist -k 17 -t 12 PANGROWTH/SEQS/*a > ${outDir}/PANGROWTH/hist.txt

    # plot AFS for single dataset - not very useful! 
    python ~/pangrowth/scripts/plot_single_hist.py ${outDir}/PANGROWTH/hist.txt ${outDir}/PANGROWTH/LSDV.pangrowth.pdf

    # model growth - prepare dataset 1 - not useful
    ~/pangrowth/pangrowth growth -h ${outDir}/PANGROWTH/hist.txt > ${outDir}/PANGROWTH/LSDV
    python ~/pangrowth/scripts/plot_growth.py ${outDir}/PANGROWTH/LSDV ${outDir}/PANGROWTH/LSDV.growth.pdf

    # do core
    ~/pangrowth/pangrowth core -h ${outDir}/PANGROWTH/hist.txt  -q 0.5 > ${outDir}/PANGROWTH/LSDV_core
    # python ~/pangrowth/scripts/plot_core.py ${outDir}/PANGROWTH/LSDV_core ${outDir}/PANGROWTH/LSDV_core.pdf
    """
}
