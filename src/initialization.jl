##
# NSGA-II in Julia
# Gustavo Fernandes de Almeida  (gsutavo@outlook.com)
# Initialization functions
##

"""
Initializes a gene, receives the gene size (size) and returns an array with
random values 0 or 1
"""
function initGene(size::Int)
    array::Array{Int8,1} = []
   array = rand(0:1,size)
   return array
end

"""
Initializes the fenotype. receives an array of integers (should be the genotype)
and calculates the features based on the array received
Returns an array of features

"""

function initFenotype(entry::Array)
  objetiveValue = 0
  sizeAlelleArray = size(data_matrixA)[2] # Defines how many different alelles are expected
  exit::Array{Float32} = []
  auxArray::Array{Int32} = fill(0,sizeAlelleArray)


"""
First objetive: number of 1's in genotype
"""
  objetiveValue = sum(entry)
  exit = push!(exit, objetiveValue)

"""
Second objetive: minimize missing alleles
"""

  for i = 1:length(entry)
    if entry[i] == 1
      for j = 1:sizeAlelleArray
        if data_matrixA[i,j] > 0
          auxArray[j] = 1
        end
      end
    end
  end

  objetiveValue = 0
  x = sum(auxArray)
  objetiveValue = sizeAlelleArray - x # Instead present alleles, this shows missing ones
  exit = push!(exit, objetiveValue)

"""
Third objetive: maximize allele frequency - sum of matrix B values
"""
y = 0.0

for i in 1:length(entry)
  if entry[i] == 1
    y = y + sum(data_matrixB[i,1:end])
  end
end

 exit = push!(exit,y)

"""
Fourth objetive: maximize heterozygozity - matrix C values
Note: heterozygozity is a negative value - greater heterozygozity is the lower
"""

objetiveValue = 0

for i in 1:length(entry)
  if entry[i] == 1
    objetiveValue = objetiveValue + sum(data_matrixC[i, 1:end])
 end
 end

 exit = push!(exit,objetiveValue)

"""
Fifth objetive: minimize HWE - matrix D values

"""
objetiveValue = 0

objetiveValue = abs(sum(data_matrixD.*entry))
exit = push!(exit,objetiveValue)

  return exit
end

"""
Initializes a population, receives the population size and returns an array of randomly created Individuals
"""
function initPopulation(pop_size::Int)
    population::Array{Individual} =[]
  for i = 1:pop_size
    population = push!(population, Individual(geneSize))
  end
 return population
end
