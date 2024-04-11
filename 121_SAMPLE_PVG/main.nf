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

include { download; make_pvg; odgi; openness_panacus; openness_pangrowth; get_vcf; getbases; viz2; heaps } from './modules/processes.nf'

/*
#==============================================
Modules
#==============================================
*/

workflow { 
   faS = channel.fromPath("bin/faSplit", checkIfExists:true)

   main:	

       download(faS) 
       download
	  .out
	  .write
	  .set { refFasta }

       make_pvg(refFasta )
/*
       odgi(make_pvg.out, refFasta)
       
       openness_panacus(make_pvg.out)

       openness_pangrowth(make_pvg.out, refFasta)

       getbases(make_pvg.out, refFasta)
       
       get_vcf(make_pvg.out, refFasta)

       viz2(make_pvg.out)
       
       heaps(make_pvg.out)
*/
}
