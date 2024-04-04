#!/bin/bash -euo pipefail
odgi \
    draw \
    --threads 1 \
    --idx goatpox_2_virus_2_.fasta.gz.community.0.gfaffix.unchop.Ygs.og \
    --coords-in goatpox_2_virus_2_.fasta.gz.community.0.gfaffix.lay \
    --png goatpox_2_virus_2_.fasta.gz.community.0.gfaffix.png \
    -H 100

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:PGGB:ODGI_QC:ODGI_DRAW_HEIGHT":
    odgi: $(echo $(odgi version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS
