#!/bin/bash -euo pipefail
gfaffix \
     \
    lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.community.5.smoothxg.gfa \
    -o lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.community.5.gfaffix.gfa > lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.community.5.affixes.txt

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:PGGB:GFAFFIX":
    gfaffix: $(gfaffix --version 2>&1 | grep -o 'gfaffix .*' | cut -f2 -d ' ')
END_VERSIONS
