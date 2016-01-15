##
# December 12th, 2015
# NSGA-II in Julia
# Gustavo Fernandes de Almeida  (gsutavo@outlook.com)
# Guilherme N. Ramos            (gnramos@unb.br)
# NSGA-II
##

include("Individual.jl")
include("Front.jl")
include("variation.jl")
include("initialization.jl")
include("display.jl")
include("utils.jl")


"""
Assingn some constants

Determina constantes
"""

geneSize = 3
pop_size = 2
CROSSOVER_PROBABILITY = 0.5
MUTATION_PROBABILITY = 0.05
generationNumber = 10

"""
Runs NSGA-II
"""

function nsga2()
  #Tests / Testes
  P = initPopulation(pop_size)  # Population of size pop_size ie created
                                # População de tamanho pop_size é criada
  expand_population(P)          # Initial populations expands to twice its initial size
                                # População inicial é expandida tamanho 2*pop_size, população pai + população filha
  println("-----------------------------------")
  println("Initial Population")
  #printPopulation(P)
  println("-----------------------------------")
  F = fast_non_dominated_sort(P)  # Set ranks and fronts
                                  # Determina ranks e fronts
  println("After fast_non_dominated sort")
  printPopulation(P)
  println("-----------------------------------")
  println("Crowding distance")
  crowding_distance_assigned(P) # Set the crowding distance of a front's individuals
                                # Determina a crowding distance dos indivíduos de um front
  for i = 1:generationNumber
       newP = P[1:pop_size]     # Get the pop_size bests (no crowding distance calculations yet)
                                # Seleciona os pop_size melhores, calculo da crowding distance ainda não implementado
       reset(newP)
       expand_population(newP)
       set_ranks(newP)
       P = newP
  end

  println("-----------------------------------")
  println("Final Population")
  #printPopulation(P)

end
