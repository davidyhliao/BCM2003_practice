#!/bin/nextflow

// performs downstream calling of variants using 
// samtools index and sort
process SAMTOOLS {
    conda 'bioconda::samtools'

    input:
    tuple val(meta), path(rawBam)

    output:
    tuple val(meta), path("*sorted.bam"), path("*.bam.bai"), emit: processed_bam

    script:
    """
    samtools sort ${rawBam} -o "${meta.id}_sorted.bam"
    samtools index -b "${meta.id}_sorted.bam"
    """
}