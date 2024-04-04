#!/bin/bash -euo pipefail
odgi \
    build \
    --threads 6 \
    --gfa goatpox_2_virus_2_.fasta.gz.community.0.gfaffix.gfa \
    --out goatpox_2_virus_2_.fasta.gz.community.0.gfaffix.og \
    -P

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:PGGB:ODGI_BUILD":
    odgi: $(echo $(odgi version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS
