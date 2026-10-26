# NEXTFLOW pipelines with some Bioinformatics tools learned in class


## Important directories:

### 1. DAGs - Diagrams of **modules** and information flow between modules through Nextflow's **channels**

### 2. modules - the simplest components of a nextflow pipeline, usually a single bioinformatics tool involved (FASTP, FASTQC, STAR, etc.)
#### This helps improve code reusability and applies the **Separation of concerns** (SoC) principle

### 3. subworkflows - Common blocks of several modules seen in bioinformatics workflows (e.g. preprocessing/QC of reads)

### 4. workflows - otherwise known as **pipelines**, a proper workflow will demand input parameters and/or a metadata file and will serve as an end-to-end process for a bioinformatics task.

## **COMPLETED WORKFLOWS:** E.coli Variant detection using FASTP, BWA-MEM, SAMTOOLS, and GATK's HAPLOTYPECALLER to prepare .vcf files
