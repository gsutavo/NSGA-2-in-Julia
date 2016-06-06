##
# March 22th, 2016
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
data_matrixA = readcsv("../data/matrizA.csv")
data_matrixB = readcsv("../data/matrizB_normal.csv")
data_matrixC = readcsv("../data/matrizC_25by9.csv")
data_matrixD = readcsv("../data/matrizD.csv")

geneSize = 25
pop_size = 500
CROSSOVER_PROBABILITY = 0.9
MUTATION_PROBABILITY = 0.05
generationNumber = 10000
DEBUG_FLAG = false

"""
Runs NSGA-II
"""

function nsga2()
     newP::Array{Individual} = []
     #Tests / Testes
     P = initPopulation(pop_size)  # Population of size pop_size ie created
                                   # População de tamanho pop_size é criada
      #println("-----------------------------------")
      #println("Initial Population")
      #printPopulation(P)

      for k = 1:generationNumber

        if k == 1 || k == 2500 || k ==5000 || k==7500
          println("Generation ", k)
        end
#     printPopulation(P)
      expand_population(P)        # Initial populations expands to twice its initial size
                                  # População inicial é expandida tamanho 2*pop_size, população pai + população filha


       newP = []
       F = fast_non_dominated_sort(P)  # Set ranks and fronts
                                       # Determina ranks e fronts
       i = 1

      while length(newP) + length(F[i].individuals) <= pop_size
        append!(newP, F[i].individuals)
        i = i + 1
      end

################################################################################
      if(DEBUG_FLAG)
        println("==================================================================")
        println("Tamanho do newP:",length(newP))
        println("Número de fronts:", length(F))
        for w in 1:length(F)
          print("Front[", w)
          print("]: ",length(F[w].individuals))
          println(" indivíduos.")
        end

        teste = 0
        for g in 1:length(F[1].individuals)
          if F[1].individuals[g].fenotype[1] == 0
            teste = teste +1
          end
        end
        println("Número de [0,55] no 1ºfront:",  teste)
        println("==================================================================")
      end
################################################################################

      if length(newP) < pop_size
          crowding_distance_assigned(F[i].individuals) # Set the crowding distance of a front's individuals
                                                       # Determina a crowding distance dos indivíduos de um front

          # Sort the front based on crownding distance
          # Ordena o front com o valor de crowding distance decrescente
          sort!(F[i].individuals, lt = (x,y)-> x.crowdingDistance < y.crowdingDistance, rev = true)

################################################################################
        if(DEBUG_FLAG)
          for c in 1: length(F[i].individuals)
          println(c, ":",F[i].individuals[c].genotype," - ", F[i].individuals[c].crowdingDistance)
        end
      end
       #printPopulation(P)
################################################################################

        individualsNeeded = pop_size - length(newP)

        for j in 1:individualsNeeded
          if F[i].individuals[j].crowdingDistance > 0
            newP = push!(newP, F[i].individuals[j])
          else
            append!(newP,random( individualsNeeded - j,F[i].individuals[j:end]))
            break
          end
        end
      end

################################################################################
      if(DEBUG_FLAG)
          teste = 0
          for g in 1:length(newP)
            if newP[g].fenotype[1] == 0 && newP[g].fenotype[2] == 55
              teste = teste +1
            end
          end
          println("Número de [0,55] na nova população:",teste)
        end
################################################################################

      P = copy(newP)


  end

  println("-----------------------------------")
  println("Results of interest:")
  println("-----------------------------------")

  sort!(P, lt = (x,y)-> x.crowdingDistance < y.crowdingDistance, rev = true)
  #sort!(P, lt = (x,y)-> x.fenotype[1] < y.fenotype[1])
  #printPopulation(P)
  debug_printFile(P)
  createInterFile(P)

end
