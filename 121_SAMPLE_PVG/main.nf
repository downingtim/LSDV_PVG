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

include { download; make_pvg; rename; openness_panacus; openness_pangrowth } from './modules/processes.nf'

/*
#==============================================
Parameters
#==============================================
*/

// Script parameters

params.fasta = " "
params.outdir = "/mnt/lustre/RDS-live/downing/LSDV_PVG/121_SAMPLE_PVG/"
//params.ref = "/mnt/lustre/RDS-live/downing/LSDV_PVG/121_SAMPLE_PVG/lumpy_2_skin_2_disease_2_virus_2_2_.fasta"
params.ref = "/mnt/lustre/RDS-live/downing/LSDV_PVG/121_SAMPLE_PVG/goatpox_2_virus_2_2_.fasta"
params.faSplit = "/mnt/lustre/RDS-live/downing/LSDV_PVG/121_SAMPLE_PVG/faSplit"

/*
#==============================================
Modules
#==============================================
*/

workflow { 
   refFasta = channel.fromPath(params.ref, checkIfExists:true)
   outDir = channel.fromPath(params.outdir, checkIfExists:true)
   faSplit = channel.fromPath(params.faSplit, checkIfExists:true)
      //  .first()
      //  .set{refFasta}

   // main:	

   //    download()
   //    download.out.write | view { "Found a fasta file $it" }

       make_pvg(refFasta, outDir)
       make_pvg
          .out
  	  .gfa
   	  .set{ gfa_in }
	
       rename(refFasta, outDir, gfa_in)
       openness_panacus(refFasta, outDir, gfa_in)
       openness_pangrowth(refFasta, outDir, faSplit)
}
