nFunc <- 100
nPoints <- 100
alpha=1
mu=0
S <- matrix(rep(0,nFunc*nPoints),nFunc)
W <- matrix(rep(0,nFunc*nPoints),nFunc)

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
	plot(c(s_sorted[1]-3,s_sorted,s_sorted[length(s_sorted)]+3),c(0,w_cdf,1),type = "s", xlab = "x", ylab = "F(x)", main = "Cumulative distribution function", las = 1)
	par(new=T)
}




