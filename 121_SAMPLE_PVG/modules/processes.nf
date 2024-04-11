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
    input:
    path (faS)

    output:
    publishDir ".", mode: "copy"
    path("*2_2_.fasta"), emit: "write"

    script:
    """
    export NXF_JVM_ARGS="-Xms12g -Xmx16g"
    module load R
    Rscript ${workflow.projectDir}/bin/download.R
    """
}

process make_pvg {
    tag {"index reference FASTA"}
    label 'pvg'

    input:
    path (refFasta)
    
    output:
    val true
    publishDir ".", mode: "copy"
    
    script:
    """
    read -r number < "${workflow.projectDir}/bin/number1.txt"   #   get number

    # create Blast indexes for self-self blast
    # makeblastdb -dbtype nucl -in ${refFasta} -out ${workflow.projectDir}/BLAST/fasta.db 
    # blastall -p blastn -d ${workflow.projectDir}/BLAST/fasta.db -i ${refFasta} -e 1.0 -outfmt 6 > self-blast.out
    
    # SAMtools index
    bgzip ${refFasta}
    samtools faidx ${refFasta}.gz > ${refFasta}.gz.fai

    # run PGGB - you need to specify the number of haplotypes in $number
    pggb -i ${refFasta}.gz -m -S -o CURRENT/ -t 46 -p 90 -s 1k -n $number
    mv -f CURRENT/* ${workflow.projectDir}/CURRENT/ # move files to correct folders 
    # mv -f CURRENT/multiqc_data/ ${workflow.projectDir}/CURRENT/
    mv -f *a.g* ${workflow.projectDir}  # move fasta files and extensions 
    # if issues, remove CURRENT/ in ${workflow.projectDir}  before re-running 

    # run pangenome in nf-core - don't work as reliably as PGGB, so best avoided
    # nextflow run nf-core/pangenome --input ${refFasta}.gz --n_haplotypes $number --outdir \
    #   ${workflow.projectDir}/CURRENT  --communities  --wfmash_segment_length 1000
    #odgi stats -m -i ${workflow.projectDir}/CURRENT/FINAL_ODGI/${refFasta}.gz.squeeze.og -S > ${workflow.projectDir}/odgi.stats.txt 
    """
}

process odgi {
    tag {"odgi"}
    label 'odgi'

    input:
    val ready from make_pvg.out
    path (refFasta)

    output:
    publishDir ".", mode: "copy"

    script:
    """
    #odgi build -g ${projectDir}/CURRENT/*.gfa -o ${projectDir}/CURRENT/${refFasta}.og 
    #odgi stats -m -i ${projectDir}/CURRENT/${refFasta}.og -S > ${projectDir}/odgi.stats.txt 
    odgi stats -m -i ${projectDir}/CURRENT/*.og -S > ${projectDir}/odgi.stats.txt 
    """
}

process openness_panacus {
    tag {"get PVG openness panacus"}
    label 'openness_panacus'

    input:
    val ready from make_pvg.out

    output:
    publishDir ".", mode: "copy"
    
    script:
    """
    # mamba install -c conda-forge -c bioconda panacus
    # get haplotypes
    grep '^P' ${workflow.projectDir}/CURRENT/*.gfa | cut -f2 > ${workflow.projectDir}/CURRENT/PANACUS/haplotypes.txt
    
    # run panacus to get data - just use defaults
    RUST_LOG=info panacus histgrowth -t4 -l 1,2,1,1,1 -q 0,0,1,0.5,0.1 -S -s ${workflow.projectDir}/CURRENT/PANACUS/haplotypes.txt ${workflow.projectDir}/CURRENT/*.gfa > ${workflow.projectDir}/CURRENT/PANACUS/histgrowth.node.tsv
 
    # visualise plot as PDF
    panacus-visualize -e ${workflow.projectDir}/CURRENT/PANACUS/histgrowth.node.tsv > ${workflow.projectDir}/CURRENT/PANACUS/histgrowth.node.pdf
    """
}

