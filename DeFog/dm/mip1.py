# For bash format. we have tasks sizes or task requirnments!
# First Version: This Python code has 3 data structures:
# cost matrix. values represents the cost of each task on each node. Randomized!
# task_sizes. different tasks have different requirnments (could be CPU or RAM but not sure). Randomized!
# node_capacities. here node capacities are the sum of (task_sizes) each node can handle.

from __future__ import print_function
import time
from ortools.linear_solver import pywraplp
import os
import random

def main():
  #-------------------------------------------
  #randomize code created by Jeremy;
  #import random;
  x = [
      [50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50],
      [40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40],
      [40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40],
      [10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10],
      ]


  # pseudo-random seed init
  # (for repeatability of random sequence)
  #random.seed(42)

  # thresholds for changing costs
  MIN_COST_MULTIPLIER=0.5
  MAX_COST_MULTIPLIER=2.0

  for i in range(len(x)):
        for j in range(len(x[i])):
            x[i][j] = random.randint(int(x[i][j]*MIN_COST_MULTIPLIER), int(x[i][j]*MAX_COST_MULTIPLIER))

  #-------------------------------------------
  # begin Google-or Tool;
  solver = pywraplp.Solver('SolveAssignmentProblem',
                           pywraplp.Solver.CBC_MIXED_INTEGER_PROGRAMMING)

  start = time.time()

  edge_devices = ['192.168.1.224', '192.168.1.168', '192.168.1.182', '192.168.1.131']

  new_edge_devices = []
  e_devices='('

  #cost matrix. Randomised!
  cost = x

  # Task sizes. Different tasks have differet requirnements. Randomised!
  task_sizes = [10, 7, 3, 12, 15, 4, 11, 5, 10, 15, 13, 7, 10, 7, 3, 12, 15, 4, 11, 5, 10, 15, 13, 7, 10, 7, 3, 12, 15, 4, 11, 5]
  #task_sizes = [10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10]
  #print (task_sizes)
  #print ()

  # Node_capacities. Sum of (task_sizes) each node can do. For example: Pi2 can only do total of 5; Pi3B cannt exceed 4.
  total_size_max = [40,60,70,150]
  #print ('Nodes capacities = ', total_size_max)

  num_workers = len(cost)
  num_tasks = len(cost[1])

  # Variables
  x = {}
  for i in range(num_workers):
    for j in range(num_tasks):
      x[i, j] = solver.IntVar(0, 1, 'x[%i,%i]' % (i, j))

  # Constraints
  # The total size of the tasks each worker takes on is at most total_size_max.
  for i in range(num_workers):
    solver.Add(solver.Sum([task_sizes[j] * x[i, j] for j in range(num_tasks)]) <= total_size_max[i])

  # Each task is assigned to at least one worker.
  for j in range(num_tasks):
    solver.Add(solver.Sum([x[i, j] for i in range(num_workers)]) == 1)

  solver.Minimize(solver.Sum([cost[i][j] * x[i,j] for i in range(num_workers)
                                                  for j in range(num_tasks)]))
  sol = solver.Solve()

  print('Minimum cost = ', solver.Objective().Value())
  #print()
  final_Workers_IP=[0]*len(cost[1])
  for i in range(num_workers):
    for j in range(num_tasks):
      if x[i, j].solution_value() > 0:
        #print (i)
        #assign workers to array based on the task they were assigned
        #final_Workers_IP[j]=edge_devices[i] +' task ',j
        final_Workers_IP[j]='\''+edge_devices [i]+'\' '

        #string
        e_devices+='\''+edge_devices [i]+'\' '
        #return (edge_devices [i])
        #print('Edge node', i,' assigned to task', j, '  Cost = ', cost[i][j])
        #print ('')
  #print()
  end = time.time()
  #print("Time = ", round(end - start, 4), "seconds")
  #print (new_edge_devices)
  e_devices = e_devices[:-1]
  e_devices+=')'
  #print(e_devices)
  finalIPsBashFormat='('
  for i in range(num_tasks):
      finalIPsBashFormat+=final_Workers_IP[i]
  finalIPsBashFormat= finalIPsBashFormat[:-1]
  finalIPsBashFormat+=')'
  #print ()
  print(finalIPsBashFormat)

if __name__ == '__main__':
  main()
