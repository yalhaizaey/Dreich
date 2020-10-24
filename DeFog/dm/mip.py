# Retrun results for bash format
# No task sizes here or task requirnments. Which means every task has the same requirnments!
# Second Version: This Python code makes calculation based on the cost matrix itself. No task_sizes/requirnment here!
# Omit (task_sizes); calculation made based on cost matrix! Normal assingment problem without considereing task_requirnments!
# node capacities = number of tasks (how many tasks) each node can handle concurrently (e.g Pi can handle 20 tasks image processing)

# objective is to minimise the total cost!
# cost matrix shows that cost on node 0 incure high computations while on node 3 incure less computations

import random
import time
from ortools.linear_solver import pywraplp

def main():
    #-------------------------------------------
    #randomize code created by Jeremy;

    # example array of task costs on different nodes (30 tasks)
    x = [
      [50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50,50],
      [40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40],
      [40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40,40],
      [10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10],
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
    #begin Google-or Tool;
    # Data
    costs = x
    num_workers = len(costs)
    num_tasks = len(costs[0])

    # how many tasks each node can process concurrently! (e.g. Pi2 can handle up to 3 tasks; Pi3B up to 4;)
    # For example (if task is image processing; Pi2 can handle up to 3)
    node_cap = [3,5,7,15]

    # Solver
    # Create the mip solver with the SCIP backend.
    #solver = pywraplp.Solver.CreateSolver('MIP')

    solver = pywraplp.Solver('SolveAssignmentProblem',
                             pywraplp.Solver.CBC_MIXED_INTEGER_PROGRAMMING)

    start = time.time()
    edge_devices = ['192.168.1.224', '192.168.1.168', '192.168.1.182', '192.168.1.131']
    new_edge_devices = []
    e_devices='('

    # Variables
    # x[i, j] is an array of 0-1 variables, which will be 1
    # if worker i is assigned to task j.
    x = {}
    for i in range(num_workers):
        for j in range(num_tasks):
            x[i, j] = solver.IntVar(0, 1, '')

    # Constraints
    # Number of tasks assinged to each node less than the node capacitiy!
    for i in range(num_workers):
        solver.Add(solver.Sum([x[i, j] for j in range(num_tasks)]) <= node_cap[i])

    # Each task is assigned to exactly one worker.
    for j in range(num_tasks):
        solver.Add(solver.Sum([x[i, j] for i in range(num_workers)]) == 1)

    # Objective
    objective_terms = []
    for i in range(num_workers):
        for j in range(num_tasks):
            objective_terms.append(costs[i][j] * x[i, j])

    solver.Minimize(solver.Sum(objective_terms))

    # Solve
    status = solver.Solve()
    #print('Minimum cost = ', solver.Objective().Value())

    #print()
    final_Workers_IP=[0]*len(costs[1])
    #print()

    # Print solution.
    if status == pywraplp.Solver.OPTIMAL or status == pywraplp.Solver.FEASIBLE:
        #print('Total cost = ', solver.Objective().Value(), '\n')
        for i in range(num_workers):
            for j in range(num_tasks):
                # Test if x[i,j] is 1 (with tolerance for floating point arithmetic).
                if x[i, j].solution_value() > 0.5:
                    final_Workers_IP[j]='\''+edge_devices [i]+'\' '
                    e_devices+='\''+edge_devices [i]+'\' '
                    #print('Edge node %d assigned to task %d.  Cost = %d' % (i, j, costs[i][j]))
        #print()
        end = time.time()
        #print("Time = ", round(end - start, 4), "seconds")
        #print (new_edge_devices)
        e_devices = e_devices[:-1]
        e_devices+=')'
        finalIPsBashFormat='('
        for i in range(num_tasks):
            finalIPsBashFormat+=final_Workers_IP[i]
        finalIPsBashFormat= finalIPsBashFormat[:-1]
        finalIPsBashFormat+=')'
        #print ()
        print(finalIPsBashFormat)
if __name__ == '__main__':
    main()
