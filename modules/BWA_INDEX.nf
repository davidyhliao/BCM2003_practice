#!/bin/nextflow

// BWA Indexing of reference genome in preparation for downstream alignment with 
// BWA-mem
process BWA_INDEX {
    conda 'bioconda::bwa'

    // scaling memory requirements for indexing depending on genome complexity
    // will attempt 8GB ram as max
    memory {2.GB * task.attempt}
    errorStrategy 'retry'
    maxRetries 3

    input:
    path rawGenomePath

    output:
    path rawGenomePath, emit:indexed_genome_path

    script:
    """
    bwa index "${rawGenomePath}"
    """
}

