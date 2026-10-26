#!/bin/nextflow


/*
    Annotates variants from a raw .vcf file
*/
process SNPEFF {
    conda 'bioconda::snpeff'

    input:
    path raw_vcf

    output:
    path("*")


    // incomplete script - snpEFf needs database(hg38 e.g.) before the vcf input
    script:
    """
    snpEff $raw_vcf
    """
}