process openness_pangrowth {
    tag {"get PVG openness pangrowth"}
    label 'openness_pangrowth'

    input:
    val ready from make_pvg.out
    path (refFasta)

    output:
    publishDir ".", mode: "copy"
    
    script:
    """
    # need to split files into individual files in folder SEQS
    # wget https://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/faSplit and chmod it
    #   ./faSplit byname ${refFasta} ${workflow.projectDir}/CURRENT/PANGROWTH/SEQS/

    # run pangrowth
     ~/pangrowth/pangrowth hist -k 17 -t 12 ${workflow.projectDir}/CURRENT/PANGROWTH/SEQS/*a > ${workflow.projectDir}/CURRENT/PANGROWTH/hist.txt

    # plot AFS for single dataset - not very useful! 
     python ~/pangrowth/scripts/plot_single_hist.py ${workflow.projectDir}/CURRENT/PANGROWTH/hist.txt ${workflow.projectDir}/CURRENT/PANGROWTH/LSDV.pangrowth.pdf

    # model growth - prepare dataset 1 - not useful
     ~/pangrowth/pangrowth growth -h ${workflow.projectDir}/CURRENT/PANGROWTH/hist.txt > ${workflow.projectDir}/CURRENT/PANGROWTH/LSDV
     python ~/pangrowth/scripts/plot_growth.py ${workflow.projectDir}/CURRENT/PANGROWTH/LSDV ${workflow.projectDir}/CURRENT/PANGROWTH/LSDV.growth.pdf

    # do core - this does not converge to a solution for n<10 samples, causes error
     ~/pangrowth/pangrowth core -h ${workflow.projectDir}/CURRENT/PANGROWTH/hist.txt -q 0.5 > ${workflow.projectDir}/CURRENT/PANGROWTH/LSDV_core

    read -r number < "${workflow.projectDir}/bin/number1.txt"   #   get number
    if [ $number -gt 10 ]; then # if the core is too small, this crashes
       python ~/pangrowth/scripts/plot_core.py ${workflow.projectDir}/CURRENT/PANGROWTH/LSDV_core    ${workflow.projectDir}/CURRENT/PANGROWTH/LSDV_core.pdf
    fi
    """
}

process get_vcf {
    tag {"get VCFs"}
    label 'vcf'

    input:
    val ready from make_pvg.out
    path (refFasta)

    output:
    publishDir ".", mode: "copy"
    
    script:
    """
    ~/bin/gfautil -i ${workflow.projectDir}/CURRENT/*.gfa gfa2vcf > ${workflow.projectDir}/CURRENT/VCF/${refFasta}.vcf
    # https://lib.rs/crates/gfautil - download this

    # need to get paths from GFA
    odgi paths -i ${workflow.projectDir}/CURRENT/*.og -L > ${workflow.projectDir}/CURRENT/VCF/paths.txt
    head -n 1 ${workflow.projectDir}/CURRENT/VCF/paths.txt > ${workflow.projectDir}/CURRENT/VCF/path1
    # these correspond to the samples, eg "K303/83_g001_s001"
    # get first sample name then give to gfautil
    # Outputs a tab-delimited list in the format:
    # <query-path-name>\t<reference base>\t<reference pos>\t<query base>\t<query pos>

    # script to create initial input to visualise with R
    perl ${workflow.projectDir}/bin/vcf.pl ../../../CURRENT/VCF/path1  #  sort out coordinates
    Rscript ${workflow.projectDir}/bin/plot_variation_map.R # plot image of variation map in PDF
    """
}

process getbases {
    tag {"get bases"}
    label 'bases'

    input:
    val ready
    path (refFasta)

    output:
    publishDir "${outDir}", mode: "copy"

    """
    odgi flatten -i ${workflow.projectDir}/CURRENT/*.og -f ${refFasta} -b ${refFasta}.bed -t 22
    perl ${workflow.projectDir}/bin/bases.pl ${refFasta}
    """
}

process viz2 {
	tag {"big viz"}
	label 'viz2'

	input:
	val ready from make_pvg.out

	output:
	publishDir "${outDir}", mode: "copy"

	"""
        # y = height of plot
        # w = step size for blocks in plot
        # c = numbers of characters for sample names
        # x = width in pixels of output
        # y = height in pixels of output
        odgi viz -i ${workflow.projectDir}/CURRENT/*.og -o ${workflow.projectDir}/LSDV.viz.png -c 55 -w 50 -y 1500
        """
}

process heaps {
	tag {"heaps"}
	label 'heaps'

	input:
	val ready from make_pvg.out

	output:
	publishDir "${outDir}", mode: "copy"

	"""
	read -r number < "${workflow.projectDir}/bin/number1.txt"   #   get number

	# visualise output, reading in heaps file, 3rd column only of interest
        Rscript bin/visualisation.R $number
	"""
}
