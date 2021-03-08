from numpy.random import normal
from numpy import rint

def prMatrix(x):
    for row in x:
        for val in row:
            print(val,end=',')
        print()
    print()

# example array of task costs on different nodes
x = [
  [50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50],
  [40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40],
  [40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40],
  [10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10],
  ]

print('initial x:')
print('----------')
prMatrix(x)


####### @jsinger new perturbation code for cost matrix

# thresholds for changing costs
COEFFICIENT_OF_VARIATION=0  # c.o.v. = stdev / mean = sigma/mu
# try different values - between 0 and 1?

for i in range(len(x)):
    for j in range(len(x[i])):
        mu = x[i][j]
        sigma = COEFFICIENT_OF_VARIATION * mu
        updated_value = int(rint(normal(mu, sigma)))
        x[i][j] = max(0, updated_value)  # no negative costs!

##########

print('final x:')
print('----------')
prMatrix(x)
