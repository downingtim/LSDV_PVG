#!/bin/bash -euo pipefail
wfmash \
    LSDV_genomes.fasta.gz.community.2.fa.gz \
    LSDV_genomes.fasta.gz.community.2.fa.gz \
     \
    --threads 6 \
     \
    -n 120 -s 5000 -p 90.0  -X  -l 25000 -k 19 -H 0.001 > LSDV_genomes.fasta.gz.community.2.paf


cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:PGGB:WFMASH_MAP_ALIGN":
    wfmash: $(echo $(wfmash --version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS
