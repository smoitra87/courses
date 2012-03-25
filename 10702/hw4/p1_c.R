mu=10
sig=4
nPt=10
X = rnorm(nPt,mean=mu,sd=sqrt(4))

png('1c_1.png')
plot(X,rep(1,nPt),type="p",col="red",xlim=c(0,20))
lines(X,rep(1,nPt),type='h',col="blue")
dev.off()
