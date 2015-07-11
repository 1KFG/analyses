library(gplots)
library(fastcluster)
library(RColorBrewer)
library(colorRamps)
library(pheatmap)   
#library(amap)
library(ape)

palette <- colorRampPalette(c('blue','white','red'))(100)
#palette <- greenred(100)

pdf("CAZY_1KFG_small.pdf",height=25,width=25)

cazy <- read.table("cazy_small.dat",header=T,sep="\t",row.names=1);
gm <- data.matrix(cazy)

ch <- 5
cw <- 5

#head(gm)
fs_row = 6
fs_col = 5
#res <- pheatmap(head(gm,30), main="CAZY", fontsize_row = fs_row,
#         fontsize_column = fs_col,
#         cluster_cols = TRUE, cluster_rows = TRUE,
#         col = palette, scale="row",
#         cellheight = ch,
#         cellwidth  = cw,
#         legend = T,
#                                        # Rowv=NA,Colv=NA,
#         );

gmt <- t(gm)
res_t <- pheatmap(gmt, main="CAZY", fontsize_row = fs_row,
         fontsize_col = fs_col,
         cluster_cols = TRUE, cluster_rows = TRUE,
         col = palette, scale="column",
         cellheight = ch,
         cellwidth  = cw,
         legend = T,
                                        # Rowv=NA,Colv=NA,
         );

#cutree(res_t$tree_row, k = 10)
#data.frame(cluster = cutree(res_t$tree_row, k = 10))

d <- dist(gmt)
n <- hclust(d)

plot(n)
