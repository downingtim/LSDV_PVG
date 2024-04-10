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

include { download; make_pvg; odgi; openness_panacus; openness_pangrowth; get_vcf; getbases } from './modules/processes.nf'

/*
#==============================================
Parameters
#==============================================
*/

// Script parameters

params.vcf = "bin/vcf.pl"
params.faSplit = "bin/faSplit"
//params.ref = "lumpy_2_skin_2_disease_2_virus_2_2_.fasta" 
//params.ref2 = params.ref 
//params.dirname = params.ref2.replaceFirst(/2_virus_2_2_.fasta/, "CURRENT")

/*
#==============================================
Modules
#==============================================
*/

workflow { 
//   refFasta = channel.fromPath(params.ref, checkIfExists:true)
//   outDir2 = channel.fromPath(params.dirname, checkIfExists:true)
   vcf1 = channel.fromPath(params.vcf, checkIfExists:true)
   faS = channel.fromPath(params.faSplit, checkIfExists:true)

   main:	

       download(faS) 
       download
	  .out
	  .write
	  .set { refFasta }

       make_pvg(refFasta) 
       make_pvg
          .out
//   	  .set{ gfa_in }

// println "Project : $workflow.projectDir"

//       odgi(refFasta, outDir2)

//       odgi(make_pvg.out, refFasta, outDir2, gfa_in)
/*       odgi
	.out
	.og
	.set { og_in }
	
       openness_panacus(make_pvg.out, outDir2, gfa_in)
       openness_pangrowth(refFasta, outDir2)
       get_vcf(make_pvg.out, refFasta, outDir2, gfa_in, vcf1)
       getbases(odgi.out refFasta, outDir2, og_in)
*/
//       cleanup(outDir3)
}
