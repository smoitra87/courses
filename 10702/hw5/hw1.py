"""
Code for homework1

"""


import numpy as np
import pylab as pl
import scipy as sc
from scipy.stats import norm


#----------------------------------------------------------------------
# Generate points, set up the problem

N = 25

def gen_mixture() : 
	z = np.random.rand() < 1.0/3 and 1 or 0
	return np.random.normal(loc=0,scale=1)*z +\
		 (1-z)*np.random.normal(loc=3,scale=1)

samples=  np.zeros(N)
for i in range(N) : 
	samples[i] = gen_mixture()


#----------------------------------------------------------------------
# Case 1 :  EM algorithm

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
