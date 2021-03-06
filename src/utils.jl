##
# NSGA-II in Julia
# Guilherme N. Ramos (gnramos@unb.br)
# Gustavo Fernandes de Almeida (gsutavo@outlook.com)
# Helper/utilitary functions.
##

"""
Computes the ranks and define fronts for individuals in the population
"""
function fast_non_dominated_sort(population::Array{Individual})

  fronts::Array{Front} = []
  currentFront::Array{Individual} = []
  nextFront::Array{Individual} = []

  for p in population
    p.S = []
    p.n = 0

    for q in population
      if p != q

        if dominates(p,q)
          p.S = push!(p.S, q)
        end

        if dominates(q,p)
          p.n = p.n + 1
        end

      end
     end

    if p.n == 0
      p.rank = 1
      currentFront = push!(currentFront, p)
    end
  end

    fronts = push!(fronts, Front(currentFront))
    i = 1 # Initialize front counter

    while !isempty(fronts[i].individuals)
      nextFront = []
      for x in fronts[i].individuals
        for y in x.S
          y.n = y.n - 1
          if y.n == 0
            y.rank = i+1
            nextFront = push!(nextFront,y)
          end
        end
      end
        i = i + 1
        fronts = push!(fronts, Front(nextFront))
        #fronts[i] = Q
    end

    return fronts
end

"""
Defines the crownding distance of a front's individuals
"""
function crowding_distance_assigned(front::Array{Individual})

  frontLen = length(front)

  for x in front                 # Set every crowding distance to zero
    x.crowdingDistance = 0
  end

  n_objectives = length(front[1].fenotype)
  for i in 1:n_objectives
    sort!(front, lt = (x,y)-> x.fenotype[i] < y.fenotype[i], rev = true)

    front[1].crowdingDistance = front[end].crowdingDistance = Inf32
    maximumValue    = front[1].fenotype[i]
    minimumValue    = front[end].fenotype[i]

    for y in 2:(frontLen - 1)
        greaterNeighbor = front[y-1].fenotype[i]
        lowerNeighbor   = front[y+1].fenotype[i]
        front[y].crowdingDistance = front[y].crowdingDistance + (( greaterNeighbor - lowerNeighbor)/( maximumValue - minimumValue))

    end
   end
#println("----------------------------------------------------------------------")
return
end

"""
Indicates if there should be a crossover.
"""
function should_crossover()
  return CROSSOVER_PROBABILITY <= rand()
end


"""
Indicates if there should be a mutation.
"""
function should_mutate()
  return MUTATION_PROBABILITY <= rand()
end


"""
Returns a random Individual from the given array.
"""
function random(population::Array{Individual})
  index = rand(1:length(population))
  return population[index]
end

"""
Randomly selects n Individuals from the given array (with repetition).
"""
function random(n::Int, population::Array{Individual})
  selected::Array{Individual} = []

  for i in 1:n
	push!(selected, random(population))
  end

  return selected
end


##          ##
# Tournament #
##          ##

"""
Tests if x and y are identical.
"""
function isequal(x::Individual, y::Individual)
  return x.genotype == y.genotype
end


"""
Returns the winner of a tournament between x and y.
"""
function winner(x::Individual, y::Individual)
  # Does x dominates y?
  if (dominates(x,y))
    return x
  end
  # Does y dominates x?
  if (dominates(y,x))
    return y
  end
  # No solution is definitely better
  return random([x, y])
end


"""
Returns the winner of a binary tournament.
"""
function binary_tournament(contenders::Array{Individual})
  x, y = contenders[1], contenders[2]
  return isequal(x, y) ? random([x, y]) : winner(x, y)
end


"""
Tests if x dominates y.
In our scenario both fenotypes must be minimized
Example:
[2, 1] < [1,1]
[1, 2] < [1,1]
[1, 2] = [2,1] -> No answer is any better
"""
function dominates(x::Individual, y::Individual)

  return x.fenotype[1] < y.fenotype[1] &&   # Lower is better - MIN
         x.fenotype[2] < y.fenotype[2] &&   # Lower is better - MIN
         x.fenotype[3] > y.fenotype[3] &&   # Higher is better - MAX
         x.fenotype[4] < y.fenotype[4] &&   # Lower is better  - MAX ( fenotype[4] is negative)
         x.fenotype[5] < y.fenotype[5]      # Lower is better - MIN

end


"""
Doubles the size of the population.
"""
function expand_population(population::Array{Individual})
  num_steps = length(population)/2

  for i = 1:num_steps
    first_parent  = binary_tournament(random(2, population))
    second_parent = binary_tournament(random(2, population))

    # Clone
    children = [Individual(parent.genotype) for parent in [first_parent, second_parent]]

    # Crossover
    if should_crossover()
      crossover(children[1], children[2])
      #crossover(children)
    end

    # Mutation
    for child in children
      if should_mutate()
        singleBitMutation(child)
      end
    end

    append!(population, children)
  end
end
