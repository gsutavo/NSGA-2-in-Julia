##
# December 12th, 2015
# NSGA-II in Julia
# Gustavo Fernandes de Almeida  (gsutavo@outlook.com)
# Guilherme N. Ramos            (gnramos@unb.br)
# NSGA-II
##

include("Individual.jl")
include("variation.jl")
include("initialization.jl")
include("display.jl")
include("utils.jl")


"""
Assingn some constants

Determina constantes
"""

geneSize = 25
pop_size = 20
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
  set_ranks(P)                  # Set ranks and n values
                                # Determina o valor dos np e ranks
  #printPopulation(P)

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
  printPopulation(P)

end
