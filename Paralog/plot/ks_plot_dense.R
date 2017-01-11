require(plyr)

filenames <- list.files("../kaks", pattern="*.tab", full.names=TRUE)
pdf("ks_6maxi_dense.pdf")
par(mfrow=c(8,8))

for (i in seq_along(filenames)) {
 # print(filenames[i])
  short = gsub(".yn00.tab","",filenames[i])
  shortname = substr(short,9,30)
  
  #print(shortname)
  n <- read.table(file=filenames[i],header=TRUE,sep="\t")

  prune_dS <- subset(n$dS,n$dS < 6)
                                        #summ = summary(n$dS)
                                        #print(summ)
  if ( length(prune_dS) > 50 ) { # make sure at least 10 paralog pairs
    summ = summary(prune_dS)
   # print(summ)
    lbl = sprintf("%s",shortname)
    hist(prune_dS,50,main=lbl)
  }
}


pdf("ks_2max_dense.pdf")
par(mfrow=c(8,50))

for (i in seq_along(filenames)) {
 # print(filenames[i])
  short = gsub(".yn00.tab","",filenames[i])
  shortname = substr(short,9,30)
  
  n <- read.table(file=filenames[i],header=TRUE,sep="\t")
  prune_dS <- subset(n$dS,n$dS < 2)
                                        #summ = summary(n$dS)
                                        #print(summ)
  if ( length(prune_dS) > 50 ) { # make sure at least 10 paralog pairs
    summ = summary(prune_dS)
#    print(summ)
    lbl = sprintf("%s",shortname)
    hist(prune_dS,50,main=lbl)
  }
}

