#!/bin/bash -euo pipefail
bgzip  -c  -@1 LSDV_genomes.fasta.gz.community.4.txt.fa > LSDV_genomes.fasta.gz.community.4.fa.gz

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:COMMUNITY:TABIX_BGZIP":
    tabix: $(echo $(tabix -h 2>&1) | sed 's/^.*Version: //; s/ .*$//')
END_VERSIONS
