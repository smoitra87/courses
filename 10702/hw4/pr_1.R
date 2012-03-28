bin_pdf <- function(x) {
	x1 <- x[1]
	x2 <- x[2]
	x3 <- x[3]
	b0 <- -log(4+2*exp(2)+2*exp(4))
	b1 <- 2
	b12 <- 2
	val <- exp(b0+b1*x1+b12*x1*x2)
}
integer.base.b <-
function(x, b=2){
	xi <- as.integer(x)
	if(any(is.na(xi) | ((x-xi)!=0)))
		print(list(ERROR="x not integer", x=x))
	N <- length(x)
	xMax <- max(x)	
	ndigits <- (floor(logb(xMax, base=2))+1)
	Base.b <- array(NA, dim=c(N, ndigits))
	for(i in 1:ndigits){#i <- 1
		Base.b[, ndigits-i+1] <- (x %% b)
		x <- (x %/% b)
	}
	if(N ==1) Base.b[1, ] else Base.b
}

bin_vals <- integer.base.b(0:7)

p <- rep(0,8)
for(i in 1:8) {
	p[i] <- bin_pdf(bin_vals[i,])
}

samp <- sample(1:8,100,replace=TRUE,prob=p)

