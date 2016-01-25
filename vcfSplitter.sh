#!/usr/bin/env bash

## A script that splits an input VCF and outputs 
## to a given folder
## USAGE: vcfSplitter.sh <in.vcf> <ref.fasta> <out_dir_for_indivs>
## Started 17 December 2015
## Careful because right now this doesnt get rid of the empty entries (GT 0 issue)


###############################
### DEFINE USEFUL VARIABLES ###
###############################

gatk=/nas02/apps/biojars-1.0/GenomeAnalysisTK-3.3-0/GenomeAnalysisTK.jar


###############################
### GET COMMAND_LINE INPUT ####
###############################

vcf=$1
ref=$2
outdir=$3


###############################
####### SPLIT VCF FILES #######
###############################

mkdir $outdir

for name in `grep "CHROM" $vcf | cut -d$'\t' -f10-`
do


## SPLIT VCF INTO INDIVIDUAL VCFs
java -Xmx2g -jar $gatk \
	-T SelectVariants \
	-R $ref \
	--variant $vcf \
	-sn $name \
	-o $outdir/$name.vcf.tmp

grep -vP "PL\t0" $outdir/$name.vcf.tmp | grep -vP "\tGT\t." > $outdir/$name.vcf

rm $outdir/$name.vcf.tmp

done
