#!/bin/bash -euo pipefail
samtools \
    faidx \
    LSDV_genomes.fasta.gz.community.2.fa.gz \


cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:COMMUNITY:SAMTOOLS_FAIDX":
    samtools: $(echo $(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*$//')
END_VERSIONS
