#!/bin/nextflow

process GATK_GENERATE_REFERENCE_FILES {
    conda 'bioconda::gatk4 bioconda::samtools'
    

    /*
        Generates required index (.fai) and dictionary (.dict) files 
        from a reference sequence (.fasta)

        for downstream gatk tools (e.g. haplotypecaller, mutect2)
    */

    input:
    path rawGenomeRef

    output:
    tuple path(rawGenomeRef), path("${rawGenomeRef.getBaseName()}.*"), emit: gatk_indexed_genome

    script:
    def genomeRefID = rawGenomeRef.getBaseName()
    """
    gatk CreateSequenceDictionary -R $rawGenomeRef -O "${genomeRefID}.dict"
    samtools faidx $rawGenomeRef -o "${rawGenomeRef}.fai"
    """
}