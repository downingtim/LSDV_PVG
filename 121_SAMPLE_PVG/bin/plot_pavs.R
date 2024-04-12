#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1) {
  cat("Usage: Rscript script.R <arg1> <arg2> ...\n")
  quit(status = 1) }

x <- read.csv(args[1], sep="\t")
str(x)
colnames(x) <- c("val")

pdf("mfs.pdf")
hist( x$val, breaks=62, xlab=c("Number of samples"),  ylab=c("Fraction of mutations"), main="", freq=F)  
dev.off()

quit()
n