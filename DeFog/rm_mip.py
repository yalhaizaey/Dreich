from __future__ import print_function
import time
from ortools.linear_solver import pywraplp

def main():
  solver = pywraplp.Solver('SolveAssignmentProblem',
                           pywraplp.Solver.CBC_MIXED_INTEGER_PROGRAMMING)

  start = time.time()
  cost = [
         [50, 50, 50, 30, 30, 30, 10, 10, 10, 50, 30, 10],    #pi2
         [40, 40, 40, 25, 25, 25, 9, 9, 9, 40, 25, 9],        #pi3B
         [35, 35, 35, 22, 22, 22, 8, 8, 8, 35, 22, 8],        #pi3B+
         [10, 10, 11, 15,15,15, 7, 7, 7, 10, 15, 7],          #pi4
         ]

  task_sizes = [10, 7, 3, 12, 15, 4, 11, 5, 10, 15, 13, 7]

  # Maximum total of task sizes for any worker
  total_size_max = 100
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

  print('Minimum cost = ', solver.Objective().Value())
  print()
  for i in range(num_workers):
    for j in range(num_tasks):
      if x[i, j].solution_value() > 0:
        print('Worker', i,' assigned to task', j, '  Cost = ', cost[i][j])
  print()
  end = time.time()
  print("Time = ", round(end - start, 4), "seconds")
if __name__ == '__main__':
  main()
