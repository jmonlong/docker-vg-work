Docker container with [vg](https://github.com/vgteam/vg) and a few other tools.
Deposited at [quay.io/jmonlong/vg-work]()

Latest image is `quay.io/jmonlong/vg-work:1.53.0_v1` and provides:

- vg v1.53.0
- freebayes v1.2.0
- samtools v1.10.0
- picard v2.18.29
- seqtk v1.3

It also contains two small python scripts:

- `/opt/scripts/rename_bam_stream.py` to rename sequences in a SAM stream
- `/opt/scripts/subset_fastq_seqtk.py` to extract a subset of reads with seqtk in chunks (to control the memory usage)
