import argparse
import gzip
import subprocess
import os


parser = argparse.ArgumentParser(description='Extract a subset of reads from a FASTQ with seqtk, in chunks to control memory usage')
parser.add_argument('-r', help='gzipped file with read names', required=True)
parser.add_argument('-f', help='gzipped FASTQ', required=True)
parser.add_argument('-F', help='second gzipped FASTQ (optional)', default='')
parser.add_argument('-c', help='chunk size (default 1 000 000)', type=int,
                    default=1000000)
parser.add_argument('-t', help='prefix for temporary files', default='temp')
args = parser.parse_args()

if args.F == '':
    # only one FASTQ
    def run_seqtk(rnames):
        # write read names in temporary file
        temp_filen = '{}.{}'.format(args.t,
                                    abs(hash(args.r + args.f + rnames[0])))
        with open(temp_filen, 'wt') as tempf:
            for rn in rnames:
                tempf.write(rn + '\n')
        # run seqtk
        cmd = ['seqtk', 'subseq', args.f, temp_filen]
        subprocess.run(cmd)
        # remove temporary file
        os.remove(temp_filen)
else:
    # two FASTQs provided
    def run_seqtk(rnames):
        # write read names in temporary file
        temp_filen = '{}.{}'.format(args.t,
                                    abs(hash(args.r + args.f + rnames[0])))
        with open(temp_filen, 'wt') as tempf:
            for rn in rnames:
                tempf.write(rn + '\n')
        # run seqtk
        cmd = ['sh', '-c',  'seqtk mergepe {} {} | seqtk subseq - {}'.format(args.f, args.F, temp_filen)]
        subprocess.run(cmd)
        # remove temporary file
        os.remove(temp_filen)


# go through read names in chunk
if args.r.endswith('.gz'):
    rn_inf = gzip.open(args.r, 'rt')
else:
    rn_inf = open(args.r, 'rt')
reads_in_chunk = []
for line in rn_inf:
    rn = line.rstrip()
    if len(reads_in_chunk) < args.c:
        reads_in_chunk.append(rn)
    else:
        # make sure reads in the same pair are not placed in different chunks
        # (assuming they are listed right after each other)
        lrn = reads_in_chunk[-1]
        if lrn.rstrip('12') == rn.rstrip('12'):
            reads_in_chunk.append(rn)
        else:
            # run seqtk
            run_seqtk(reads_in_chunk)
            # make new chunk
            reads_in_chunk = [rn]

if len(reads_in_chunk) > 0:
    run_seqtk(reads_in_chunk)
