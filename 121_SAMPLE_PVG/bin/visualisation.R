#!/usr/bin/env Rscript

library(ggplot2)
name1 <- ""
h1 <- read.csv(paste(name1, "heaps.txt", sep=""), sep="\t") 
colnames(h1) <- c("a", "b", "pangenome")

ggplot()  + geom_point(aes(x=121:2/121, y=h1$pangenome), color="red", size=1.5, alpha=0.9)  +
	  geom_line(aes(x=121:2/121, y=h1$pangenome),  col="red",  linewidth=1.5, alpha=0.9) +
	  scale_y_continuous(limits = c(0, 160000))  + labs(x = "Fraction of samples") +
	  labs(y = "Number of bases in paths") + theme(legend.position="top") + guides()

