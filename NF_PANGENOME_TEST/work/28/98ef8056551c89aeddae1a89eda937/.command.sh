#!/bin/bash -euo pipefail
odgi \
    stats \
    --threads 1 \
    --idx lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.community.1.seqwish.og \
    -P --multiqc > lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.community.1.seqwish.og.stats.yaml

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:PGGB:ODGI_QC:ODGI_STATS":
    odgi: $(echo $(odgi version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS
