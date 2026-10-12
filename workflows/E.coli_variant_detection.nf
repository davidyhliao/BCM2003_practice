#!/bin/nextflow

params {
}

include {DOWNLOAD_GENOME as DOWNLOAD_GENOME_REF} from '/mnt/d/Projects/BCM2003_practice/modules/DOWNLOAD_GENOME.nf'
include {DOWNLOAD_READS} from '/mnt/d/Projects/BCM2003_practice/modules/DOWNLOAD_READS.nf'
include {FASTP} from '/mnt/d/Projects/BCM2003_practice/modules/FASTP.nf'
include {BWA_INDEX} from '/mnt/d/Projects/BCM2003_practice/modules/BWA_INDEX.nf'
include {BWA_MEM} from '/mnt/d/Projects/BCM2003_practice/modules/BWA_MEM.nf'


workflow {
    main:
    ch_meta = channel.fromPath('/mnt/d/Projects/BCM2003_practice/metadata.csv')
        .splitCsv(header: true, strip: true)
        .view{csv -> "after split: $csv"}
    
    // downloading reference + variant genome for E.coli
    DOWNLOAD_GENOME_REF("GCA_000005845.2")
    DOWNLOAD_READS(ch_meta)
    FASTP(DOWNLOAD_READS.out.reads)
    DOWNLOAD_GENOME_REF.out.view{rawGenomePath -> "\n Unindexed reference genome pth: ${rawGenomePath}"}
    BWA_INDEX(DOWNLOAD_GENOME_REF.out.ref_genome_path)
    BWA_INDEX.out.view{indexedGenomePath -> "\n Indexed ref genome path: ${indexedGenomePath}"}
    FASTP.out.trimmed_reads.view{trimmedReads -> "\n Trimmed reads: ${trimmedReads[1]}"}
    BWA_MEM(tuple(ch_meta, FASTP.out.trimmed_reads.map{trimmedReads -> trimmedReads[1]}, BWA_INDEX.out.indexed_genome_path))
    BWA_MEM.out.view{aligned -> "\n aligned outputs: ${aligned}"}

    publish:
    reference_genome = "/mnt/d/Projects/BCM2003_practice/scratch/reference_genomes/${DOWNLOAD_GENOME_REF.out.ref_genome_path}"
}

output{
    reference_genome {

    }
}