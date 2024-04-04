#!/bin/bash -euo pipefail
multiqc \
    --force \
    --outdir goatpox_2_virus_2_.fasta.gz.community.0_multiqc \
    --config multiqc_config.yml \
     \
    .

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:MULTIQC_COMMUNITY":
    multiqc: $( multiqc --version | sed -e "s/multiqc, version //g" )
END_VERSIONS
