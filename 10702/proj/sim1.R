library('glasso')

set.seed(100)
x<-matrix(rnorm(50*20),ncol=20)
s<- var(x)
a<-glasso(s, rho=.01)
aa<-glasso(s,rho=.02, w.init=a$w, wi.init=a$wi)

png('glasso1.png');
x = aa$wi
x = x > 0
image(x)
dev.off()

#----------------------------------------------------------
# Part 2

#
## example with structural zeros and no regularization,
## from Whittaker’s Graphical models book page xxx.
#s=c(10,1,5,4,10,2,6,10,3,10)
#S=matrix(0,nrow=4,ncol=4)
#S[row(S)>=col(S)]=s
#S=(S+t(S))
#diag(S)<-10
#zero<-matrix(c(1,3,2,4),ncol=2,byrow=TRUE)
#a<-glasso(S,0,zero=zero)
