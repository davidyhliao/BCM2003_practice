#!/bin/nextflow

process DOWNLOAD_READS {
    conda 'bioconda:sra-tools'

    // takes as input the SRR ID (DRR014382, SRR019284, etc.) of the run in question
    // and the absolute directory in which the fastq file(s) will go
    input:
    val meta

    output:
    tuple val(meta), path("*.fastq.gz"), emit: reads


    // *** needs $HOME/ncbi_cache/ directory created beforehand!
    // this directory will hold the temporary files from fasterq-dump
    // modify the variable ncbi_cache as needed before running this module
    script:
    def ncbi_cache = "/home/david/ncbi_cache"
    def SRRID = meta.id

    // logic to determine library layout (single/paired end reads)
    // if unspecified in metadata paired-end is assumed
    def is_single = meta.containsKey('library_layout') ? meta.library_layout=="SINGLE" : false
    def split = is_single ? "" : "--split-3"
    """
    vdb-config --restore-defaults
    vdb-config --set /repository/user/main/public/root=${ncbi_cache}
    vdb-config --set /libs/vdb/quality='ZR'
    prefetch ${SRRID} --output-directory ${ncbi_cache}
    fasterq-dump ${ncbi_cache}/${SRRID}/${SRRID}.sralite ${split}
    gzip *.fastq
    rm -r ${ncbi_cache}/${SRRID}
    cp *.fastq.gz $meta.readDirectory
    """
}