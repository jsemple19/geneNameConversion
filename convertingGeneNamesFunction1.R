#2017-05-08 using table downloaded from wormMine
#script to convert c.elegans gene names in between wb, cosmid and public gene names 
#setwd("/home/jenny/Documents/MeisterLab/GenomeVer/geneNameConversion")

#downloaded from Worm Mine. using Query builder. Choosing attributes
#Gene>sequence Name
#Gene>WormBase Gene ID
#Gene> Gene name

# do once
# GeneNameTable<-read.table("/home/jenny/Documents/MeisterLab/GenomeVer/geneNameConversion/wormbaseNameConversion.tsv",stringsAsFactors=FALSE)
# names(GeneNameTable)<-c("seqID","WBgeneID","geneName")
# GeneNameTable<-GeneNameTable[GeneNameTable$seqID!="",]
# temp<-GeneNameTable$geneName
# GeneNameTable$geneName<-GeneNameTable$seqID
# i<-which(temp!="")
# GeneNameTable$geneName[i]<-temp[i]
# write.csv(GeneNameTable,"/home/jenny/Documents/MeisterLab/GenomeVer/geneNameConversion/wormbaseNameConversion.csv",
#           row.names=FALSE)

#GeneNameTable<-read.csv("/home/jenny/Documents/MeisterLab/GenomeVer/geneNameConversion/wormbaseNameConversion.csv",stringsAsFactors=FALSE)

convertGeneNames<-function(inputList,inputType="seqID",
                           outputType=c("seqID","WBgeneID","geneName")){
  GeneNameTable<-read.csv("/home/jenny/Documents/MeisterLab/GenomeVer/geneNameConversion/wormbaseNameConversion.csv",
                            stringsAsFactors=FALSE)

  i<-match(GeneNameTable[,inputType],inputList)
  output<-GeneNameTable[i,outputType]
  
  ## need to deal with duplicates.. still needs work
  #convertedIDs<-conversionTable$wormbase_gene[match(as.vector(inputList[,1]),conversionTable[,inputType])]
  return(output)
}

