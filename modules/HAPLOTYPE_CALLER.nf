#!/bin/nextflow


// variant (SNP/indels) calling for short-reads
// use clairs-to for long-read somatic/tumour var. calling instead

// germline (mut.'s during reproduction, NOT tumour) variants!
// works better with diploid genomes, but done with E-coli due to hardware constraints
process HAPLOTYPE_CALLER {
    conda 'bioconda::gatk4'

    input:
    tuple val(meta), path(sortedBam), path(bamIndicies), path(genomeRef), path(genomeIndicies)

    output:
    tuple val(meta), path("*.vcf.gz")

    script:
    //--java-options "-Xmx4g"
    """
    gatk HaplotypeCaller \\
    -R $genomeRef \\
    -I $sortedBam \\
    -O "${meta.id}.vcf.gz" \\
    -ploidy 1
    """
}