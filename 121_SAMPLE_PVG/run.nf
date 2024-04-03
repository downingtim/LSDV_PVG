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

workflow {
    download()
    download.out.write | view { "Found a fasta file $it" }

}