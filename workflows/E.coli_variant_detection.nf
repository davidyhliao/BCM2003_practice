#!/bin/nextflow

// include modules
include {GET_METADATA} from '/mnt/d/Projects/BCM2003_practice/modules/GET_METADATA.nf'
include {DOWNLOAD_GENOME as DOWNLOAD_GENOME_REF} from '/mnt/d/Projects/BCM2003_practice/modules/DOWNLOAD_GENOME.nf'
include {DOWNLOAD_READS} from '/mnt/d/Projects/BCM2003_practice/modules/DOWNLOAD_READS.nf'
include {GATK_GENERATE_REFERENCE_FILES} from '/mnt/d/Projects/BCM2003_practice/modules/GATK_GENERATE_REFERENCE_FILES.nf'
include {HAPLOTYPE_CALLER} from '/mnt/d/Projects/BCM2003_practice/modules/HAPLOTYPE_CALLER.nf'


// include sub-workflows
include {ALIGN_TO_REFERENCE_GENOME} from '/mnt/d/Projects/BCM2003_practice/subworkflows/ALIGN_TO_REFERENCE_GENOME.nf'


// WORKFLOW
workflow {
    main:
    // testing automatic ways of acquiring metadata
    //meta_test_ch = GET_METADATA("SRR25083116")

    meta_ch = channel.fromPath('/mnt/d/Projects/BCM2003_practice/metadata.csv')
        .splitCsv(header: true, strip: true)
        .view{csv -> "\nMetadata: $csv \n"}
    
    // downloading reference + variant genome for E.coli
    ref_genome_ch = DOWNLOAD_GENOME_REF("GCA_000005845.2")
    raw_reads_ch = DOWNLOAD_READS(meta_ch)
    sorted_indexed_bam_ch = ALIGN_TO_REFERENCE_GENOME(ref_genome_ch, raw_reads_ch)
    
    gatk_ch = GATK_GENERATE_REFERENCE_FILES(ref_genome_ch)
    haplotype_caller_input_ch = sorted_indexed_bam_ch.map{meta, bam, bai, fna, bwa_indices -> 
        tuple(meta, bam, bai)}
        .combine(gatk_ch)
    
    HAPLOTYPE_CALLER(haplotype_caller_input_ch).view()


    publish:
    //metadata = meta_test_ch
    reference_genome = ref_genome_ch
    aligned_reads = sorted_indexed_bam_ch
}

output{
    reference_genome {
        path "reference_genomes/"
        mode "copy"
    }
    aligned_reads {
        path "aligned_reads/"
        mode "copy"
    }
    /*
    metadata {
        path "metadata/"
        mode "copy"
    }
    */
}