#!/bin/bash -euo pipefail
gfaffix \
     \
    LSDV_genomes.fasta.gz.community.3.smoothxg.gfa \
    -o LSDV_genomes.fasta.gz.community.3.gfaffix.gfa > LSDV_genomes.fasta.gz.community.3.affixes.txt

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:PGGB:GFAFFIX":
    gfaffix: $(gfaffix --version 2>&1 | grep -o 'gfaffix .*' | cut -f2 -d ' ')
END_VERSIONS
