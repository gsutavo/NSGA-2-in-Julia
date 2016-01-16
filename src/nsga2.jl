##
# January 15th, 2016
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

geneSize = 10
pop_size = 5
CROSSOVER_PROBABILITY = 0.5
MUTATION_PROBABILITY = 0.05
generationNumber = 100

"""
Runs NSGA-II
"""

function nsga2()
     newP::Array{Individual} = []
     #Tests / Testes
     P = initPopulation(pop_size)  # Population of size pop_size ie created
                                   # População de tamanho pop_size é criada
    for k = 1:generationNumber
      expand_population(P)          # Initial populations expands to twice its initial size
                                    # População inicial é expandida tamanho 2*pop_size, população pai + população filha
       newP = []
       F = fast_non_dominated_sort(P)  # Set ranks and fronts
                                       # Determina ranks e fronts
       i = 1

      while length(newP) + length(F[i].individuals) <= pop_size
        newP = includeFront(newP, F[i].individuals)
        i = i + 1
      end

      if length(newP) < pop_size
          crowding_distance_assigned(F[i].individuals) # Set the crowding distance of a front's individuals
                                                       # Determina a crowding distance dos indivíduos de um front

          sort!(F[i].individuals, lt = (x,y)-> x.crowdingDistance < y.crowdingDistance, rev = true) # Ordena o front com o valor de crowding distance decrescente

        for j in 1:pop_size - length(newP)
          newP = push!(newP, F[i].individuals[j])
        end
      end

      P = newP
  end

  println("-----------------------------------")
  println("Final Population")
  printPopulation(P)

end
