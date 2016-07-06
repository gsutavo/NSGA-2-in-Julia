##
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
Assign some constants
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

"""
Runs NSGA-II
"""

function nsga2()
     newP::Array{Individual} = []
     P = initPopulation(pop_size)  # Population of size pop_size is created

      for k = 1:generationNumber

        if k == 1 || k == 2500 || k ==5000 || k==7500
          println("Generation ", k)
        end
      expand_population(P)        # Initial populations expands to double its initial size

       newP = []
       F = fast_non_dominated_sort(P)  # Set ranks and fronts
       i = 1

      while length(newP) + length(F[i].individuals) <= pop_size
        append!(newP, F[i].individuals)
        i = i + 1
      end

      if length(newP) < pop_size
          crowding_distance_assigned(F[i].individuals) # Set the crowding distance of a front's individuals
          # Sort the front based on crownding distance
          sort!(F[i].individuals, lt = (x,y)-> x.crowdingDistance < y.crowdingDistance, rev = true)
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
      P = copy(newP)
  end

  println("-----------------------------------")
  println("Results of interest:")
  println("-----------------------------------")

  sort!(P, lt = (x,y)-> x.crowdingDistance < y.crowdingDistance, rev = true)
  debug_printFile(P) # Print file with individuals that attend some predefined parameters
  createInterFile(P) # Create a intermediate file to plot graphs

end
