from __future__ import print_function
from ortools.sat.python import cp_model
import time
import numpy as np

def main():
  model = cp_model.CpModel()

  start = time.time()
  cost = [
         [50, 50, 50, 30, 30, 30, 10, 10, 10, 50, 30, 10],    #pi2
         [40, 40, 40, 25, 25, 25, 9, 9, 9, 40, 25, 9],        #pi3B
         [35, 35, 35, 22, 22, 22, 8, 8, 8, 35, 22, 8],        #pi3B+
         [10, 10, 11, 15,15,15, 7, 7, 7, 10, 15, 7],          #pi4
         ]

  sizes = [10, 7, 3, 12, 15, 4, 11, 5, 10, 15, 13, 7]
  total_size_max = 100
  num_workers = len(cost)
  num_tasks = len(cost[1])
  # Variables
  x = []
  for i in range(num_workers):
    t = []
    for j in range(num_tasks):
      t.append(model.NewIntVar(0, 1, "x[%i,%i]" % (i, j)))
    x.append(t)
  x_array = [x[i][j] for i in range(num_workers) for j in range(num_tasks)]

  # Constraints

  # Each task is assigned to at least one worker.
  [model.Add(sum(x[i][j] for i in range(num_workers)) >= 1)
  for j in range(num_tasks)]

  # Total size of tasks for each worker is at most total_size_max.

  [model.Add(sum(sizes[j] * x[i][j] for j in range(num_tasks)) <= total_size_max)
  for i in range(num_workers)]
  model.Minimize(sum([np.dot(x_row, cost_row) for (x_row, cost_row) in zip(x, cost)]))
  solver = cp_model.CpSolver()
  status = solver.Solve(model)

  if status == cp_model.OPTIMAL:
    print('Minimum cost = %i' % solver.ObjectiveValue())
    print()

    for i in range(num_workers):

      for j in range(num_tasks):

        if solver.Value(x[i][j]) == 1:
          print('Worker ', i, ' assigned to task ', j, '  Cost = ', cost[i][j])
    print()
    end = time.time()
    print("Time = ", round(end - start, 4), "seconds")


if __name__ == '__main__':
  main()
