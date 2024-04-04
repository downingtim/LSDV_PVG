#!/bin/bash -euo pipefail
odgi \
    unchop \
    --threads 6 \
    --idx LSDV_genomes.fasta.gz.community.3.gfaffix.og \
    --out LSDV_genomes.fasta.gz.community.3.gfaffix.unchop.og \
    -P

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:PGGB:ODGI_UNCHOP":
    odgi: $(echo $(odgi version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS
