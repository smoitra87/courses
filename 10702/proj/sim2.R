# Makes simulation runs using Glasso
#
# @author: smoitra@cs.cmu.edu

library('glasso')
library('huge')


# Define some constants
expid=3
SAVE_IMG =TRUE

# Generate some graphs using the huge package

# 50 dimensions
if(expid == 1) {
L1 = huge.generator(d=50,prob=0.3)
L2 = huge.generator(d=50,prob=0.8)
}
if(expid==2) {
L3 = huge.generator(d=50,graph='hub')
L4= huge.generator(d=50,graph='cluster')
}
#L5 = huge.generator(n=20,d=50,prob=0.3)
#L6 = huge.generator(n=500,d=50,prob=0.8)

# 200 dimensions
if(expid == 1) {
	G1 = huge.generator(d=200,prob=0.3)
	G2 = huge.generator(d=200,prob=0.8)
}
if(expid==2) {
G3 = huge.generator(d=200,graph='hub')
G4= huge.generator(d=200,graph='cluster') }

#G5 = huge.generator(n=20,d=200,prob=0.3)
#G6 = huge.generator(n=500,d=200,prob=0.8)
#FALSE

#----------------------------------------------------
# Examine dependence on p
if(expid == 1) {
	# compare L1 and G1
	out1 = huge(L1$data, method="glasso",verbose = TRUE)
	roc1 = huge.roc(out1$path,L1$theta)

	out2 = huge(G1$data, method="glasso",verbose = TRUE)
	roc2 = huge.roc(out2$path,G1$theta)
	
	# The roc curve spawns off a new window and we need to manually shut
	# it down
	dev.off(which=dev.cur())	

	if(SAVE_IMG) {
		print("Saving images")
		png('glasso_d50_p0.3.png',width=1000,height=800)
		plot(out1,align=TRUE)	
		dev.off(which=dev.cur())

		png('glasso_d200_p0.3.png',width=1000,height=800)
		plot(out2,align=TRUE)
		dev.off(which=dev.cur())
		#png('glasso_d200')

		# Plot the F1 and ROC curves
		png('roc_glasso_d50_p0.3.png',width=1000,height=800)
		par(mfrow=c(1,2))
		plot(out1$lambda,roc1$F1,type='o',main="F1 scores",
			xlab="Lambdas",ylab="F1 score")
		plot(roc1$fp,roc1$tp,type='o',main="ROC curve",
			xlab="FP",ylab="TP")
		dev.off(which=dev.cur())


		png('roc_glasso_d200_p0.3.png',width=1000,height=800)
		par(mfrow=c(1,2))
		plot(out1$lambda,roc2$F1,type='o',main="F1 scores",
			xlab="Lambdas",ylab="F1 score")
		plot(roc2$fp,roc2$tp,type='o',main="ROC curve",
			xlab="FP",ylab="TP")
		dev.off(which=dev.cur())
				
	} else {
		dev.new()
		plot(out1,align=TRUE)	
		dev.new()
		plot(out2,align=TRUE)

		# Plot the F1 and ROC curves for L1
		dev.new()
		par(mfrow=c(1,2))
		plot(out1$lambda,roc1$F1,type='o',main="F1 scores",
			xlab="Lambdas",ylab="F1 score")
		plot(roc1$fp,roc1$tp,type='o',main="ROC curve",
			xlab="FP",ylab="TP")
		
		# Plot the F1 and ROC curves for G1
		dev.new()
		par(mfrow=c(1,2))
		plot(out1$lambda,roc2$F1,type='o',main="F1 scores",
			xlab="Lambdas",ylab="F1 score")
		plot(roc2$fp,roc2$tp,type='o',main="ROC curve",
			xlab="FP",ylab="TP")
	
	}
	# compare L2 and G2
}
#---------------------------------------------------
# Examine dependence on prob


#---------------------------------------------------
# Examine dependency on density



#---------------------------------------------------
# Examine dependence on shape
if(expid==2) {
	# compare L1 and G3
	out1 = huge(L3$data, method="glasso",verbose = TRUE)
	roc1 = huge.roc(out1$path,L3$theta)

	out2 = huge(L4$data, method="glasso",verbose = TRUE)
	roc2 = huge.roc(out2$path,L4$theta)
	
	# The roc curve spawns off a new window and we need to manually shut
	# it down
	dev.off(which=dev.cur())	

	if(SAVE_IMG) {

		# Save the original images
		print("Saving original images")
		png('glasso_d50_hub_orig.png',width=1000,height=800)
		plot(L3)
		dev.off(which=dev.cur())

		png('glasso_d50_cluster_orig.png',width=1000,height=800)
		plot(L4)
		dev.off(which=dev.cur())

		# Save Glasso outputs

		print("Saving images")
		png('glasso_d50_hub.png',width=1000,height=800)
		plot(out1,align=TRUE)	
		dev.off(which=dev.cur())

		png('glasso_d50_cluster.png',width=1000,height=800)
		plot(out2,align=TRUE)
		dev.off(which=dev.cur())
		#png('glasso_d200')

		# Plot the F1 and ROC curves
		png('roc_glasso_d50_hub.png',width=1000,height=800)
		par(mfrow=c(1,2))
		plot(out1$lambda,roc1$F1,type='o',main="F1 scores",
			xlab="Lambdas",ylab="F1 score")
		plot(roc1$fp,roc1$tp,type='o',main="ROC curve",
			xlab="FP",ylab="TP")
		dev.off(which=dev.cur())


		png('roc_glasso_d200_pcluster.png',width=1000,height=800)
		par(mfrow=c(1,2))
		plot(out1$lambda,roc2$F1,type='o',main="F1 scores",
			xlab="Lambdas",ylab="F1 score")
		plot(roc2$fp,roc2$tp,type='o',main="ROC curve",
			xlab="FP",ylab="TP")
		dev.off(which=dev.cur())
				
	} else {
		dev.new()
		plot(out1,align=TRUE)	
		dev.new()
		plot(out2,align=TRUE)

		# Plot the F1 and ROC curves for L3
		dev.new()
		par(mfrow=c(1,2))
		plot(out1$lambda,roc1$F1,type='o',main="F1 scores",
			xlab="Lambdas",ylab="F1 score")
		plot(roc1$fp,roc1$tp,type='o',main="ROC curve",
			xlab="FP",ylab="TP")
		
		# Plot the F1 and ROC curves for L4
		dev.new()
		par(mfrow=c(1,2))
		plot(out1$lambda,roc2$F1,type='o',main="F1 scores",
			xlab="Lambdas",ylab="F1 score")
		plot(roc2$fp,roc2$tp,type='o',main="ROC curve",
			xlab="FP",ylab="TP")
	
	}
}

if(expid==3) {

# Load the package glasso
data(stockdata)
# Load the stock data
X = log(stockdata$data[2:1258,]/stockdata$data[1:1257,]) # Preprocessing
out.huge = huge(X,method = "glasso", nlambda=5)
plot(out.huge)

print("Saving images")
png('glasso_stock.png',width=1000,height=800)
plot(out1)	
dev.off(which=dev.cur())
}


#--------------------------------------------------
# Examine dependendence on normality




