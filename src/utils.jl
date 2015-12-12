##
# NSGA-II in Julia
#
# Guilherme N. Ramos (gnramos@unb.br)
#
# Helper/utilitary functions.
##


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
    x.np = 0
    x.Sp = []
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
        x.Sp = push!(x.Sp, y)
        y.np += 1
      end
    end
  end
end


"""
Updates each individual's rank according to its relative dominance.
"""
function update_rank(population::Array{Individual})
  lowestNp = population[1].np
  currentRank = 1

  for x in population
    if x.np == lowestNp
       x.rank = currentRank
    else
      currentRank += 1
      lowestNp = x.np
      x.rank = currentRank
    end
  end
end

"""
Defines the individual ranks in the population.
"""
function set_ranks(population::Array{Individual})
  compute_dominance(population)

  sort!(population, lt = (x,y)-> x.np < y.np) # Ordena a população com o valor de np ascendente

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
