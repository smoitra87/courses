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

import numpy as np


if __name__ == '__main__':

    X = list(product([0, 1], [0, 1]))
    X = [[1]+list(t) for t in X]

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
        w.set_value(np.random.randn(3))
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
            if tries > 100:
                print("###### Not Converged ######")
                break

        print("Final weights are:")
        print(w.get_value())

        return w

    # or
    Y = map(lambda __a_b: (__a_b[1] or __a_b[2])*2-1, X)
    w = train_perceptron(X, Y)

    # and
    Y = map(lambda __a_b1: (__a_b1[1] and __a_b1[2])*2-1, X)
    w = train_perceptron(X, Y)

    # xor
    Y = map(lambda __a_b2: (__a_b2[1] ^ __a_b2[2])*2-1, X)
    w = train_perceptron(X, Y)

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
        w.set_value(np.random.randn(3))
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

    # or
    Y = map(lambda __a_b3: (__a_b3[1] or __a_b3[2])*2-1, X)
    w = train_lms(X, Y)

    # and
    Y = map(lambda __a_b4: (__a_b4[1] and __a_b4[2])*2-1, X)
    w = train_lms(X, Y)

    # xor
    Y = map(lambda __a_b5: (__a_b5[1] ^ __a_b5[2])*2-1, X)
    w = train_lms(X, Y)
