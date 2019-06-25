#variables to alter before running

FileName = "TEST.csv";
Path = "C:\\Users\\brons\\Desktop";
FirstColumnToScan = 1;
LastColumnToScan = 4;
Output_File = '.csv'

#end variables

#begin script

library(robustbase);
library(tidyverse);
setwd(Path)
OriginalData <- read.csv(FileName);
NewData <- OriginalData;

for (column in FirstColumnToScan:LastColumnToScan){
	Z1 <-adjOutlyingness(OriginalData[,column]);
	OutlierRows <- which(Z1$nonOut == FALSE);
	print(OutlierRows)
	NewData[OutlierRows,column] <- -Inf;
	NonOutMax <- max(NewData[,column]);
	NewData[OutlierRows,column] <- Inf;
	NonOutMin <- min(NewData[,column]);

	LessThanMin <- which(OriginalData[,column] < NonOutMin)
	NewData[LessThanMin,column] <- NonOutMin;
	MoreThanMax <- which(OriginalData[,column] > NonOutMax)
	NewData[MoreThanMax,column] <- NonOutMax;
	
}  

write.csv(NewData,paste(strsplit(FileName,'.csv'),'_AO_W','.csv',sep=''))