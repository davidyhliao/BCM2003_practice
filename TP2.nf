#!/bin/nextflow

// processes here
// or include sttements


process fastp {
    input:
    val inputName
    val outputName
    val adapterFileName    
        

    output:
    path "${inputName}_trimmed.fastq.gz", emit: reads
    path "*.json", emit: json
    path "*.html", emit: html    

    script:
    def projectDir = "/mnt/d/Projects/BCM2003_practice"
    """
    
    fastp --adapter_fasta "${projectDir}/data/adapters/${adapterFileName}" \
	-i "${projectDir}/data/${inputName}.fastq.gz" \
	-o "${inputName}_trimmed.fastq.gz" \
    -q 3 \
    -3 -W 4 -M 15 \
    -l 32 \
    -h ${inputName}.report.html
    """
}


workflow {
    main:   
    fastp("SRR5129058", "output", "fastp_adapters.fa") 

    publish:
    fastp_output_reads = fastp.out.reads
    fastp_output_json = fastp.out.json
    fastp_output_html = fastp.out.html
}



output {
    fastp_output_reads {
	path 'fastp_output'
	mode 'copy'
    }
    fastp_output_json {
	path 'fastp_output'
	mode 'copy'
    }
    fastp_output_html {
	path 'fastp_output'
	mode 'copy'
    }
}
