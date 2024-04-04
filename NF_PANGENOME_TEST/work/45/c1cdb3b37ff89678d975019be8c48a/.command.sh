#!/bin/bash -euo pipefail
odgi \
    layout \
    --threads 6 \
    --idx LSDV_genomes.fasta.gz.community.1.gfaffix.unchop.Ygs.og \
    -P --out LSDV_genomes.fasta.gz.community.1.gfaffix.lay --tsv LSDV_genomes.fasta.gz.community.1.gfaffix.tsv
cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:PGGB:ODGI_QC:ODGI_LAYOUT":
    odgi: $(echo $(odgi version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS
