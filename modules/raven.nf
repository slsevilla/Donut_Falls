process raven {
  publishDir "${params.outdir}", mode: 'copy'
  tag "${sample}"
  cpus 12
  container 'staphb/raven:latest'

  input:
  tuple val(sample), file(fastq)

  output:
  tuple val(sample), file("raven/${sample}/${sample}_raven.fasta"),   emit: fasta
  tuple val(sample), file("raven/${sample}/${sample}_raven.gfa"),   emit: gfa
  path("raven/${sample}/*"),                                    emit: directory

  shell:
  '''
    mkdir -p raven/!{sample}

    raven --version

    raven !{params.raven_options} \
      --threads !{task.cpus} \
      --graphical-fragment-assembly raven/!{sample}/!{sample}_raven.gfa \
      !{fastq} \
      > raven/!{sample}/!{sample}_raven.fasta
  '''
}