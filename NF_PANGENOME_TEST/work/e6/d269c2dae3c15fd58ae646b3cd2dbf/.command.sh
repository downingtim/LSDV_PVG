#!/bin/bash -euo pipefail
multiqc \
    --force \
    --outdir LSDV_genomes.fasta.gz.community.4_multiqc \
    --config multiqc_config.yml \
     \
    .

cat <<-END_VERSIONS > versions.yml
"NFCORE_PANGENOME:PANGENOME:MULTIQC_COMMUNITY":
    multiqc: $( multiqc --version | sed -e "s/multiqc, version //g" )
END_VERSIONS
