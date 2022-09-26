# nf-kallisto-deseq2

nextflow differential gene expression pipeline

nextflow homepage: [https://www.nextflow.io](https://www.nextflow.io)

nextflow readthedocs: [https://www.nextflow.io/docs/latest/index.html](https://www.nextflow.io/docs/latest/index.html)

MacOS issues might lead to the need for:
```
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
```

### Example local run

After editing the following content of `local.config`:
```
params.project_folder='/Users/jboucas/nf-kallisto-deseq2-test/'
params.raw_data='/Users/jboucas/Desktop/test_ftp/'
```

you can run fastq locally with:
```
nextflow -c local.config run workflow.nf
```