##
# 27 de novembro de 2015
# NSGA-II in Julia
# Gustavo Fernandes de Almeida 10/0012183
#
##

# Determina o tamanho dos genes
geneSize = 5

#Tipo Individual representa uma possível solução

type Individual
  genotype::Array{Int8,1} # representa o código genético dessa solução: um vetor com valores 0 e 1
  fenotype::Array{Int32}  # representa as características emergentes do genótipo
  Sp::Array{Individual,1} # vetor de soluções dominadas por esse indivíduo, inicializado vazio
  np::Int                 # número de outros indivíduos que dominam esse, inicializado em 0
  fitness::Int            # valor de fitness, igual ao rank ou front que essa solução
  function Individual(size::Int) # construtor do tipo
    genotype = initGene(size)
    fenotype = initFenotype(genotype)
    new(genotype,fenotype ,[],0,0)
  end
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

function nsga2()
  #Testes
  P = initPopulation(5)
  printsum(P)
  println("---------------------------")
  sort!(P, lt = (x,y)-> x.fenotype[1] > y.fenotype[1])
  printsum(P)
end

#Função singleBitMutation recebe um vetor e troca o valor em um locus aleatório
function singleBitMutation(gene::Array)
  x = rand(0:length(gene))
  if gene[x] > 0
    gene[x] = 0
  else
    gene[x] = 1
  end
end

#Função crossover recebe dois vetores e troca os valores entre eles a partir em um locus aleatório
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
