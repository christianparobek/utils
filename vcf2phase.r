## Convert VCF format to PHASE format

# numindivs
# numloci
# space-delim loci positions
# genotype in 0 or 1

###################################################
################# IMPORTANT NOTE ##################
###################################################

# The multiVCF that we feed this script
# must have "#CHROM" replaced with "CHROM".
# So run this: sed 's/#CHROM/CHROM/' in.vcf > out.vcf

###################################################
################# LOAD LIBARIES ###################
###################################################

library(stringr)

###################################################
################ DEFINE FUNCTIONS #################
###################################################

## Given a multiVCF, get the genotypes
genoGet <- function(dataset) {
  
  ## REMOVE FIRST NINE COLUMNS FROM THE MULTIVCFs
  data <- dataset[-c(1:9)]
  geno <- as.data.frame(sapply(data, function(x) str_extract(x, "[0123456789]")))
  
}

## Given a list, print each element to new line of file
listWriter <- function(list, filename) {
  
  length(list)
  
  for (i in 1:length(list)) {
  
  write.table(megalist[[i]], filename, append = TRUE, quote = FALSE, row.names = FALSE, col.names = FALSE)
  
  }
}



###################################################
################## READ IN DATA ###################
###################################################

## READ IN THE Pf AND Pv MULTIVCFs
pf <- read.table("../cambodiaWGS/pv/variants/our_goods_UG.pass.vcf", comment.char="#", header=FALSE)

chr06 <- pf[pf$V1 == "Pv_Sal1_chr06",]

genos <- genoGet(chr06)

megalist <- list()
megalist$nsam <- ncol(genos)
megalist$ngenos <- nrow(genos)
megalist$pos <- paste("P", paste(chr06$V2, collapse = " "))
megalist <- c(megalist, as.list(apply(genos, 2, paste, collapse = "")))

listWriter(megalist, "chr06.txt")
