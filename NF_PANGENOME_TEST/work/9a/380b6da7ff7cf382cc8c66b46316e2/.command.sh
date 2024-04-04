#!/bin/bash -euo pipefail
odgi \
    stats \
    --threads 1 \
    --idx LSDV_genomes.fasta.gz.community.4.seqwish.og \
    -P --multiqc > LSDV_genomes.fasta.gz.community.4.seqwish.og.stats.yaml

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:PGGB:ODGI_QC:ODGI_STATS":
    odgi: $(echo $(odgi version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS
