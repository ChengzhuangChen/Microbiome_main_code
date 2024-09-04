#!/bin/bash
##CoverM version 0.6.1
#############################
#############################
#############################
###CoverM：https://github.com/wwood/CoverM
 
mkdir CoverM 
cd CoverM 
cp -r ~/metaBinall/gtdbtk/dereplicated_genomes/ .

coverm genome -d dereplicated_genomes/ \
-x fa \
-t 64 \
-m tpm \
-c ~/metaBinall/CLEAN_READS/*.fastq \
-o outputtpm.tsv
 #############################
#############################
#############################