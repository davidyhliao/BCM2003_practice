#!/bin/nextflow

/*
===============================================================================================
(SUBWORKFLOW) ALIGN_TO_REFERENCE_GENOME

Aligns raw PAIRED or UNPAIRED reads (.fastq, .fastq.gz), 
    - trims adapters using FASTP
    
to a raw reference genome (.fa, .fna, .fastq)
    - BWA indexes the reference genome in preparation for alignment


Outputs sorted & indexed .bam (binary alignment file)
===============================================================================================
*/


// MODULES
include {FASTP} from '../modules/FASTP.nf'
include {BWA_INDEX} from '../modules/BWA_INDEX.nf'
include {BWA_MEM} from '../modules/BWA_MEM.nf'
include {SAMTOOLS} from '../modules/SAMTOOLS.nf'


workflow ALIGN_TO_REFERENCE_GENOME {
    take:
    ref_genome_ch
    reads_ch

    main:
    trimmed_reads_ch = FASTP(reads_ch)
    indexed_ref_genome_ch = BWA_INDEX(ref_genome_ch)
    raw_bam_ch = BWA_MEM(trimmed_reads_ch.trimmed_reads.combine(indexed_ref_genome_ch.indexed_genome_path))
    sorted_indexed_bam_ch = SAMTOOLS(raw_bam_ch)

    emit:
    sorted_indexed_bam = sorted_indexed_bam_ch.combine(indexed_ref_genome_ch.indexed_genome_path)
}
