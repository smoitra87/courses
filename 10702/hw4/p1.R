nFunc <- 100
nPoints <- 100
alpha=1
mu=0
S <- matrix(rep(0,nFunc*nPoints),nFunc)
W <- matrix(rep(0,nFunc*nPoints),nFunc)
S_s <- matrix(rep(0,nFunc*nPoints),nFunc)
W_cdf <- matrix(rep(0,nFunc*nPoints),nFunc)
png("1b.png")

for(ff in 1:nFunc) {
	s <- rnorm(nPoints)
	w <- rep(0,nPoints)
	b <- rbeta(nPoints,1,alpha)
	wsum <- 0
	for(i in 1:nPoints) {
		w[i] <- (1-wsum)*b[i]
		wsum <- wsum + w[i]
	}
	S[ff,] <- s
	W[ff,] <- w
	s_ <- sort(s,index.return=TRUE)
	w_sorted <- w[s_$ix]
	s_sorted <- s_$x
	w_cdf <- w_sorted
	for(i in 2:nPoints) {
		w_cdf[i] <- w_cdf[i] + w_cdf[i-1]
	}
	W_cdf[ff,] <- w_cdf
	S_s[ff,] <- s_sorted
	plot(c(s_sorted[1]-3,s_sorted,s_sorted[length(s_sorted)]+3),c(0,w_cdf,1),type = "s",xaxt="n", xlab = "x", ylab = "F(x)", main = "Cumulative distribution function",col="blue")
	par(new=T)
}

# Now plot the Mean of all the Fs and also F0
mean_w <- colMeans(W_cdf)
mean_s <- colMeans(S_s)
F0 <- pnorm(seq(-5,5,0.01))

#plot(mean_s,mean_w,type="s",col="blue")
#par(new=T)
plot(seq(-5,5,0.01),F0,type="s",col="red",lwd=5)
dev.off()



