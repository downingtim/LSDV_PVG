#!/bin/bash -euo pipefail
odgi \
    build \
    --threads 6 \
    --gfa LSDV_genomes.fasta.gz.community.4.seqwish.gfa \
    --out LSDV_genomes.fasta.gz.community.4.seqwish.og \
    -P

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:PGGB:ODGI_BUILD":
    odgi: $(echo $(odgi version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS
