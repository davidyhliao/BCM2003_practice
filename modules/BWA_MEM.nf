#!/bin/nextflow

// runs the BWA-mem algorithm
// takes >8-10GB of free RAM

process BWA_MEM {
    conda 'bioconda::bwa bioconda::samtools'

    // IMPORTANT: the refGenomePath should be the path to a bwa-indexed reference genome
    input:
    tuple val(meta), path(trimmedReads), path(indexedGenome), path(indexFiles)

    output:
    tuple val(meta), path("*_aligned.bam"), emit: bam

    
    script:
    def is_single = meta.containsKey('library_layout') ? meta.library_layout=="SINGLE" : false
    
    // the RG string below is needed for downstream gatk processes 
    def read_group_string = "@RG\\tID:${meta.id}\\tSM:${indexedGenome}\\tPL:ILLUMINA"

    if (is_single){
        def input_file = trimmedReads instanceof List ? trimmedReads[0] : trimmedReads
        """
        bwa mem -t 4 \\
        -R '${read_group_string}' \\
        $indexedGenome \\
        zcat $input_file \\
        | samtools view -b -o ${meta.id}_aligned.bam
        """
    } else {
        """
        bwa mem -t 4 \\
        -R '${read_group_string}' \\
        $indexedGenome \\
        "${trimmedReads[0]}" "${trimmedReads[1]}" \\
        | samtools view -b -o "${meta.id}_aligned.bam"
        """
    }
    
}