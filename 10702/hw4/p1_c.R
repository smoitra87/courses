mu=10
sig=4
nPt=10
X = rnorm(nPt,mean=mu,sd=sqrt(4))
alpha=1


png('1c_1.png')
plot(X,rep(1,nPt),type="p",col="red",xlim=c(0,20))
lines(X,rep(1,nPt),type='h',col="blue")
dev.off()

Fn <- ecdf(X) # The emperical cdf function
F0 <- (function(x){pnorm(x,mean=0,sd=1)})
F <- (function(x){pnorm(x,mean=mu,sd=sig)})

create_bayes_est <- function(alpha,n,F0,Fn) {
	
	return(function(x){n/(alpha+n)*Fn(x) + alpha/(alpha+n)*F0(x)})
}
bayes_est <- create_bayes_est(alpha=alpha,n=nPt,F0=F0,Fn=Fn)

# Plot F vs Bayes estimator
png('1c_2.png')
x <- seq(-5,20,by=0.1)
plot(x,F(x),col="red",main="Plot of F vs Bayes est",ylab="cdf",type="l")
par(new=T)
plot(x,bayes_est(x),col="green",type="l")
dev.off()
#par(new=T)

#Draw 1000 random distribution functions from posterior

sample_post <- function(size) {
	samp <- rep(1,size)
	alpha = 1
	for(i in 1:size) {
		toss <- rbinom(1,1,alpha/(alpha+nPt))
		samp[i] <- toss*rnorm(1) + (1-toss)*sample(knots(Fn),1)
	}
	return(samp)
}

nFunc <- 1000
nPoints <- 100
alpha=alpha + nPt
S <- matrix(rep(0,nFunc*nPoints),nFunc)
W <- matrix(rep(0,nFunc*nPoints),nFunc)
S_s <- matrix(rep(0,nFunc*nPoints),nFunc)
W_cdf <- matrix(rep(0,nFunc*nPoints),nFunc)
png("1c_3.png")


for(ff in 1:nFunc) {
	s <- sample_post(nPoints)
	# Get nPoints points from estimator
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
	#plot(c(s_sorted[1]-3,s_sorted,s_sorted[length(s_sorted)]+3),c(0,w_cdf,1),type = "s",xaxt="n", xlab = "x", ylab = "F(x)", main = "Cumulative distribution function",col="blue",yaxt="n")
	#par(new=T)
}

# Returns cdf of sample distribution
pdraw <- function(w_cdf,s_s,x) {
	if(x<s_s[1]) {
		return(0)
	}
	if(x >= s_s[length(s_s)]) {
		return(1)
	}
	
	for(i in 1:length(s_s)-1) {
		if(x>=s_s[i] && x<s_s[i+1]){
			return(w_cdf[i])
		}
	}
}

# cdf of some chosen points
seq_chosen <- seq(-5,20,by=0.5)
cdf_chosen <- matrix(rep(0,nFunc*length(seq_chosen)),nFunc)
 
for(ff in 1:nFunc) {
	w_cdf <- W_cdf[ff,]
	s_s <- S_s[ff,]
	for(i in 1:length(seq_chosen)) {
		x <- seq_chosen[i]	
		cdf_chosen[ff,i] <- pdraw(w_cdf,s_s,x)
	}
}


# Plot the mean distribution
mean_chosen <- colMeans(cdf_chosen)
sd_chosen <- sd(cdf_chosen)
interval <- sd_chosen*qnorm(0.975)
plot(seq_chosen,mean_chosen,type="l",col="blue",lwd=5,main="Posterior Band")
lines(seq_chosen,mean_chosen-interval,type="l",lty=3,col="magenta",lwd=3)
#par(new=T)
lines(seq_chosen,mean_chosen+interval,type="l",lty=3,col="magenta",lwd=3)


#x <- seq(-5,20,by=0.1)
# Plot the true distribution
lines(seq_chosen,F(seq_chosen),type="l",col="red",lwd=5)
dev.off()





