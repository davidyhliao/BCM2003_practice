#!/bin/nextflow


/*
Outputs a .JSON file containing metadata from the SRA database for 
1 or more SRA accession values
*/
process GET_METADATA {
    conda 'bioconda::ffq'

    input:
    val accession

    output:
    path ('*.json')

    script:
    """
    ffq $accession -o metadata.json
    """
}