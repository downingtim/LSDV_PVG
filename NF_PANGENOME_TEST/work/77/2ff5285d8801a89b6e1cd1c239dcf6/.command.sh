#!/bin/bash -euo pipefail
samtools \
    faidx \
    LSDV_genomes.fasta.gz \
    $(cat LSDV_genomes.fasta.gz.community.0.txt) > LSDV_genomes.fasta.gz.community.0.txt.fa
cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:COMMUNITY:EXTRACT_COMMUNITIES":
    samtools: $(echo $(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*$//')
END_VERSIONS
