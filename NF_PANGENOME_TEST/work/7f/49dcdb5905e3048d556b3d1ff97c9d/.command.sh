#!/bin/bash -euo pipefail
seqwish \
    --threads 6 \
    --paf-alns=lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.community.5.paf \
    --seqs=lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.community.5.fa.gz \
    --gfa=lumpy_2_skin_2_disease_2_virus_2_2_.fasta.gz.community.5.seqwish.gfa \
    -k 23 -f 0.0 -B 10000000 -P

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:PGGB:SEQWISH":
    seqwish: $(echo $(seqwish --version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS
