#!/bin/bash
###MAGs的去冗余得到
###dRep version 3.4.5
###dRep：https://github.com/MrOlm/drep
#############################
#############################
dRep：https://github.com/MrOlm/drep
dRep dereplicate drep_output_sort_50_5_99 \
-g Bin_sort_all/*.fa \
-sa 0.99 \
-nc 0.30 \
-p 64 \
-pa 0.9 \
-comp 50 \
-con 5 
######Resultdereplicated_genomes: 113个 SGBs
#############################
#############################
#############################


