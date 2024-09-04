#!/bin/bash
#############################
#############################
#############################
############根据自己的下机FQ数据进行准备前的工作，主要涉及到项目编号的修改

mkdir metaBinall
cd metaBinall
mkdir fastp #Upload clena_data
mkdir CLEAN_READS
mkdir CLEAN_READS_all
mkdir result
nohup gzip -d fastp/*.gz &
cd fastp

for i in ./*_350.fq1
do
	base=${i%_350.fq1} 
	name=${base##*/} 
	mv $i /ifs1/User/zhuang/metaBinall/CLEAN_READS/${name}_R1.fastq 
done

for i in ./*_350.fq2
do
	base=${i%_350.fq2} 
	name=${base##*/} 
	mv $i /ifs1/User/zhuang/metaBinall/CLEAN_READS/${name}_R2.fastq 
done
#############################
#############################
#############################

for i in ./CLEAN_READS/*_R1.fastq 
do
	base=${i%_R1.fastq} 
	name=${base##*/} 
	mv $i /ifs1/User/zhuang/metaBinall/CLEAN_READS/${name}_1.fastq 
	
done


for i in ./CLEAN_READS/*_R2.fastq 
do
	base=${i%_R2.fastq} 
	name=${base##*/} 
	mv $i /ifs1/User/zhuang/metaBinall/CLEAN_READS/${name}_2.fastq 
	
done
#############################
#############################
#############################