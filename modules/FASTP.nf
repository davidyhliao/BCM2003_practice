#!/bin/nextflow

process FASTP {
    // performs fastp QC (pre-processing - adapter trimming) 
    // assumes the reads are of format *.fastq.gz

    conda 'bioconda::fastp'

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("*_trimmed.fastq.gz"), emit: trimmed_reads
    path("*.fastp.json"), emit: json
    path("*.html.json"), emit: html

    script:
    def is_single = reads instanceof List ? reads.size() == 0 : true
    if (is_single) {
        def input_file = reads instanceof List ? reads[0] : reads
        """
        fastp \\
        -i ${meta.readDirectory}/${input_file} \\
        -o ${meta.id}_trimmed.fastq.gz \\
        -q 3 \\
        -3 -W 4 -M 15 \\
        -l 32 \\
        --json ${meta.id}.fastp.json \\
        --html ${meta.id}.html.json \\
        --thread $task.cpus
        """
    } else {
        """
        fastp \\
        -i ${meta.readDirectory}/${reads[0]} \\
        -I ${meta.readDirectory}/${reads[1]} \\
        -o ${meta.id}_R1_trimmed.fastq.gz \\
        -O ${meta.id}_R2_trimmed.fastq.gz \\
        -q 3 \\
        -3 -W 4 -M 15 \\
        -l 32 \\
        --json ${meta.id}.fastp.json \\
        --html ${meta.id}.html.json \\
        -t $task.cpus
        """
    }
}
