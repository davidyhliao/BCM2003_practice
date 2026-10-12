#!/bin/nextflow

process DIRECTORY_SETUP {
    // Ensure the correct directories are given
    // the projectRootDir folder should alreayd have been made 
    // the scratchDir should contain sufficient disk space for storing large genomic files
    // subsequent standard file folders will be created under projectRootDir
    // both directories need to be their absolute paths!!!
    // the projectName is a string (e.g. TP2, genomic_varaint_pipeline)

    input:
    val scratchDir
    val projectRootDir
    val projectName

    script:
    """
    cd "${scratchDir}"
    mkdir "${projectName}"
    cd "${projectName}"
    mkdir "data"
    cd "data"
    mkdir {raw,processed}

    cd "${projectRootDir}"
    mkdir {scripts,workflows,notebooks,results,logs}
    ln -s "${scratchDir}/${projectName}/data"
    """

}