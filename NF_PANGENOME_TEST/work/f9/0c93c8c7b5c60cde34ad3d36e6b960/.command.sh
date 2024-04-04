#!/bin/bash -euo pipefail
odgi \
    unchop \
    --threads 6 \
    --idx lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.community.4.gfaffix.og \
    --out lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.community.4.gfaffix.unchop.og \
    -P

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:PGGB:ODGI_UNCHOP":
    odgi: $(echo $(odgi version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS
