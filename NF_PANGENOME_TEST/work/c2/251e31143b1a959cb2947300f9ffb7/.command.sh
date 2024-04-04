#!/bin/bash -euo pipefail
ls *.og > files
odgi \
    squeeze \
     \
    --threads 6 \
    --input-graphs files \
    -o lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.squeeze.og


cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:ODGI_SQUEEZE":
    odgi: $(echo $(odgi version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v'))
END_VERSIONS
