# datasets from 1KFG genomes  - http://1000.fungalgenomes.org
dat <-read.csv("genome_stats.csv",header=T,sep=",",row.names=1)
summary(dat)
pdf("genome_size_gene_stat.pdf")

#boxplot(dat$genome,main="Genome Size")
#boxplot(dat$CDS,main="CDS count")
plot(dat$genome,dat$CDS,main="Fungal genome size vs CDS count (N=338)",xlab="Genome Size",ylab="Gene count")

png("genome_size_gene_stat.png")
plot(dat$genome,dat$CDS,main="Fungal genome size vs CDS count (N=338)",xlab="Genome Size",ylab="Gene count")

fit <- lm(formula = dat$genome ~ dat$CDS)
summary(fit)
summary(fit)$r.squared
cor(dat$genome, dat$CDS)**2
summary(dat)
