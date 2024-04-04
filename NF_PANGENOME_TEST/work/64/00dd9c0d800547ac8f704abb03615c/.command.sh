#!/bin/bash -euo pipefail
samtools \
    faidx \
    goatpox_2_virus_2_.fasta.gz \
    $(cat goatpox_2_virus_2_.fasta.gz.community.0.txt) > goatpox_2_virus_2_.fasta.gz.community.0.txt.fa
cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:COMMUNITY:EXTRACT_COMMUNITIES":
    samtools: $(echo $(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*$//')
END_VERSIONS
