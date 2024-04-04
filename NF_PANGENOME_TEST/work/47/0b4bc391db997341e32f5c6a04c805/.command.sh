#!/bin/bash -euo pipefail
odgi \
    view \
    --threads 1 \
    --idx lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.squeeze.og \
    --to-gfa \
    -P > lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.squeeze.unchop.Ygs.view.gfa

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:ODGI_VIEW":
    odgi: $(echo $(odgi version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS
