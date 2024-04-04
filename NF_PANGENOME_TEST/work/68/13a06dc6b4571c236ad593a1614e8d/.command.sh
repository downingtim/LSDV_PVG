#!/bin/bash -euo pipefail
odgi \
    draw \
    --threads 1 \
    --idx goatpox_2_virus_2_.fasta.gz.gfaffix.unchop.Ygs.og \
    --coords-in goatpox_2_virus_2_.fasta.gz.gfaffix.lay \
    --png goatpox_2_virus_2_.fasta.gz.gfaffix.draw_multiqc.png \
    -C -w 20 -H 1000

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:PGGB:ODGI_QC:ODGI_DRAW_MULTIQC":
    odgi: $(echo $(odgi version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS
