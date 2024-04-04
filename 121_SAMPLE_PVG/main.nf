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
Modules
#==============================================
*/

include { download; make_pvg } from './modules/processes.nf'

/*
#==============================================
Parameters
#==============================================
*/

// Script parameters

params.fasta = " "
params.ref = "/mnt/lustre/RDS-live/downing/LSDV_PVG/121_SAMPLE_PVG/lumpy_2_skin_2_disease_2_virus_2_2_.fasta"
// nextflow run main.nf --ref "/mnt/lustre/RDS-live/downing/LSDV_PVG/121_SAMPLE_PVG/lumpy_2_skin_2_disease_2_virus_2_2_.fasta"

/*
#==============================================
Modules
#==============================================
*/

workflow { 
   refFasta = channel.fromPath(params.ref, checkIfExists:true)
      //  .first()
      //  .set{refFasta}

   // main:	
   //    download()
   //    download.out.write | view { "Found a fasta file $it" }
   make_pvg(refFasta)
}
