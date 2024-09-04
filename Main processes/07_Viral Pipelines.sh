#!/bin/bash

####调用了ViWrap管道中的vb-vs-dvf  方法
###ViWrap安装参考 https://github.com/AnantharamanLab/ViWrap
#####也可单独调用
##########
##############VIBRANT： https://github.com/AnantharamanLab/VIBRANT
##############VirSorter2： https://github.com/jiarong/VirSorter2
#############DeepVirFinder： https://github.com/jessieren/DeepVirFinder

ViWrap run --input_metagenome /yourpath/final.contigs.fasta \
--input_reads /yourpath/meta_fastq_sed/A1_R1.fastq.gz,/yourpath/meta_fastq_sed/A1_R2.fastq.gz,/yourpath/meta_fastq_sed/A2_R1.fastq.gz,/yourpath/meta_fastq_sed/A2_R2.fastq.gz,/yourpath/meta_fastq_sed/A3_R1.fastq.gz,/yourpath/meta_fastq_sed/A3_R2.fastq.gz,/yourpath/meta_fastq_sed/A4_R1.fastq.gz,/yourpath/meta_fastq_sed/A4_R2.fastq.gz,/yourpath/meta_fastq_sed/B1_R1.fastq.gz,/yourpath/meta_fastq_sed/B1_R2.fastq.gz,/yourpath/meta_fastq_sed/B2_R1.fastq.gz,/yourpath/meta_fastq_sed/B2_R2.fastq.gz,/yourpath/meta_fastq_sed/B3_R1.fastq.gz,/yourpath/meta_fastq_sed/B3_R2.fastq.gz,/yourpath/meta_fastq_sed/B4_R1.fastq.gz,/yourpath/meta_fastq_sed/B4_R2.fastq.gz,/yourpath/meta_fastq_sed/C1_R1.fastq.gz,/yourpath/meta_fastq_sed/C1_R2.fastq.gz,/yourpath/meta_fastq_sed/C2_R1.fastq.gz,/yourpath/meta_fastq_sed/C2_R2.fastq.gz,/yourpath/meta_fastq_sed/C3_R1.fastq.gz,/yourpath/meta_fastq_sed/C3_R2.fastq.gz,/yourpath/meta_fastq_sed/C4_R1.fastq.gz,/yourpath/meta_fastq_sed/C4_R2.fastq.gz,/yourpath/meta_fastq_sed/D1_R1.fastq.gz,/yourpath/meta_fastq_sed/D1_R2.fastq.gz,/yourpath/meta_fastq_sed/D2_R1.fastq.gz,/yourpath/meta_fastq_sed/D2_R2.fastq.gz,/yourpath/meta_fastq_sed/D3_R1.fastq.gz,/yourpath/meta_fastq_sed/D3_R2.fastq.gz,/yourpath/meta_fastq_sed/D4_R1.fastq.gz,/yourpath/meta_fastq_sed/D4_R2.fastq.gz \
--out_dir /yourpath/ViWrap_outdir_MAGs-vb-vs-dvf \
--db_dir /yourpath/ViWrap_db \
--identify_method vb-vs-dvf \
--threads 64 \
--conda_env_dir /yourpath/ViWrap_conda_environments \
--input_length_limit 5000 \
--custom_MAGs_dir /yourpath/MAGs_sed/Bin_pick \
--iPHoP_db_custom /yourpath/iphop-vb-vs-dvf 
#################################
#################################
#################################
######获取final_overlapped_virus.fasta

#################checkv v1.0.1
############CheckV：https://bitbucket.org/berkeleylab/checkv/src/master/

checkv end_to_end final_overlapped_virus.fasta final_overlapped_virus-output \
-d /yourpath/ViWrap_db/CheckV_db \
-t 40
#################################
#################################
#################################
#################根据结果筛选出 virus.fasta
####Viral Contigs with ≥ 50% estimated completeness (n = 338)


