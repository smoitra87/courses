#! /usr/bin/env python

#
# Deep Learning Lab 1  : Perceptron Learning Rule
# Author : Subhodeep Moitra(smoitra@cs.cmu.edu)
#


import os
import sys
from theano import tensor as T
from theano import function, shared
from itertools import product
from operator import xor

import matplotlib.pyplot as plt


import numpy as np

maxTries = 500;

if __name__ == '__main__':

    from argparse import ArgumentParser
    parser = ArgumentParser(description='Which Experiment to run')
    parser.add_argument('--logic',action='store_true',default=False,
                        help='Run Perceptron with logic gates')
    parser.add_argument('--dataperc',action='store_true',default=False,
                        help='Run Perceptron with Data provided')
    parser.add_argument('--plot',action='store_true',default=False,
                        help='Make Plots of the data')
    parser.add_argument('--datalms',action='store_true',default=False,
                        help='Run LMS with Data provided')
    args = parser.parse_args()

    # Create Logic data
    if args.logic:
        X = list(product([0, 1], [0, 1]))
        X = [[1]+list(t) for t in X]

    # Load data files
    if args.datalms or args.dataperc:
        def shrink_decorator(fn):
            def shrink_wrapper(fin):
                shrinker = lambda l: l if len(l) > 1 else l[0]
                array = fn(fin)
                return map(shrinker,array)
            return shrink_wrapper

        @shrink_decorator
        def csvreader(fin):
            return [map(float,line.strip().split(',')) for line in fin]

        Xtrain = [] ; ytrain = []
        Xtest = [] ; ytest = []
        for i in range(1,4+1):
            for l,s in zip([Xtrain,Xtest,ytrain,ytest],
                           ['X%d_train.csv','X%d_test.csv',
                            'y%d_train.csv','y%d_test.csv']):
                f = os.path.join('data',s%(i))
                with open(f) as fin:
                    l.append(csvreader(fin))

    x, y = T.vector('x'), T.scalar('y')
    w = shared(np.random.randn(3), name='w')

    # Contruct the theano expression graph
    o = (T.dot(x, w) > 0)*2-1
    e = y-o
    eta = 0.1

    learn = function(
        inputs=[x, y],
        outputs=[o, e],
        updates=[(w, w+eta*e*x)]	)

    predict = function(inputs=[x], outputs=o)

    def train_perceptron(X, Y):
        print('-'*20+'Training Perceptron'+'-'*20)
        global w
        converged = False
        nInputs = len(X[0])
        w.set_value(np.random.randn(nInputs))
        tries = 0
        while not converged:
            errorCount = 0
            for x_, y_ in zip(X, Y):
                o, e = learn(x_, y_)
                if e != 0:
                    errorCount += 1
            if errorCount == 0:
                converged = True
            tries += 1
            if tries > maxTries:
                print("###### Not Converged ######")
                break

        print("Final weights are:")
        print(w.get_value())

        return w

    if args.logic:

        # or
        Y = map(lambda __a_b: (__a_b[1] or __a_b[2])*2-1, X)
        w = train_perceptron(X, Y)

        # and
        Y = map(lambda __a_b1: (__a_b1[1] and __a_b1[2])*2-1, X)
        w = train_perceptron(X, Y)

        # xor
        Y = map(lambda __a_b2: (__a_b2[1] ^ __a_b2[2])*2-1, X)
        w = train_perceptron(X, Y)

    if args.dataperc:
        for i in range(4) :
            print
            print("Running perceptron for Dataset %d"%i)

            # Train only on train data
            X,Y = Xtrain[i],ytrain[i]
            # Zero mean center the data
            X = np.asarray(X); Y = np.asarray(Y)
            mean = X.mean(axis=0)
            X = X -mean
            maxVals = np.max(np.abs(X),axis=0)
            X = X/maxVals
            X = np.hstack((np.ones((X.shape[0],1)),X))
            w = train_perceptron(X,Y)

            # predict on test data
            testX,testY = Xtest[i],ytest[i]
            testX = (testX-mean)/maxVals
            predY = [predict(x) for x in np.hstack((np.ones((testX.shape[0],1)),testX))]
            predY = np.asarray(predY,int)

            X,Y = np.asarray(Xtest[i]),np.asarray(ytest[i])
            X = (X-mean)/maxVals


            if args.plot:
                fig,ax = plt.subplots()
                ax.plot(X[Y==-1,0],X[Y==-1,1],'ro')
                ax.plot(X[Y==1,0],X[Y==1,1],'bo')
                xboundary =  np.linspace(-1,1,20)
                w_train = w.get_value()
                yboundary = [-w_train[1]*x/w_train[2] for x in xboundary]
                ax.plot(xboundary,yboundary,ls='--',lw=2,color='green')
                ax.set_title('Decision Boundary for Dataset %d'%(i+1))
                plt.savefig('percepDataset%d.png'%(i+1))
                plt.close()




    #-----------------------------------------------------
    # Now for LMS

    x, y = T.matrix('x'), T.vector('y')

    o = T.dot(x, w)
    eta = 0.01
    pred = (o > 0)*2-1
    err = 0.5*((y-o)**2).sum()
    gw = T.grad(err, w)

    learn_lms = function(
        inputs=[x, y],
        outputs=[pred, err],
        updates=[(w, w - eta*gw)]
        )

    predict_lms = function([x], pred)

    def train_lms(X, Y):
        print('-'*20+'Training LMS'+'-'*20)
        err_thresh, MaxTries, converged = 0.01, 1000, False
        global w
        nInputs = len(X[0])
        w.set_value(np.random.randn(nInputs))
        tries = 0

        # Run gradient descent
        while not converged and tries < MaxTries:
            pred, err = learn_lms(X, Y)
            if err < err_thresh:
                converged = True
            tries += 1

        if converged:
            print("LMS converged")
        elif tries >= MaxTries:
            print("Maximum attemps exceeded")

        print("Final Loss is ", err)
        print("Final Prediction is ", predict_lms(X))
        print("Final weights are:")
        print(w.get_value())

        return w

    if args.logic:
        # or
        Y = map(lambda __a_b3: (__a_b3[1] or __a_b3[2])*2-1, X)
        w = train_lms(X, Y)

        # and
        Y = map(lambda __a_b4: (__a_b4[1] and __a_b4[2])*2-1, X)
        w = train_lms(X, Y)

        # xor
        Y = map(lambda __a_b5: (__a_b5[1] ^ __a_b5[2])*2-1, X)
        w = train_lms(X, Y)

    if args.datalms:
        for i in range(4) :
            print
            print("Running perceptron for Dataset %d"%i)
            for X,Y in zip((Xtrain[i],Xtest[i]),(ytrain[i],ytest[i])):
                # Zero mean center the data
                X = np.asarray(X)
                mean,std = X.mean(axis=0),X.std(axis=0)
                X = (X -mean)/std
                X = np.hstack((np.ones((X.shape[0],1)),X))
                w = train_lms(X,Y)

