#!/bin/nextflow

// processes here
// or include sttements


process CONDA_SETUP {
    conda "/home/david/miniconda/envs/${condaEnv}/"
    

    input: 
    val condaEnv

    script:
    """
    echo "$(conda list)"
    """
}