###########准备ID.txt 文件
seqkit grep --pattern-file /yourpath/ID.txt /yourpath/final-dvf-vb-vs.fasta -o virus.fasta
################################
######################de-duplicated and clustered into viral operational taxonomic units (vOTUs, n = 338) by MMseqs2 (v15-6f452)
#############MMseqs2：https://github.com/soedinglab/MMseqs2
#conda create -n mmseqs2 -c conda-forge -c bioconda mmseqs2 plass megahit prodigal hmmer sra-tools
conda activate mmseqs2

mmseqs easy-cluster virus.fasta clusterRes tmp \
--min-seq-id 0.95 \
-c 0.85 \
--cov-mode 1 -e 1E-05 \
--cluster-mode 2 \
--cluster-reassign

#################################
#################################
#################################
############得到最终的virus.fasta
#####以此为基础分析

#######################生成faa文件
prodigal -i ./virus.fasta \
-a ./prodigal/virus.faa \
-d ./prodigal/virus.fna \
-f gff \
-g 11 \
-o ./prodigal/virus.gff \
-p single \
-s ./prodigal/virus.stat
############################################

############genomad注释
############genomad：https://github.com/apcamargo/genomad

conda activate genomad
genomad end-to-end ./virus.fasta 
genomad_output /yourpath_db/genomad_db \
 -q \
 --cleanup \
 --conservative-taxonomy \
 -t 64
#################################
#################################
#################################


#####vContact2
##########vContact2： https://github.com/Hocnonsense/vcontact2
###准备gene2genome文件
conda activate vContact2
vcontact2_gene2genome --proteins 
./prodigal/virus.faa --output ./virus_out_map.csv \
--source-type Prodigal-FAA
#######################
vcontact2 --raw-proteins ./prodigal/virus.faa \
--rel-mode 'Diamond' \
--proteins-fp ./virus_out_map.csv \
--db 'ProkaryoticViralRefSeq94-Merged' \
--pcs-mode MCL --vcs-mode ClusterONE \
--c1-bin /yourpath/vConTACT2/cluster_one-1.0.jar \
--output-dir vcontact2-output \
-t 64
################################
################################
###DeePhage流程在虚拟机完成
#####教程参考https://github.com/shufangwu/DeePhage
./DeePhage virus.fasta  virus_result.csv


###############################

###########AMG鉴定####################VIBRANT   
##############VIBRANT： https://github.com/AnantharamanLab/VIBRANT
conda activate VIBRANT

VIBRANT_run.py -i /yourpath/virus.fasta \
-folder ./VIBRANT-outdir 
-t 64 \
-l 5000 \
-d /yourpath_db/databases \
-m /yourpath-db/files
#############################
#############################
#############################


#################噬菌体和古病毒的宿主分配
#########安装及数据库构建（家人MAGs分类数据）参考教程
#####https://bitbucket.org/srouxjgi/iphop/src/main/
conda activate iPHop
iphop predict --fa_file ./virus.fasta \
--out_dir iphop-out \
-t 64 \
--db_dir /yourpath/iphop-vb-vs \  
--no_qc 
#############################
###################################


##############################metapop
##metapop： https://github.com/metaGmetapop/metapop
#####准备文件reads_count.txt bam file
###seqkit stat -j 8 /yourpath/*.fastq.gz > reads_count.txt

bowtie2-build -f ./virus.fasta virus/index --threads 64 
for F in /yourpath/*_R1.fastq.gz
do
	R=${F%_*}_R2.fastq.gz
	BASE=${F##*/}
	NAME=${BASE%_*}
	bowtie2 -x virus/index -p 20 -1 $F -2 $R | samtools view -S -b -@ 64 -o- > bamout/${NAME}.bam
done
#############################
#############################
#############################
conda activate metapop
metapop --input_samples ./bamout 
--reference ./virus-all #####virus-all文件夹存放 virus.fasta

--norm ./reads_count.txt \
--threads 64 \
--output metapop-output 
#####################
#############################
#############################










 
 