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

include { DOWNLOAD; MAKE_PVG; ODGI; OPENNESS_PANACUS; OPENNESS_PANGROWTH; GET_VCF; GETBASES; VIZ2; HEAPS; PAVS; WARAGRAPH; COMMUNITIES; PANAROO; BUSCO } from './modules/processes.nf'

/*
#==============================================
Modules
#==============================================
*/

workflow { 
   faS = channel.fromPath("bin/faSplit", checkIfExists:true)
   refFasta = channel.fromPath("goatpox_2_virus_2_2_.fasta", checkIfExists:true)

/*     DOWNLOAD(faS) 
       DOWNLOAD
	  .out
	  .write
	  .set { refFasta }
*/
       MAKE_PVG( refFasta )

       ODGI(make_pvg.out, refFasta)
       
       OPENNESS_PANACUS(make_pvg.out)

       OPENNESS_PANGROWTH(make_pvg.out, refFasta)

       GETBASES(make_pvg.out, refFasta)
       
       GET_VCF(make_pvg.out, refFasta)

       VIZ2(make_pvg.out, refFasta )
       
       HEAPS(make_pvg.out )

       PAVS(make_pvg.out, refFasta)

       COMMUNITIES(make_pvg.out, refFasta)

       PANAROO(make_pvg.out, refFasta)

       BUSCO(make_pvg.out, refFasta)

       waragraph

}

workflow waragraph { 
   refFasta = channel.fromPath("goatpox_2_virus_2_2_.fasta", checkIfExists:true)
//      WARAGRAPH(make_pvg.out, refFasta)
}
