# 2016-11-17
# convertingGeneNames.R
# Script to interconvert different gene name types from wormbase. 
# (wormbase Converter tool didn't convert a list with duplicate names, and
# when given a list of unique Ids, it output a larger number of Ids than the input,
# making it impossible to use on this scale)
# Note: one possible caveat is that this script uses the latest genome assembly, and does not
# convert between assemblies as does wormbase Converter (but gene names mostly stable in C. elegans)

library(biomaRt)

### load the C. elegans ensembl mart
#ensembl=useMart("ensembl")
#grep("elegans",listDatasets(ensembl)[[2]])
#listDatasets(ensembl)[[2]][14]
#ensembl = useDataset("celegans_gene_ensembl",mart=ensembl)

ensembl = useMart("ensembl",dataset="celegans_gene_ensembl")


### choose your filter (type of data you are wanting to convert)
#filters=listFilters(ensembl)
#filts<-grep("_gene",filters[[1]])
#cbind(filters[[1]][filts],filters[[2]][filts])
#myFilts<-filters[[2]][filts[c(2,4,6,7)]]

myFilt<-"wormbase_gene_seq_name"
# all gene name types (choose the one that matches the input data you want to convert):
#c("with_wormbase_gene" ,
#"external_gene_name", #[e.g. dpy-27]
#"wormbase_gene", #[e.g. WBGene00005023]
#"wormbase_gene_seq_name") #[e.g. T24D1.1]


### choose the attributes (output data types for genes in your list)
#attributes = listAttributes(ensembl)
#atts<-grep ("gene",attributes[[1]])
#attributes[[1]][atts]

# output all three gene types:
myAtts<-c("external_gene_name", #[e.g. dpy-27]
  "wormbase_gene", #[e.g. WBGene00005023]
  "wormbase_gene_seq_name") #[e.g. T24D1.1]

# import the list of Ids you want to convert (single column txt file)
Ids2convert<-read.table("chenIDs_public.txt")
# create conversion table for all your genes with all three gene name types
conversionTable<-getBM(attributes=myAtts, filters = myFilt, values=Ids2convert,mart = ensembl)
#save table as R object for future use
saveRDS(conversionTable,file="geneNameConversion.R") 

#Note it doesn't convert complete list as is, but rather it gives back a table with unique entries... 
#so need to convert original list using match():
convertedIds<-conversionTable$wormbase_gene[match(as.vector(Ids2convert[,1]),conversionTable$wormbase_gene_seq_name)]
# save the converted list
write.table(convertedIds,file="ChenIDs_WB.txt",quote=FALSE,row.names=FALSE, col.names=FALSE)
# check for failures:
which(is.na(convertedIds))
# there are 211 NAs. looking manually at first few in cel235 assembly in wormbase they say that the whereabouts of
# this gene is unknown. (one is a pseudogene)... just ignore them.