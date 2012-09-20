import sys
from fractions import gcd


"""
Example

$ python pollard_rho.py 18446744073709551617 2
"""

PRINT_TRACE = False

def pseudo(x,N)  :
	""" Generates a pesudo random number"""
	return (x**2+1)%N

def pollard(N) :
	""" The pollard rho algorithm """
	left = right = seed
	d = 1
	while d == 1: 
		left = pseudo(left,N)
		right = pseudo(pseudo(right,N),N)
		d = gcd(abs(left-right),N)
		if PRINT_TRACE : 
			print(left,right,d)
	if d == N : 
		print("Failure")
	else :
		print("non trivial factor is %d"%d)


if __name__ == '__main__' :
	N,seed = sys.argv[1:]
	try :
		N,seed = int(N),int(seed)
	except ValueError : 
		print """ $ python pollard_rho <composite-integer> <seed>"""
	pollard(N)
