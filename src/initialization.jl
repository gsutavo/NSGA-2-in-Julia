##
# March 22th, 2016
# NSGA-II in Julia
# Gustavo Fernandes de Almeida  (gsutavo@outlook.com)
# Initialization functions
# Funções de inicialização
##


sizeAlelleArray = 55 # Defines who many different alelles are expected


"""
Initializes a gene, receives the gene size (size) and returns an array with random values 0 or 1

Função initGene recebe o valor de tamanho do gene (size) e cria um array desse tamanho com valores aleatórios 0 ou 1
retorna vetor completo
"""
function initGene(size::Int)
    array::Array{Int8,1} = []
  for i = 1:size
    array = push!(array,rand(0:1))
  end
   return array
end

"""
Initializes the fenotype. receives an array of integers (should be the genotype) and calculates the features based on the array received
Returns an array of features
Note: for now counts just the number of ones present and calculates how many are missing

Função initFenotype recebe o genótipo e calcula o fenótipo relativo
Nesse caso, conta o número de 1's presentes e calula os faltantes
"""

function initFenotype(entry::Array)
  x = 0
  exit::Array{Float32} = []
  auxArray::Array{Int32} = fill(0,sizeAlelleArray)


"""
First objetive: number of 1's in genotype
"""

  for i = 1:length(entry)
    if entry[i] > 0
      x = x + 1
    end
  end

  exit = push!(exit, x)

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

  x = 0

  for i = 1:length(auxArray)
    if auxArray[i] > 0
      x = x + 1
    end
  end

  x = sizeAlelleArray - x # Instead present alleles, this shows missing ones
  exit = push!(exit, x)

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

x = 0

for i in 1:length(entry)
  if entry[i] == 1
    x = x + sum(data_matrixC[i, 1:end])
 end
 end

 exit = push!(exit,x)

  return exit
end

"""
Initializes a population, receives the population size and returns an array of randomly created Individuals

Função initPopulation recebe o valor do tamanho da população (pop_size) e cria uma população com esse número de indivíduos
retorna vetor de indivíduos
"""
function initPopulation(pop_size::Int)
    population::Array{Individual} =[]
  for i = 1:pop_size
    population = push!(population, Individual(geneSize))
  end
 return population
end
