#!/bin/bash -euo pipefail
odgi \
    view \
    --threads 1 \
    --idx LSDV_genomes.fasta.gz.squeeze.og \
    --to-gfa \
    -P > LSDV_genomes.fasta.gz.squeeze.unchop.Ygs.view.gfa

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:ODGI_VIEW":
    odgi: $(echo $(odgi version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS
