##
# NSGA-II in Julia
#
# Guilherme N. Ramos (gnramos@unb.br)
# Gustavo Fernandes de Almeida (gsutavo@outlook.com)
#
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
  frontLen = 0
  for x in front
    x.crowdingDistance = 0
    frontLen = frontLen + 1
  end

  n_objectives = length(front[1].fenotype)

  for i in n_objectives
    sort!(front, lt = (x,y)-> x.fenotype[i] < y.fenotype[i], rev = true)
    front[1].crowdingDistance = front[end].crowdingDistance = Inf32

    for y in 2:( frontLen - 1)
      front[y].crowdingDistance = front[y].crowdingDistance + (front[y-1].fenotype[i] - front[y+1].fenotype[i])/(front[1].fenotype[i] - front[end].fenotype[i])

      if isnan(front[y].crowdingDistance)
        front[y].crowdingDistance = 0
      end
     # println("Crowding Distance =", front[y].crowdingDistance, " + (", front[y-1].fenotype[i]," - ", front[y+1].fenotype[i],")/(",front[1].fenotype[i], "-", front[end].fenotype[i],")")
    end
  end

  return
end

"""
Include a front into a population
"""
function includeFront(P::Array{Individual}, front::Array{Individual})

  for x in front
    P = push!(P,x)
  end

  return P
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
  # Seria bom uma especialização de rand
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
  return x.fenotype[1] == y.fenotype[1]
end


"""
Returns the winner of a tournament between x and y.
"""
function winner(x::Individual, y::Individual)
  # Próximas versões terão mais parâmetros de comparação
  # Nessa quem tiver o menor número de valor de fenotype ganha
  return x.fenotype[1] < y.fenotype[1] ? x : y
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
"""
function dominates(x::Individual, y::Individual)
  return x.fenotype[1] < y.fenotype[1]
end


"""
Resets the population's characteristics.
"""
function reset(population::Array{Individual})
  for x in population
    x.n = 0
    x.S = []
    x.rank = 0
  end
end



"""
Computes the dominance between individuals in the population.
"""
function compute_dominance(population::Array{Individual})
  for x in population
    for y in population
      if x != y && dominates(x, y)
        x.S = push!(x.S, y)
        y.n += 1
      end
    end
  end
end


"""
Updates each individual's rank according to its relative dominance.
"""
function update_rank(population::Array{Individual})
  lowestN = population[1].n
  currentRank = 1

  for x in population
    if x.n == lowestN
       x.rank = currentRank
    else
      currentRank += 1
      lowestN = x.n
      x.rank = currentRank
    end
  end
end

"""
Defines the individual ranks in the population.
"""
function set_ranks(population::Array{Individual})
  compute_dominance(population)

  sort!(population, lt = (x,y)-> x.n < y.n) # Ordena a população com o valor de n ascendente

  update_rank(population)
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
