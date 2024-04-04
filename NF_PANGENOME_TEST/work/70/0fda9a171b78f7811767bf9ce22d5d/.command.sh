#!/bin/bash -euo pipefail
odgi \
    sort \
    --threads 12 \
    --idx LSDV_genomes.fasta.gz.community.3.gfaffix.unchop.og \
    --out LSDV_genomes.fasta.gz.community.3.gfaffix.unchop.Ygs.og \
    -p Ygs -P
cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:PGGB:ODGI_SORT":
    odgi: $(echo $(odgi version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS
