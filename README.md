# NEXTFLOW pipelines with some Bioinformatics tools learned in class


## Important directories:

1. DAGs - Diagrams of **modules** and information flow between modules through Nextflow's **channels**

2. modules - the simplest components of a nextflow pipeline, usually a single bioinformatics tool involved (FASTP, FASTQC, STAR, etc.)
This helps improve code reusability and applies the **Separation of concerns** (SoC) principle

3. subworkflows - Common blocks of several modules seen in bioinformatics workflows (e.g. preprocessing/QC of reads)

4. workflows - otherwise known as **pipelines**, a proper workflow will demand input parameters and/or a metadata file and will serve as an end-to-end process for a bioinformatics task.

## **COMPLETED WORKFLOWS:** 
**E.coli Variant detection** using FASTP, BWA-MEM, SAMTOOLS, and GATK's HAPLOTYPECALLER to prepare .vcf files

Link to DAG: [E.coli_variant_detection_pipeline.html](https://github.com/user-attachments/files/33945623/E.coli_variant_detection_pipeline.html)
<details><summary>Click to see html code</summary>
<!--
  ~ Copyright 2013-2026, Seqera Labs
  ~
  ~ Licensed under the Apache License, Version 2.0 (the "License");
  ~ you may not use this file except in compliance with the License.
  ~ You may obtain a copy of the License at
  ~
  ~     http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing, software
  ~ distributed under the License is distributed on an "AS IS" BASIS,
  ~ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  ~ See the License for the specific language governing permissions and
  ~ limitations under the License.
  -->
<html>
<head>
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1, maximum-scale=1">
</head>
<body>
<pre class="mermaid" style="text-align: center;">
%%{
  init: {
    'theme': 'base',
    'themeVariables': {
      'primaryColor': '#B6ECE2',
      'primaryTextColor': '#160F26',
      'primaryBorderColor': '#065647',
      'lineColor': '#545555',
      'clusterBkg': '#BABCBD22',
      'clusterBorder': '#DDDEDE',
      'fontFamily': 'arial'
    }
  }
}%%
flowchart TB
    subgraph " "
    v0["channel.fromPath"]
    v3["accession"]
    end
    v4(["DOWNLOAD_GENOME_REF"])
    v5(["DOWNLOAD_READS"])
    subgraph "ALIGN_TO_REFERENCE_GENOME [ALIGN_TO_REFERENCE_GENOME]"
    v6(["FASTP"])
    v9(["BWA_INDEX"])
    v11(["BWA_MEM"])
    v12(["SAMTOOLS"])
    v10(( ))
    v13(( ))
    end
    subgraph " "
    v7[" "]
    v8[" "]
    v18[" "]
    v20[" "]
    end
    v14(["GATK_GENERATE_REFERENCE_FILES"])
    v17(["HAPLOTYPE_CALLER"])
    v1(( ))
    v15(( ))
    v19(( ))
    v0 --> v1
    v3 --> v4
    v4 --> v9
    v4 --> v14
    v1 --> v5
    v5 --> v6
    v6 --> v8
    v6 --> v7
    v6 --> v10
    v9 --> v10
    v9 --> v13
    v10 --> v11
    v11 --> v12
    v12 --> v13
    v14 --> v15
    v15 --> v17
    v17 --> v18
    v19 --> v20
    v13 --> v15
    v13 --> v19

</pre>
<script type="module">
  import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs';
  mermaid.initialize({ startOnLoad: true, maxTextSize: Number.MAX_SAFE_INTEGER, maxEdges: Number.MAX_SAFE_INTEGER });
</script>
</body>
</html>
</details>
