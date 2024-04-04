#!/bin/bash -euo pipefail
net2communities.py     -e lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.paf.edges.list.txt     -w lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.paf.edges.weights.txt     -n lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.paf.vertices.id2name.txt     --accurate-detection     --output-prefix lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz         

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:COMMUNITY:NET2COMMUNITIES":
    pggb: $(pggb --version 2>&1 | grep -o 'pggb .*' | cut -f2 -d ' ')
END_VERSIONS
