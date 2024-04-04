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
    
    script:
    """
    mkdir BLAST
    # creat Blast indexes for self-self blast
    makeblastdb -dbtype nucl -in $refFasta -out BLAST/fasta.db 
    # blastall -p blastn -d BLAST/fasta.db -i $refFasta -e 1.0 -outfmt 6 > self-blast.out
    
    # SAMtools index
    bgzip ${refFasta}
    echo ${refFasta} ${refFasta}.gz
    samtools faidx ${refFasta}.gz > ${refFasta}.gz.fai

    echo ${outDir}

    # run pangenome in nf-core
    nextflow run nf-core/pangenome --input ${refFasta}.gz --n_haplotypes 135 --outdir \
      ${outDir}/LSDV_CURRENT  --communities  --wfmash_segment_length 1000

    # alternative to nf-core pangenome
    #pggb -i msa_fa -m -S -o LSDV_CURRENT -t 16 -p 90 -s 1k -n 135
    #cd LSDV_CURRENT
    #odgi build -g file_gfa -o file_og 

    odgi stats -m -i ${outDir}/LSDV_CURRENT/FINAL_ODGI/${refFasta}.gz.squeeze.og -S > ${outDir}/odgi.stats.txt 
    """
}

process openness {
    tag {"get PVG openness"}
    label 'openness'

    input:
    path (refFasta)
    path (outDir)
    
    output:
    publishDir "${outDir}", mode: "copy"
    
    script:
    """
    # mamba install -c conda-forge -c bioconda panacus
    # get haplotypes
    grep '^P' ${outDir}/LSDV_CURRENT/FINAL_GFA/${refFasta}.gz.squeeze.unchop.Ygs.view.gfa | cut -f2 > ${outDir}/haplotypes.txt
    # run panacus to get data
    RUST_LOG=info panacus histgrowth -t4 -l 1,2,1,1,1 -q 0,0,1,0.5,0.1 -S -s ${outDir}/haplotypes.txt  ${outDir}/LSDV_CURRENT/FINAL_GFA/${refFasta}.gz.squeeze.unchop.Ygs.view.gfa > ${outDir}/histgrowth.node.tsv
    # visualise plot as PDF
    panacus-visualize -e ${outDir}/histgrowth.node.tsv > ${outDir}/histgrowth.node.pdf

    """
}
