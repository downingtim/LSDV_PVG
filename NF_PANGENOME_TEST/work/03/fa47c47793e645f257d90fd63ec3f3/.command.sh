#!/bin/bash -euo pipefail
smoothxg \
    --threads=12 \
    --gfa-in=LSDV_genomes.fasta.gz.community.0.seqwish.gfa \
    --smoothed-out=LSDV_genomes.fasta.gz.community.0.smoothxg.gfa \
    -T 12 -r 121  -V   -X 100 -I 0.9 -R 0 -j 0 -e 0 -l 700,900,1100 -O 0.001 -Y 12100 -d 0 -D 0

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:PGGB:SMOOTHXG":
    smoothxg: $(smoothxg --version 2>&1 | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS