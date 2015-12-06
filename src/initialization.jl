##
# 4 de dezembro de 2015
# NSGA-II in Julia
# Gustavo Fernandes de Almeida 10/0012183
# Funções de inicialização
##

# Função initGene recebe o valor de tamanho do gene (size) e cria um array desse tamanho com valores aleatórios 0 ou 1
# retorna vetor completo

function initGene(size::Int)
    array::Array{Int8,1} = []
  for i = 1:size
    array = push!(array,rand(0:1))
  end
   return array
end

#Função initFenotype recebe o genótipo e calcula o fenótipo relativo
#Nesse caso, é o número de 1's presentes
function initFenotype(entry::Array)
  x = 0
  for i = 1:length(entry)
    if entry[i] > 0
      x += 1
    end
  end
  exit::Array{Int32} = []
  exit = push!(exit, x)
  return exit
end

#Função initPopulation recebe o valor do tamanho da população (pop_size) e cria uma população com esse número de indivíduos
# retorna vetor de indivíduos
function initPopulation(pop_size::Int)
    population::Array{Individual} =[]
  for i = 1:pop_size
    population = push!(population, Individual(geneSize))
  end
 return population
end
