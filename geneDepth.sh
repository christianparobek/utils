## Script to get per-gene coverage depth
## USAGE: bash geneDepth.sh <vcf> <ref> <outname>
## Started 15 October 2015
## Christian Parobek

## Define useful variables
gff=$1
vcf=$2 # vcf to pull names out of
bedname=$3
bamdirectory=$4 # directory where bam files live
bamending=$5 # unique ending for bams I'm interested in (eg. "realn.bam")
workingdir=$6

## make folder for tmp files
mkdir $workingdir

# convert gff -> bed, include only unique gene entries
grep -v "^#" $gff | grep "gene" | cut -d$'\t' -f1,4,5 | sort -u > $workingdir/$bedname

## run a for loop for each individual in the vcf
for sample in `grep "CHROM" $vcf | cut -d$'\t' -f10-`
do 

	echo $sample
	echo -e "sample\tchromosome\tstart\tend\tcoverage\tlength\tcov_per_length" >> $workingdir/$sample\_per\_gene\_cov # add header
	bedtools coverage -d -a $workingdir/$bedname -b $bamdirectory$sample$bamending > $workingdir/$sample

	IFS=$'\n' # prevents \t -> \n conversion
	for gene in `cat $workingdir/$bedname`
	do
		totalcov=`grep $gene $workingdir/$sample | cut -d$'\t' -f5 | paste -sd+ | bc` # sum per-base cov
		echo -e "$sample\t$gene\t$totalcov" | awk 'NR >= 1 { $6 = $4 - $3 } {$7 = $5 / $6 } 1' >> $workingdir/$sample\_per\_gene\_cov
	done

	rm $workingdir/$sample

done
