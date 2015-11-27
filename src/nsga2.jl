##
# 27 de novembro de 2015
# NSGA-II in Julia
# Gustavo Fernandes de Almeida 10/0012183
#
##

#Tipo Individualrepresenta uma possível solução

type Individual
  genotype::Array{Int8,1} # representa o código genético dessa solução: um vetor com valores 0 e 1
  Sp::Array{Individual,1} # vetor de soluções dominadas por esse indivíduo, inicializado vazio
  np::Int                 # número de outros indivíduos que dominam esse, inicializado em 0

  Individual(size::Int) = new(initGene(size), [],0) # construtor do tipo

end

# Função initGene recebe o valor de tamanho do gene (size) e cria um array desse tamanho com valores aleatórios 0 ou 1
# retorna vetor completo

function initGene(size::Int)
    array::Array{Int8,1} = []
  for i = 1:size
    array = push!(array,rand(0:1))
  end
   return array
end

#Função initPopulation recebe o valor do tamanho da população (pop_size) e cria uma população com esse número de indivíduos
# retorna vetor de indivíduos
function initPopulation(pop_size::Int)
    population::Array{Individual} =[]
  for i = 1:pop_size
    population = push!(population, Individual(20))
  end
 return population
end

function nsga2()
  P = initPopulation(5)
  v1 = initGene(5)
  v2 = initGene(5)
  printsum(v1)
  printsum(v2)
  crossover(v1,v2)

  printsum(v1)
  printsum(v2)

  singleBitMutation(v1)
  printsum(v1)

  #printsum(P)
end

#Função singleBitMutation recebe um vetor e troca o valor de um locus aleatório
function singleBitMutation(gene::Array)
  x = rand(0:length(gene))
  if gene[x] > 0
    gene[x] = 0
  else
    gene[x] = 1
  end
end

#Função crossover recebe dois vetores e troca os valores entre eles a partir de um locus aleatório
function crossover(geneA::Array{Int8} , geneB::Array{Int8})
  if length(geneA) !=  length(geneB)
    println("Erro na função crossover: tamanho dos genes diferentes.")
    return
  end
  i = rand(1:length(geneA))
  #println(i) # Imprime locus aleatório
  v_aux = copy(geneA)
  geneA[i:end] = geneB[i:end]
  geneB[i:end] = v_aux[i:end]
end

# Retirado de http://samuelcolvin.github.io/JuliaByExample/#Arrays
function printsum(a)
    # summary generates a summary of an object
    println(summary(a), ": ", repr(a))
end
#--
