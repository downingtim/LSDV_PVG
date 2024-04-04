#!/bin/bash -euo pipefail
paf2net.py -p goatpox_2_virus_2_.fasta.gz.paf \


cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:COMMUNITY:PAF2NET":
    pggb: $(pggb --version 2>&1 | grep -o 'pggb .*' | cut -f2 -d ' ')
END_VERSIONS