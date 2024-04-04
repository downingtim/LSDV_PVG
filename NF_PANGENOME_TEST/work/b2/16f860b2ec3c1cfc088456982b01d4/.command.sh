#!/bin/bash -euo pipefail
odgi \
    draw \
    --threads 1 \
    --idx LSDV_genomes.fasta.gz.squeeze.og \
    --coords-in LSDV_genomes.fasta.gz.squeeze.lay \
    --png LSDV_genomes.fasta.gz.squeeze.png \
    -H 100

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:ODGI_QC:ODGI_DRAW_HEIGHT":
    odgi: $(echo $(odgi version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS
