#!/bin/bash
####调用metawrap中的metabat2 maxbin2   软件；concoct效率低，舍去
####################目录改成自己的工作目录
####################################################
#######metaWRAP：https://github.com/bxlab/metaWRAP

metawrap binning -o result/INITIAL_BINNING \
-t 64 \
-l 2500 -a ASSEMBLY/final.contigs.fa \
--metabat2 --maxbin2  CLEAN_READS/*fastq --universal
########调用semibin2  BAM文件在metawrap中已生成（bwa软件），也可自己根据fq 生成
#############################
#############################
#############################
####semibin2：https://github.com/BigDataBiology/SemiBin

SemiBin2 single_easy_bin -i ./ASSEMBLY/final.contigs.fa \
-b ~/metaBinall/sambam/bam/*.bam \
-p 64 
-o SemiBin2/coassembly_output \
-r /yourpath/gtdb/release214 
#############################
#############################
#############################

############################DAS_Tool分箱整合
#DAS Tool 1.1.6 
###DAS Tool： https://github.com/cmks/DAS_Tool


#maxbin2:629
#metabat2数目：529
#SemiBin2数目：1716
#####最终：2874个bin
#####DAS_Tools数目后：289
DAS_Tool -i SemiBin2.tsv,metabat2.tsv,maxbin2.tsv \
-l SemiBin2,metabat2,maxbin2 \
-c /yourpath/final.contigs.fa \
.-t 64 --write_bins \
-o output/bin \
--write_bin_evals 
#############################
#############################
####checkm流程   v1.2.2
#######CheckM：https://github.com/Ecogenomics/CheckM

####Bin_sort_all DAS_Tools 生成的bin,重命名后
checkm lineage_wf Bin_sort_all checkmouput_all --tab_table -f checkm_all.tab -x fa -t 64 
###completeness 50 & contamination 10: 191 
###completeness 50 & contamination 5: 113
###completeness 90 & contamination 10: 65
###completeness 90 & contamination 5: 34
#############################
#############################
#############################