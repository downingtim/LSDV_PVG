#!/bin/bash -euo pipefail
samtools \
    faidx \
    lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz \
    $(cat lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.community.5.txt) > lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.community.5.txt.fa
cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:COMMUNITY:EXTRACT_COMMUNITIES":
    samtools: $(echo $(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*$//')
END_VERSIONS
