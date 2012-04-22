"""
Code for homework1

"""


import numpy as np
import pylab as pl
import scipy as sc
from scipy.stats import norm
from scipy.stats import beta as beta_


#----------------------------------------------------------------------
# Generate points, set up the problem

run_method = "Gibbs"
N = 25
alpha,beta = 4,4

def gen_mixture() : 
	z = np.random.rand() < 1.0/3 and 1 or 0
	return np.random.normal(loc=0,scale=1)*z +\
		 (1-z)*np.random.normal(loc=3,scale=1)

samples=  np.zeros(N)
for i in range(N) : 
	samples[i] = gen_mixture()


#----------------------------------------------------------------------
# Case 1 :  EM algorithm


if run_method == "EM":
	# init value of p
	p_old = np.random.rand() # unif(0,1)
	
	
	n_iter = 1000
	
	T = np.zeros(N)
	
	for j in range(n_iter) : 
		# E-step	
	
		p_z0 = norm.pdf(samples,loc=0,scale=1)*p_old;
		p_z1 = norm.pdf(samples,loc=3,scale=1)* (1-p_old)
	
		f_div = lambda(x,y) :  (0.0+x)/(x+y)
		T = np.array(map(f_div,zip(p_z0,p_z1)))
	
		# M-step
		p_new  = np.sum(T)/ (np.sum(T) + np.sum(1-T))
		p_old = p_new
	
	
	print("The Mixining param p=%f"%(p_new))	

#----------------------------------------------------------------------
# The Gibbs algorithm 

if run_method == "Gibbs" : 
	n_gibbs = 100
	
	p_arr = np.zeros(n_gibbs)
	
	# Set the z's initially to something
	f_bern = lambda x : x < 0.5 and 1 or 0
	z = np.array(map(f_bern,np.random.rand(N)))
	
	def draw_gibbs_z(x,p)  :
		"""  Draw from the gibbs dist """
		z0 =  p*norm.pdf(x,loc=0,scale=1)
		z1  = (1-p)*norm.pdf(x,loc=3,scale=1)
		theta = (0.0+z0)/(z0+z1)
		return np.random.rand() < theta and 1 or 0
	
	for ii in range(n_gibbs)  :
		p = np.random.beta(alpha+np.sum(z),beta+N-np.sum(z))	
		draw_gibbs_z2 = lambda (x) : draw_gibbs_z(x,p)
		z = np.array(map(draw_gibbs_z2,samples))
		p_arr[ii] = p
	
	
	pl.plot(p_arr)
	pl.xlabel('Iteration')
	pl.ylabel('sample of p')
	pl.title('Trace plot of p')
	pl.savefig('gibbs.png')	
	pl.close()


	pl.figure()
	pl.title('Approximate posterior obtained by Gibbs')
	pl.ylabel('Posterior Density')	
	
	rv = beta_(alpha+np.sum(z), beta+N-np.sum(z))
	x = np.linspace(0, rv.dist.b)
	h = pl.plot(x, rv.pdf(x))
	pl.savefig('gibbs_approx_post.png')



