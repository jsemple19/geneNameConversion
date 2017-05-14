#2017-05-08 OBSOLETE - biomart no longer gives cosmid names. useless!!!!!!!
#2016-12-20
#convertingGeneNamesFunction.R
#script to convert c.elegans gene names in between wb, cosmid and public gene names 
#setwd("/media/jenny/670FC52648FA85C4/Documents/MeisterLab/GenomeVer/geneNameConversion")

library(biomaRt)

convertGeneNames<-function(inputList,inputType="wormbase_gene_seq_name",
                           outputType=c("external_gene_name","wormbase_gene", "wormbase_gene_seq_name")){
  ensembl = useMart("ensembl",dataset="celegans_gene_ensembl")
  ## need to properly test if input is correct.. needs work...
  # if (match(inputType, c("external_gene_name","wormbase_gene","wormbase_gene_seq_name"),nomatch=0)==0) {
  #   print("Please specify one of the following input types:")
  #   print("'external_gene_name', #[e.g. dpy-27]")
  #   print("'wormbase_gene', #[e.g. WBGene00005023]")
  #   print("'wormbase_gene_seq_name') #[e.g. T24D1.1]")
  # }
  # if (match(outputType, c("external_gene_name","wormbase_gene","wormbase_gene_seq_name"),nomatch=0)==0) {
  #   print("Please specify one of the following input types:")
  #   print("'external_gene_name', #[e.g. dpy-27]")
  #   print("'wormbase_gene', #[e.g. WBGene00005023]")
  #   print("'wormbase_gene_seq_name') #[e.g. T24D1.1]")
  # }
  conversionTable<-getBM(attributes=outputType, filters=inputType, values=inputList, mart = ensembl)
  ## need to deal with duplicates.. still needs work
  #convertedIDs<-conversionTable$wormbase_gene[match(as.vector(inputList[,1]),conversionTable[,inputType])]
  return(conversionTable)
}

