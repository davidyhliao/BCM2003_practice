#!/bin/nextflow

// runs the BWA-mem algorithm
// takes >8-10GB of free RAM

process BWA_MEM {
    conda 'bioconda::bwa'

    // IMPORTANT: the refGenomePath should be the path to a bwa-indexed reference genome
    input:
    tuple val(meta), path(trimmedReads), path(indexedGenome)

    output:
    path "*_aligned.sam", emit: sam

    
    script:
    // the scratchDir should have sufficient disk space (>50gb) to store the output file
    def scratchDir = "/mnt/c/scratch"

    def is_single = meta.containsKey('library_layout') ? meta.library_layout=="SINGLE" : false

    if (is_single){
        def input_file = trimmedReads instanceof List ? trimmedReads[0] : trimmedReads
        """
        mkdir -p $scratchDir/bwa_outputs
        bwa mem -t 4 \
        $indexedGenome \
        zcat $trimmedReads \
        > "${scratchDir}/bwa_outputs/${meta.id}_aligned.sam"
        """
    } else {
        """
        mkdir -p $scratchDir/bwa_outputs
        bwa mem -t 4 \
            $indexedGenome \
            zcat "${trimmedReads[0]}" "${trimmedReads[1]}" \
            > "${scratchDir}/bwa_outputs/${meta.id}_aligned.sam"
        """
    }
    
}