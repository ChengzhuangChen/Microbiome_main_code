#!/bin/bash

#conda env create -f /home/zhuang/METABOLIC/METABOLIC_v4.0_env.yml
# Rewrite GTDBTK_DATA_PATH
#conda env config vars set GTDBTK_DATA_PATH="/home/zhuang/database/gtdbtk/release214/"
#conda activate METABOLIC_v4.0

#cd METABOLIC_running_folder
#git clone https://github.com/AnantharamanLab/METABOLIC.git
#cd METABOLIC
#bash run_to_setup.sh
####metabolic_bin  ###Put the filtered bin file into metabolic_bin
###cp -r ~/metaBinall/gtdbtk/BIN_fasta_out ~/metaBinall/METABOLIC/metabolic_bin

#####ViWrap： https://github.com/AnantharamanLab/ViWrap


cd ~/metaBinall/METABOLIC/metabolic_bin
perl METABOLIC-C.pl -in-gn ./Bin_pick -r ./META.txt -t 64 --tax phylum -o out_METABOL_C_113 
#############################
#############################
#############################
