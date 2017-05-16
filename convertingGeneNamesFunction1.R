#2017-05-08 using table downloaded from wormMine
#script to convert c.elegans gene names in between wb, cosmid and public gene names
#setwd("/home/jenny/Documents/MeisterLab/GenomeVer/geneNameConversion")

# #downloaded from Worm Mine. using Query builder. Choosing attributes
# #Gene>sequence Name
# #Gene>WormBase Gene ID
# #Gene> Gene name
# # do once to pre-process table
# geneNameFile<-"~/Documents/MeisterLab/GenomeVer/geneNameConversion/20170514_wormMine_geneNameAttributes.tsv"
# GeneNameTable<-read.delim(geneNameFile, stringsAsFactors=FALSE,header=FALSE)
# names(GeneNameTable)<-c("WBgeneID","seqID","publicID")
# #remove strange duplicate names in the beginning
# GeneNameTable<-GeneNameTable[-grep("Gene:WBGene",GeneNameTable$WBgeneID),]
# #complete empty names in seqID and publicID one wiht the other
# GeneNameTable$seqID<-ifelse((GeneNameTable$seqID==""),GeneNameTable$publicID,GeneNameTable$seqID)
# GeneNameTable$publicID<-ifelse((GeneNameTable$publicID==""),GeneNameTable$seqID,GeneNameTable$publicID)
# sum(duplicated(GeneNameTable$publicID)) #46
# sum(duplicated(GeneNameTable$seqID)) #49
# sum(duplicated(GeneNameTable$WBgeneID)) #0
# #need to handle duplicates problem for proper matching. to it within funciton according to
# #input type
#
# write.table(GeneNameTable,"~/Documents/MeisterLab/GenomeVer/geneNameConversion/20170514_wormMine_geneNameAttributes.csv",
#             quote=FALSE,row.names=FALSE,sep=",")


convertGeneNames<-function(inputList,inputType="seqID",
                           outputType=c("seqID","WBgeneID","publicID")){
  geneNameFile<-"~/Documents/MeisterLab/GenomeVer/geneNameConversion/20170514_wormMine_geneNameAttributes.csv"
  GeneNameTable<-read.csv(geneNameFile, stringsAsFactors=FALSE,header=TRUE)

  #to make matching work, first remove duplicated genes for inputType from table
  GeneNameTable<-GeneNameTable[!duplicated(GeneNameTable[,inputType]),]

  #find genes  in the input list that have no matches
  i<-match(inputList,GeneNameTable[,inputType])
  nonMatching<-inputList[is.na(i)]

  #find genes that do match
  i<-na.omit(i)
  output<-GeneNameTable[i,c(inputType,outputType)]

  #now add back the nonMatching ones with NA values
  output_nm<-as.data.frame(matrix(nrow=length(nonMatching),ncol=dim(output)[2]),stringsAsFactors=FALSE)
  output_nm[,1]<-nonMatching
  names(output_nm)<-c(inputType,outputType)
  output<-rbind(output,output_nm)

  #reorder output table to match input list table
  i<-match(inputList,output[,1])
  output<-output[i,]
  #remove column of duplicated inputType if present
  if (inputType %in% outputType) {
    output<-output[,-grep(".1",names(output))]
  } else {
    output<-output[,-grep(inputType,names(output))]
  }
  return(output)
}

