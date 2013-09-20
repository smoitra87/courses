#! /usr/bin/env python

#######################################################################
# Backpropogation for Neural Networks
# Deep Learning Lab 1 
# Author: Subhodeep Moitra (smoitra@cs.cmu.edu)
#######################################################################

import os,sys

import theano
from theano import tensor as T
from theano import shared,function
import numpy as np

from itertools import product


class NeuralNetwork(object) : 
	""" simple Implementation of a 2 layer neural network """
	def __init__(self,ni,nh,no,eta=0.1,lam=0) :
		self.ni = ni+1
		self.nh = nh
		self.no = no
		self.eta = eta
		self.lam = lam

		##TODO : Remove if not usin theano
#		# Create the activation variables
#		self.ai = shared(np.ones(self.ni),name='ai')
#		self.ah = shared(np.ones(self.nh),name='ah')
#		self.ao = shared(np.ones(self.no),name='ao')
#
#		# Create the delta variables
#		self.dh = shared(np.zeros(self.nh),name='dh')
#		self.do = shared(np.zeros(self.no),name='do')

		# Create the weight matrices
		wih = shared(np.random.uniform(-2,2,(self.ni,self.nh)))
		who = shared(np.random.uniform(-2,2,(self.nh,self.no)))
		self.wih = wih.get_value()
		self.who = who.get_value()


		# Create the input variables
		ai = T.vector('ai')
	
		# Create the target variables
		t = T.vector('t')

		# Create the layers
		ah = 1/(1+T.exp(-T.dot(ai,wih)))
		ao = 1/(1+T.exp(-T.dot(ah,who)))

		# Create the loss function 
		sqloss = 0.5*((t-ao)**2).sum() 
		loss = sqloss + 0.5*self.lam*((wih.ravel()**2).sum()\
				+(who.ravel()**2).sum())
		
		# Get the gradients
		gwih,gwho = T.grad(loss,[wih,who])

		# Create the gradient descent training function 
		self.train_gradient = function(inputs=[ai,t],
							outputs=[loss,ao],
							updates=[(wih,wih-eta*gwih),\
								(who,who-eta*gwho)])
		
		self.predict = function(inputs=[ai],outputs=ao)

		self.get_weights = function(inputs=[],outputs=[wih,who])


	def train(self,x,t,mode='theano') : 
		""" Delegate training to appropriate scheme """

		# Add a 1 dummy input for bias
		x = [[1.]+list(tup) for tup in x]

		if mode == 'theano' :
			self._train_theano(x,t)
		else :
			self._train_backprop(x,t)

	def _train_theano(self,x,t,maxIter=10e3,eps=10e-3) : 
		""" Train using Theano gradient calculations"""
		print('-'*20+'Training with Theano'+'-'*20)
		converged = False
		currIter = 0
		loss,prevloss = sys.maxint,0

		while not converged and currIter < maxIter :
			loss = 0 
			for x_,t_ in zip(x,t) : 
				# Loop over every training instance
				instanceLoss,out = self.train_gradient(x_,t_)
				loss += instanceLoss
			if np.abs(loss- prevloss) < eps : 
				converged = True

			# print progress
			if currIter%100 :
				print('iter:{0} ; loss:{1}'.format(currIter,loss)) 				
			prevloss = loss # save current loss
			currIter +=1 # Increment Iter count

		# Set the final weights
		self.wih,self.who = self.get_weights()


		print("########Final weights are:#########")
		print("Weights: Input -> Hidden")
		print(self.wih)
		print("Weights: Hidden -> Output")
		print(self.who)
		print("Predictions :")
		for x_ in x : 
			print(x_[1:],'->',self.predict(x_))

	def _train_backprop(self,x,t) : 
		""" Train using backpropagation"""
	
		# Create the weight matrices
		wih = np.random.uniform(-2,2,(self.ni,self.nh))
		who = np.random.uniform(-2,2,(self.nh,self.no))

		# Create the activation variables
		ai = np.ones(self.ni)
		ah = np.zeros(self.nh)
		ao = np.zeros(self.no)

		# Create the deltas
		dh = np.zeros(self.nh)
		do = np.zeros(self.no)

		# Create the layers
		self.ah = 1/(1+T.exp(-T.dot(self.ai,self.wih)))
		self.ao = 1/(1+T.exp(-T.dot(self.ah,self.who)))

		# Create the loss function 
		sqloss = 0.5*((self.t-self.ao)**2).sum() 
		loss = sqloss + 0.5*self.lam*((self.wih.ravel()**2).sum()\
				+(self.who.ravel()**2).sum())

		# Run the algorithm until convergence
	


	def test(self) :
		pass
	
	def update(self) : 
		pass

	def backprop(self) : 
		pass

	def getweights(self) : 
		pass



if __name__ == '__main__' : 
	
	# Create a neural network
	nn = NeuralNetwork(2,2,1)

	# Create the XOR dataset
	x = list(product([0,1],[0,1]))
	t = map(lambda(a,b) : (a^b),x)	
	t = [[y] for y in t]

	# Train the neural network
	nn.train(x,t)


