#!/usr/bin/env nextflow
nextflow.enable.dsl=2


process get_images {
  stageInMode 'symlink'
  stageOutMode 'move'

  script:
    """

    if [[ "${params.run_type}" == "r2d2" ]] || [[ "${params.run_type}" == "raven" ]] ; 

      then

        cd ${params.image_folder}

        if [[ ! -f fastqc-0.11.9.sif ]] ;
          then
            singularity pull fastqc-0.11.9.sif docker://index.docker.io/mpgagebioinformatics/fastqc:0.11.9
        fi

    fi


    if [[ "${params.run_type}" == "local" ]] ; 

      then

        docker pull mpgagebioinformatics/fastqc:0.11.9

    fi

    """

}

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

process upload_paths {
  stageInMode 'symlink'
  stageOutMode 'move'

  script:
  """
    cd ${params.project_folder}/fastqc_output
    rm -rf upload.txt
    for f in \$(ls *.html) ; do echo "fastqc \$(readlink -f \${f})" >>  upload.txt ; done
  """
}

workflow images {
  main:
    get_images()
}

workflow upload {
  main:
    upload_paths()
}

workflow {
    data = channel.fromPath( "${params.fastqc_raw_data}/*fastq.gz" )
    data = data.filter{ ! file("$it".replaceAll(/.fastq.gz/, "_fastqc.html").replace("${params.fastqc_raw_data}", "${params.project_folder}/fastqc_output/") ).exists() }
    fastqc( data )
}