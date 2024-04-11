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

process make_pvg {
    output:
    publishDir ".", mode: "copy"
    
    script:
    """
    number=0
    number=`grep -c "" /mnt/lustre/RDS-live/downing/LSDV_PVG/121_SAMPLE_PVG/lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.fai`
    """
}