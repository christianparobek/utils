## Script to turn a multivcf into a multifasta
## USAGE: bash multivcf2fasta.sh <vcf> <ref> <dir with gatk-style interval file(s)> # <outname>
## Started 14 October 2015
## Christian Parobek

## Define useful variables
gatk=/nas02/apps/biojars-1.0/GenomeAnalysisTK-3.3-0/GenomeAnalysisTK.jar
vcf=$1
ref=$2
intervaldir=$3
#outname=$4
time=`date +"%F_%T"`

## make folder for tmp files
mkdir "tmp_$time"

## run a for loop for each individual in the vcf
for name in `grep "CHROM" $vcf | cut -d$'\t' -f10-`
do 

## SPLIT VCF INTO INDIVIDUAL VCFs
java -Xmx2g -jar $gatk \
	-T SelectVariants \
	--variant $vcf \
	-R $ref \
	-sn $name \
	-o tmp_$time/$name.vcf

## REMOVE ALL NON-ENTRIES IN INDIVIDUAL FILES (PL=0 & GT=0)
grep -vP "PL\t0" tmp_$time/$name.vcf | grep -vP "\tGT\t." > tmp_$time/$name.sans0.vcf

for interval in `ls $intervaldir`
do
	## VCF TO FASTA
	java -Xmx2g -jar $gatk \
		-T FastaAlternateReferenceMaker \
		-R $ref \
		--variant tmp_$time/$name.sans0.vcf \
		-L $intervaldir$interval \
		-o tmp_$time/$name$interval.fa
	#		 --rawOnelineSeq prints only sequence

	echo ">"$name >> tmp_$time/$interval.fa
	grep -v ">" tmp_$time/$name$interval.fa >> tmp_$time/$interval.fa
	rm tmp_$time/$name$interval.fa

done

rm tmp_$time/*vcf*

done

