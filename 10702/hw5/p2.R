# Program for computing gaussian kernels

#######################################################################
# Generate the data

N= 400
X=runif(N,-1,1)
sig_x = 0.2-0.1*cos(2*pi*X)
Y = rep(0,N)

m_func <- function(x) {

	if( x>=-1 && x< -0.5) {
		ret<- (x+2)^2/2
	}
	if(x >= -0.5 && x < 0) {
		ret<- x/2 + 0.875
	}
	if(x >= 0 && x < 0.5) {
		ret <- -5*(x-0.2)^2 + 1.075
	}
	if(x >= 0.5 && x <= 1) {
		ret<- x + 0.125
	}

	return(ret)
}

for(i in 1:N) {
	Y[i] = m_func(X[i]) + sig_x[i] + rnorm(1)
}

x_true <- seq(-1,1,0.01)
y_true <- rep(0,length(x_true))
for(i in 1:length(x_true)) {
	y_true[i] = m_func(x_true[i])
}


r_perm <- sample(1:N)
idx_train <-  r_perm[1:(N/2)]
idx_test <- r_perm[((N/2)+1):N]

X_train <- X[idx_train]
X_test <- X[idx_test]
Y_train <- Y[idx_train]
Y_test <- Y[idx_test]

#######################################################################
# Run Kernel Regression

#h_list <- c(0.001)
h_list <- seq(-2,2,by=0.1)
h_list <- 10^h_list
cv_err = rep(0,length(h_list))

for(i in seq(h_list)) {
	h = h_list[i]
	np_model <- npreg(bws=h,txdat=X_train,tydat=Y_train,eydat=Y_test,exdat=X_test,ckertype='gaussian',residuals=TRUE)
	cv_err[i] <- np_model$MSE
}


png('true_func.png')
plot(x_true,y_true,col='red')
par(new=T)
plot(X_train,Y_train,col='blue')
par(new=T)
plot(np_model,col='green')
dev.off()


png('cv_kreg.png')
plot(log10(h_list),cv_err,col='red',type='o')
title(main="Cross validation score")
dev.off()


# Pick the best cv error
h_min_idx = which.min(cv_err)
h_min = h_list[h_min_idx]

# Train with optimal bandith
np_model <- npreg(bws=h_min,txdat=X_train,tydat=Y_train,eydat=Y_test,exdat=X_test,ckertype='gaussian',residuals=TRUE)






