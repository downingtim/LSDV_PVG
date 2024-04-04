#!/bin/bash -euo pipefail
seqwish \
    --threads 6 \
    --paf-alns=LSDV_genomes.fasta.gz.community.0.paf \
    --seqs=LSDV_genomes.fasta.gz.community.0.fa.gz \
    --gfa=LSDV_genomes.fasta.gz.community.0.seqwish.gfa \
    -k 23 -f 0.0 -B 10000000 -P

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:PGGB:SEQWISH":
    seqwish: $(echo $(seqwish --version 2>&1) | cut -f 1 -d '-' | cut -f 2 -d 'v')
END_VERSIONS
