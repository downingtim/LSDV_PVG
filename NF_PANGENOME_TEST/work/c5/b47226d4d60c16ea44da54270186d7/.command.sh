#!/bin/bash -euo pipefail
net2communities.py     -e LSDV_genomes.fasta.gz.paf.edges.list.txt     -w LSDV_genomes.fasta.gz.paf.edges.weights.txt     -n LSDV_genomes.fasta.gz.paf.vertices.id2name.txt     --accurate-detection     --output-prefix LSDV_genomes.fasta.gz         

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:COMMUNITY:NET2COMMUNITIES":
    pggb: $(pggb --version 2>&1 | grep -o 'pggb .*' | cut -f2 -d ' ')
END_VERSIONS
