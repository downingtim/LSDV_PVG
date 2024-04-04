#!/bin/bash -euo pipefail
wfmash \
    lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz \
    lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz \
     \
    --threads 6 \
     \
    -n 134 -s 5000 -p 90.0  -X  -l 25000 -k 19 -H 0.001   -m > lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.paf


cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:COMMUNITY:WFMASH_MAP_COMMUNITY":
    wfmash: $(echo $(wfmash --version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS
