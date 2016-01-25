## Script to annotate a VCF
## USAGE: bash snpEffer.sh <database> <vcf> <ref> <outvcf>
	## Pf database: Pf3D7v90
## Started 31 October 2015
## Christian Parobek


## Define useful variables
vcf=$1
outvcf=$2


java -Xmx4g -jar ~/snpEff/snpEff.jar -v -o gatk Pf3D7v90 $vcf > $outvcf
