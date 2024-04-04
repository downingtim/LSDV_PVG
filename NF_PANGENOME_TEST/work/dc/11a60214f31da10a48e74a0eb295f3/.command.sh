#!/bin/bash -euo pipefail
wfmash \
    lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.community.2.fa.gz \
    lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.community.2.fa.gz \
     \
    --threads 6 \
     \
    -n 134 -s 1000 -p 90.0  -X  -l 5000 -k 19 -H 0.001 > lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.community.2.paf


cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:PGGB:WFMASH_MAP_ALIGN":
    wfmash: $(echo $(wfmash --version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS
