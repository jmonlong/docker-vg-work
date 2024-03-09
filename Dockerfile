FROM biocontainers/biocontainers:v1.2.0_cv1

RUN conda config --set ssl_verify False

RUN conda install -c bioconda -c conda-forge -c defaults samtools=1.10.0 freebayes=1.2.0 vg=1.53.0 seqtk=1.3

RUN conda install bioconda::picard

WORKDIR /app
