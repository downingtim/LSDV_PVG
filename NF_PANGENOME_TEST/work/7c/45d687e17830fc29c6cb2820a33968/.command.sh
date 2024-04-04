#!/bin/bash -euo pipefail
samtools \
    faidx \
    goatpox_2_virus_2_.fasta.gz.community.0.fa.gz \


cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:COMMUNITY:SAMTOOLS_FAIDX":
    samtools: $(echo $(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*$//')
END_VERSIONS
