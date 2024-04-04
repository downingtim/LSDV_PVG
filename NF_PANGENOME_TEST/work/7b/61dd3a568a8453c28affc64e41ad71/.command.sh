#!/bin/bash -euo pipefail
odgi \
    stats \
    --threads 1 \
    --idx goatpox_2_virus_2_.fasta.gz.community.0.seqwish.og \
    -P --multiqc > goatpox_2_virus_2_.fasta.gz.community.0.seqwish.og.stats.yaml

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:PGGB:ODGI_QC:ODGI_STATS":
    odgi: $(echo $(odgi version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS