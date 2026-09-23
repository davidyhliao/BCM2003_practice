#!/bin/nextflow



// downloads the genome from ncbi and processes it into .fasta.gz format
process DownloadGenome {
    conda 'conda-forge::ncbi-datasets-cli'

    // the accession can be the NCBI assembly acc. (GCF_000001405.40)
    // or the NCBI Bioproject (PRJEB33226)

    // the outputDir should have sufficient storage for the reference genome
    // takes the absolute path
    input:
    val accession
    val outputDir

    output:
    path "${outputDir}/${accession}.fasta.gz", emit: genome_fasta

    script:
    """
    cd '${outputDir}'
    datasets download genome accession \
    '${accession}' \
    --include genome
    
    unzip "ncbi_dataset.zip"
    """

}
