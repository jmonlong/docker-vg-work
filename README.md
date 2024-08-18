Docker container with [vg](https://github.com/vgteam/vg) and a few other tools.
Deposited at [quay.io/jmonlong/vg-work](https://quay.io/repository/jmonlong/vg-work?tab=info)

Latest image is `quay.io/jmonlong/vg-work:1.59.0_v1` and provides:

- vg v1.59.0
- freebayes v1.2.0
- samtools v1.20.0
- htslib v1.20.0 (inc. tabix with GAF indexing option)
- picard v3.2.0
- seqtk v1.4
- libbdsg python module

It also contains two small python scripts:

- `/opt/scripts/rename_bam_stream.py` to rename sequences in a SAM stream
- `/opt/scripts/subset_fastq_seqtk.py` to extract a subset of reads with seqtk in chunks (to control the memory usage)

This container is used by the [Snakemake pipeline to analyze sequencing data with vg](https://github.com/vgteam/vg_snakemake).
