#!/bin/bash -euo pipefail
odgi \
    layout \
    --threads 6 \
    --idx goatpox_2_virus_2_.fasta.gz.squeeze.og \
    -P --out goatpox_2_virus_2_.fasta.gz.squeeze.lay --tsv goatpox_2_virus_2_.fasta.gz.squeeze.tsv
cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:ODGI_QC:ODGI_LAYOUT":
    odgi: $(echo $(odgi version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS