from __future__ import print_function
import time
from ortools.linear_solver import pywraplp
import os

def main():
  solver = pywraplp.Solver('SolveAssignmentProblem',
                           pywraplp.Solver.CBC_MIXED_INTEGER_PROGRAMMING)

  start = time.time()

  edge_devices = ['192.168.1.224', '192.168.1.168', '192.168.1.182', '192.168.1.131',
  '192.168.1.222', '192.168.1.229', '192.168.1.148', '192.168.1.230']

  new_edge_devices = []
  e_devices='('

#?? how to populate the cost matrix correctly based ?
# procssing speed of each device
# e.g Pi 4 processing speed = 0.00001s per pixel, task size = hd image 1280*720=921600pixels
# estimating time = 921600 * 0.00001s= 9.216 seconds
# cost matrix for image-detection benchmark
  cost = [
         [50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50],    #pi2
         [40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40],    #pi3B
         [35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35, 35],    #pi3B+
         [10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10],    #pi4

         [50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50, 50],    #pi2
         [40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40],    #pi3B
         [40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40],    #pi3B+
         [40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40, 40],
         ]

  # task_sizes = [10, 7, 3, 12]

  #?? how to define/calculate the cost of the task_sizes???
  #??  task_sizes = CPU or Mem?  maximum for each cpu to give results in resonable time?
  task_sizes = [10, 7, 3, 12, 15, 4, 11, 5, 10, 15, 13, 7, 10, 7, 3, 12, 15, 4, 11, 5, 10, 15, 13, 7, 10, 7, 3, 12, 15, 4, 11, 5]
  #task_sizes = [10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10]


  # Maximum total of task sizes for any worker
  # the maximum task size each worker can do
  # e.g total_size_max=20...worker 1=10+9=19<20 can do both tasks
  # if tasks size total > 20 can't do both tasks

  total_size_max = 80          # increase/decrease the value of this variable! #threshold
  #total_size_max = 135          # increase/decrease the value of this variable! #threshold for Pocket app
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
    solver.Add(solver.Sum([task_sizes[j] * x[i, j] for j in range(num_tasks)]) <= total_size_max)

  # Each task is assigned to at least one worker.

  for j in range(num_tasks):
    solver.Add(solver.Sum([x[i, j] for i in range(num_workers)]) >= 1)

  solver.Minimize(solver.Sum([cost[i][j] * x[i,j] for i in range(num_workers)
                                                  for j in range(num_tasks)]))
  sol = solver.Solve()

  #print('Minimum cost = ', solver.Objective().Value())
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

  print(finalIPsBashFormat)

if __name__ == '__main__':
  main()
