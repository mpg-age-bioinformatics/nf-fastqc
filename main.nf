#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process fastqc {
  tag "${f}"
  stageInMode 'symlink'
  stageOutMode 'move'
  
  input:
    path f
  
  script:
    """
    mkdir -p /workdir/fastqc_output
    fastqc -t ${task.cpus} -o /workdir/fastqc_output /raw_data/${f}
    """
}

workflow {
    data = channel.fromPath( "${params.kallisto_raw_data}/*fastq.gz" )
    data = data.filter{ ! file("$it".replaceAll(/.fastq.gz/, "_fastqc.html").replace("${params.kallisto_raw_data}", "${params.project_folder}fastqc_output/") ).exists() }
    fastqc( data )
}