#!/bin/bash -euo pipefail
multiqc \
    --force \
     \
    --config multiqc_config.yml \
     \
     \
    .

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:MULTIQC":
    multiqc: $( multiqc --version | sed -e "s/multiqc, version //g" )
END_VERSIONS
