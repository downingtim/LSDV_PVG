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
    download.R
    """
}

process make_pvg {
    tag {"index reference FASTA"}
    label 'pvg'

    input:
    path (refFasta)
    
    output:
    path("${refFasta}.gz.fai"), emit: sam_fai
    
    script:
    """
    #blast indexes for self-self blast
    makeblastdb -dbtype nucl -in $refFasta
    bgzip ${refFasta}
    echo ${refFasta} ${refFasta}.gz
    #samtools index
    samtools faidx ${refFasta}.gz > ${refFasta}.gz.fai
    """
}
