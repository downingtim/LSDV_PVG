#!/bin/bash -euo pipefail
gfaffix \
     \
    goatpox_2_virus_2_.fasta.gz.smoothxg.gfa \
    -o goatpox_2_virus_2_.fasta.gz.gfaffix.gfa > goatpox_2_virus_2_.fasta.gz.affixes.txt

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:PGGB:GFAFFIX":
    gfaffix: $(gfaffix --version 2>&1 | grep -o 'gfaffix .*' | cut -f2 -d ' ')
END_VERSIONS
