#!/bin/bash -euo pipefail
odgi \
    draw \
    --threads 1 \
    --idx lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.squeeze.og \
    --coords-in lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.squeeze.lay \
    --png lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.squeeze.draw_multiqc.png \
    -C -w 20 -H 1000

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:ODGI_QC:ODGI_DRAW_MULTIQC":
    odgi: $(echo $(odgi version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS
