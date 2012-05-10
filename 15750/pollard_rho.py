import sys
from fractions import gcd


def pseudo(x,N)  :
	""" Generates a pesudo random number"""
	return (x**2+1)%N

def pollard(N) :
	""" The pollard rho algorithm """
	left = 2
	right = 2
	d = 1
	while d == 1: 
		left = pseudo(left,N)
		right = pseudo(pseudo(right,N),N)
		d = gcd(abs(left-right),N)
	if d == N :
		print("Failure")
	else :
		print("non trivial factor is %d"%d)


if __name__ == '__main__' :
	N = sys.argv[1]
	try :
		N = int(N)
	except ValueError : 
		print """ $ python pollard_rho <composite-integer> """
	pollard(N)
