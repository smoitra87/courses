""" A program to calculate 3 sum """
import random

x = [-25,-10,-7,-3,2,4,8,10]
random.shuffle(x)


def calc_3sum(x) : 
	""" Function calcing 3 sum """
	x.sort()
	for i,a in enumerate(x) : 
		k = i+1
		l = len(x)-1
		while k < l :
			b = x[k]
			c = x[l]
			if(a+b+c==0) :
				return a,b,c
			elif a+b+c > 0 : 
				l = l-1
			else : 
				k = k+1
	return None

print calc_3sum(x) 

