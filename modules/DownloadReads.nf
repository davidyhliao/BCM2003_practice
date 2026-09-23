#!/bin/nextflow

process DownloadReads {
    conda 'bioconda:sra-tools'

    // takes as input the SRR ID (DRR014382, SRR019284, etc.) of the run in question
    // and the absolute directory in which the fastq file(s) will go
    input:
    val SRRID
    path readDir

    output:
    path "${readDir}/${SRRID}*, emit: reads

    // assmes paired end reads
    // remove the "--split-3" tag for single-end reads

    // *** needs $HOME/ncbi_cache/ directory created beforehand!
    // this directory will hold the temporary files from fasterq-dump
    script:
    """
    prefetch ${SRRID} --output-directory ~/ncbi_cache
    fasterq-dump ~/ncbi_cache/${SRRID}/${SRRID}.sralite --split-3 -O ${readDir} \\
    && gzip ${readDir}/${SRRID}_*.fastq
    rm -r ~/ncbi_cache/${SRRID}
    """
}