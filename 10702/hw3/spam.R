library("np")
print(getwd())
d <- 30
N <- 100
X <- matrix(runif(d*N),N)
Y = rep(0,N)
bw_d = rep(0,d)

for (i in 1:N) {
 Y[i] <- 3*X[i,1] + cos(5*X[i,2]) + exp(X[i,3]) + rnorm(1)
}

for (j in 1:5) {
	x_j <- X[,j]
	model.np <- npreg(Y ~ x_j,residuals=TRUE)
	bw_d[j] <- model.np$bw
	
}


