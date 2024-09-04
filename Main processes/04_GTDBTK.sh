#!/bin/bash
#conda activate gtdbtk
#####GTDB-Tk v2.3.2

cp -r /yourpath/drep_output_sort_50_5/dereplicated_genomes .

gtdbtk classify_wf \
--genome_dir dereplicated_genomes \
--out_dir classify_wf \
--extension fa \
--prefix bin \
--skip_ani_screen \
--cpus 64
#####物种注释 FastTree version: 2.1.11
mkdir out_infer
gtdbtk infer --msa_file align/bin.bac120.user_msa.fasta --out_dir out_infer_bac120 --cpus 64 --prefix bin
gtdbtk infer --msa_file align/bin.ar53.user_msa.fasta --out_dir out_infer_ar53 --cpus 64 --prefix bin
#############################
#############################
#############################