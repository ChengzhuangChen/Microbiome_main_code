#!/bin/bash
#############
####megahit  co-ASSEMBLY 

#MEGAHIT v1.2.9
#####提前准备metadata.txt文件 样本名字 分组和fq文件对应
##########################################################
##########################################################
##########################################################

megahit -1 `tail -n+2 ./metadata.txt|cut -f1|sed 's/^/CLEAN_READS\//;s/$/_R1.fastq/'|tr '\n' ','|sed 's/,$//'` \
-2 `tail -n+2 ./metadata.txt|cut -f1|sed 's/^/CLEAN_READS\//;s/$/_R2.fastq/'|tr '\n' ','|sed 's/,$//'` \
--min-count 2 \
 --k-min 39 \
 --k-max 141 \
 --k-step 20 \
 --min-contig-len 500 \
 --memory 0.8 \
 --num-cpu-threads 64 \
 -o ASSEMBLY 
 #############################
 #############################
 #############################
 
 #######################QUSAT 评估质量
 quast -t 64 \
 -o quast_all \
 ASSEMBLY/final.contigs.fa 
 #############################
 #############################
 #############################