# Makes simulation runs using Glasso
#
#


library('glasso')
library('huge')


# Define some constants
expid=1

# Generate some graphs using the huge package

# 50 dimensions
L1 = huge.generator(d=50,prob=0.3)
L2 = huge.generator(d=50,prob=0.8)
L3 = huge.generator(d=50,graph='hub')
L4= huge.generator(d=50,graph='cluster')
L5 = huge.generator(n=20,d=50,prob=0.3)
L6 = huge.generator(n=500,d=50,prob=0.8)

# 200 dimensions
G1 = huge.generator(d=200,prob=0.3)
G2 = huge.generator(d=200,prob=0.8)
G3 = huge.generator(d=200,graph='hub')
G4= huge.generator(d=200,graph='cluster')
G5 = huge.generator(n=20,d=200,prob=0.3)
G6 = huge.generator(n=500,d=200,prob=0.8)

#----------------------------------------------------
# Examine dependence on p


#---------------------------------------------------
# Examine dependence on d


#---------------------------------------------------
# Examine dependency on density



#---------------------------------------------------
# Examine dependence on shape


#--------------------------------------------------
# Examine dependendence on normality




