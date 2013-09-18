#! /usr/bin/env python

#######################################################################
# Deep Learning Lab 1  : Perceptron Learning Rule
# Author : Subhodeep Moitra(smoitra@cs.cmu.edu) 
#######################################################################


import os,sys
from theano import tensor as T
from theano import function,shared
from itertools import product
from operator import xor

import numpy as np


if __name__ == '__main__' : 
	
	X = list(product([0,1],[0,1]))
	X = [[1]+list(t) for t in X]
	
	x,y = T.vector('x'),T.scalar('y')
	w = shared(np.random.randn(3),name='w')
	
	# Contruct the theano expression graph
	o = (T.dot(x,w) > 0)*2-1
	e = y-o
	eta = 0.1

	learn = function(
				inputs=[x,y],
				outputs=[o,e],
				updates=[(w,w+eta*e*x)]	)

	predict = function(inputs=[x],outputs=o)


	def train(X,Y) :
		converged = False
		w.set_value(np.random.randn(3))
		tries = 0
		while not converged:
			errorCount = 0
			for x_,y_ in zip(X,Y) : 
				o,e = learn(x_,y_)
				if e != 0 : 
					errorCount += 1
			if errorCount == 0 : 
				converged = True
			tries +=1
			if tries > 100 : 
				print("###### Not Converged ######")
				break

		print("Final weights are:")
		print(w.get_value())

		return w

	# or
	Y = map(lambda(_,a,b) : (a or b)*2-1,X)	
	w = train(X,Y)

	# and
	Y = map(lambda(_,a,b) : (a and b)*2-1,X)
	w = train(X,Y)
	
	# xor
	Y = map(lambda(_,a,b) : (a^b)*2-1,X)
	w = train(X,Y)

	 

	


