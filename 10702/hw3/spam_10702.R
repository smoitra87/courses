library("np")
library("SpAM")

print(getwd())
d <- 30
N <- 100
X <- matrix(runif(d*N),N)
Y = rep(0,N)
bw_d = rep(0,d)
resid = matrix(runif(d*N),N)

for (i in 1:N) {
 Y[i] <- 3*X[i,1] + cos(5*X[i,2]) + exp(X[i,3]) + rnorm(1)
}

for (j in 1:6) {
	png(paste('spam_kern',j,'.png'))
	x_j <- X[,j]
	model.np <- npreg(Y ~ x_j,residuals=TRUE)
	bw_d[j] <- model.np$bw
	resid[,j] <- model.np$resid
	plot(model.np,plot.errors.method="asymptotic",
		plot.errors.style="band",main=paste("x",j))
	points(x_j,Y,cex=0.25)
	dev.off()	

	png(paste('resid_kern',j,'.png'))
	plot(resid[,j],main=paste("j=",j))
	dev.off()
}




png('spam1.png')  

#fit = spam(X,Y,lambda=seq(0.01,0.1,length=10))
fit = spam(X,Y,lambda=0.07)
#print(fit)
par(mfrow=c(2,5))

for( j in 1:10) {
	pred = fit[[1]]$predictor[[j]]
	m_j <- pred(seq(0,1,length=100))
	plot(seq(0,1,length=100),m_j,type="l",main=paste("j=",j))
	
}

dev.off()
	
# Pick lambda = 0.06 each time


