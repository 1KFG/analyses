require(plyr)

pdf("ks_Amac.pdf")

n <- read.table(file="../kaks/Amac.yn00.tab",header=TRUE,sep="\t")
prune_dS <- subset(n$dS,n$dS < 2)
                                        #summ = summary(n$dS)
                                        #print(summ)
hist(prune_dS,100,main='Allomyces macrogynus dS of paralogs')



