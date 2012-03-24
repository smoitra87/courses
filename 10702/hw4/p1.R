nFunc <- 100
nPoints <- 200
for(ff in 1:nFunc) {
	s <- rnorm(nPoints)
	w <- rep(0,nPoints)
	b <- rbeta(nPoints,1,1)
	wsum <- 0
	for(i in 1:nPoints) {
		w[i] <- (1-wsum)*b[i]
		wsum <- wsum + w[i]
	}
}


