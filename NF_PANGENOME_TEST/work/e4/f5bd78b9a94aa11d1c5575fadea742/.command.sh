#!/bin/bash -euo pipefail
wfmash \
    LSDV_genomes.fasta.gz \
    LSDV_genomes.fasta.gz \
     \
    --threads 6 \
     \
    -n 120 -s 5000 -p 90.0  -X  -l 25000 -k 19 -H 0.001   -m > LSDV_genomes.fasta.gz.paf


cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:COMMUNITY:WFMASH_MAP_COMMUNITY":
    wfmash: $(echo $(wfmash --version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS
