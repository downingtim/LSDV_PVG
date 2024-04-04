#!/bin/bash -euo pipefail
bgzip  -c  -@1 lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.community.4.txt.fa > lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.community.4.fa.gz

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:COMMUNITY:TABIX_BGZIP":
    tabix: $(echo $(tabix -h 2>&1) | sed 's/^.*Version: //; s/ .*$//')
END_VERSIONS
