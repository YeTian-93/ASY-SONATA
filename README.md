# ASY-SONATA

This is the MATLAB code for simulating ASY-SONATA.  The simulation consists of three problems and includes comparison with state of arts that can be implemented in the partial asynchronous model [1] and over directed graphs.  We elaborate below some basic setups:

\textbf{asynchronous model:}
Agents   wakes up according to a random permutation.  An agent will send out information to all its out-neighbors immediately after it finishes its own local update.  Each packet has a random integer traveling time sampled uniformly at random from $[1, MaxTravelTime]$.
Suppose $T_{ij}^k$ is the traveling time of a packet sent from agent $j$ at virtual global iteration $k$ and the packet will not be available to $i$ until the virtual global iteration $k+T_{ij}^k.$  Every agent always uses the most recent information from its in-neighbors out of those available.  We set $MaxTravelTime = 60.$



Please check each folder for the


# Reference:
[1] Bertsekas, Dimitri P., and John N. Tsitsiklis. Parallel and distributed computation: numerical methods. Vol. 23. Englewood Cliffs, NJ: Prentice hall, 1989.
