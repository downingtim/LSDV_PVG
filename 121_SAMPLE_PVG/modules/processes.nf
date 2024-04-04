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

// Script parameters
params.fasta = '/mnt/lustre/RDS-live/downing/LSDV_PVG/121_SAMPLE_PVG/lumpy_2_skin_2_disease_2_virus_2_2_.fasta'
fasta_file = file(params.fasta)

process download {
    output:
    path("*.fasta"), emit: "write"

    script:
    """
    download.R
    """
}

process make_pvg {

    input:
    path file from fasta_file
   
    
    script:
    """
    samtools faidx $fasta
    """
}
