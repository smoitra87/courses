library("np")
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

par(mfrow=c(1,2))

for (j in 1:2) {
	x_j <- X[,j]
	model.np <- npreg(Y ~ x_j,residuals=TRUE)
	bw_d[j] <- model.np$bw
	resid[,j] <- model.np$resid
	plot(model.np,plot.errors.method="asymptotic",
		plot.errors.style="band",main=paste("x",j))
	points(x_j,Y,cex=0.25)
		
}


