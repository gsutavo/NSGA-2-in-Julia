##
# 4 de dezembro de 2015
# NSGA-II in Julia
# Gustavo Fernandes de Almeida 10/0012183
#
##

module Nsga2

# Constants
GENE_SIZE             = 20
POPULATION_SIZE       = 20    # even number
CROSSOVER_PROBABILITY = 0.5
MUTATION_PROBABILITY  = 1/POPULATION_SIZE
GENERATIONS           = 100

include("Individual.jl")
include("initialization.jl")
include("variation.jl")
include("display.jl")
include("utils.jl")

function nsga2()
  #Testes
  population = initialize_population(POPULATION_SIZE)
  expand_population(population)
  set_ranks(population)
  print_population(population)

  for i = 1:GENERATIONS
    nextPopulation = population[1:POPULATION_SIZE]
    reset(nextPopulation)
    expand_population(nextPopulation)
    set_ranks(nextPopulation)
    P = nextPopulation
  end

  println("-----------------------------------")
  println("População final")
  println("-----------------------------------")
  print_population(population)

end


end # module