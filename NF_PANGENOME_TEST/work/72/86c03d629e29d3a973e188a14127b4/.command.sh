#!/bin/bash -euo pipefail
odgi \
    viz \
    --threads 1 \
    --idx lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.squeeze.og \
    --out lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.squeeze.viz_multiqc.png \
    -x 1500 -y 500 -a 10 -I Consensus_

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:ODGI_QC:ODGI_VIZ_COLOR":
    odgi: $(echo $(odgi version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS