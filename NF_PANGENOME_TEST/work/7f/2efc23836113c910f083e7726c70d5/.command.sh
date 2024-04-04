#!/bin/bash -euo pipefail
odgi \
    viz \
    --threads 1 \
    --idx goatpox_2_virus_2_.fasta.gz.squeeze.og \
    --out goatpox_2_virus_2_.fasta.gz.squeeze.viz_depth_multiqc.png \
    -x 1500 -y 500 -a 10 -I Consensus_ -m

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:ODGI_QC:ODGI_VIZ_DEPTH":
    odgi: $(echo $(odgi version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS
