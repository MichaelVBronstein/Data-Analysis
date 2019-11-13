#variables to alter before running

FileName = "TEST.csv";
Path = "*INSERT PATH WHERE DATA IS LOCATED HERE*";
FirstColumnToScan = 1;
LastColumnToScan = 5;
Output_File = "NewData"

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
	if (length(OutlierRows) > 0) {
		print(paste("Outliers Detected in Column: ", column))
		print(paste("Outliers in row(s): ", OutlierRows))
	}
	NewData[OutlierRows,column] <- -Inf;
	NonOutMax <- max(NewData[,column]);
	NewData[OutlierRows,column] <- Inf;
	NonOutMin <- min(NewData[,column]);

	LessThanMin <- which(OriginalData[,column] < NonOutMin)
	NewData[LessThanMin,column] <- NonOutMin;
	MoreThanMax <- which(OriginalData[,column] > NonOutMax)
	NewData[MoreThanMax,column] <- NonOutMax;
	
}  

write.csv(NewData,paste(strsplit(Output_File,'.csv'),'_AO_W','.csv',sep=''))
