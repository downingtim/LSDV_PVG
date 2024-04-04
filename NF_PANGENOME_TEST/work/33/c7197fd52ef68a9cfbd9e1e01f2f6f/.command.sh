#!/bin/bash -euo pipefail
odgi \
    viz \
    --threads 1 \
    --idx LSDV_genomes.fasta.gz.squeeze.og \
    --out LSDV_genomes.fasta.gz.squeeze.viz_inv_multiqc.png \
    -x 1500 -y 500 -a 10 -I Consensus_ -z

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:ODGI_QC:ODGI_VIZ_INV":
    odgi: $(echo $(odgi version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS
