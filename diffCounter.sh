## Count the nubmer of diffs between two VCF input files
## To respond to Reviewer #2's comment from AAC submission
## Started 25 November 2015
## This is the engine to count the number of differences

## USAGE: bash diffcounter /path/to/vcfs/dir first.vcf second.vcf


## Can speed up the process with a file of this:
## bash diffCounter.sh 03 11
## bash diffCounter.sh 03 12
## bash diffCounter.sh 03 13
## bash diffCounter.sh 03 14


###########################################
##### GET VARIANTS THAT AREN'T SHARED #####
###########################################


bedtools intersect -v -a $1/$2 -b $1/$3 > in_A_not_in_B.vcf
		# -v reports only entries in A w no overlaps in B

bedtools intersect -v -a $1/$3 -b $1/$2 > in_B_not_in_A.vcf
		# -v reports only entries in A w no overlaps in B

echo $1 $2
cat in_A_not_in_B.vcf in_B_not_in_A.vcf | wc -l
rm in_A_not_in_B.vcf
rm in_B_not_in_A.vcf
