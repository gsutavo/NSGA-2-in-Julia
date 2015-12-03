##
# 2 de dezembro de 2015
# NSGA-II in Julia
# Gustavo Fernandes de Almeida 10/0012183
#
##

# Determina algumas constantes
geneSize = 5
initial_pop_size = 6 # número par
pop_size = 10        # número par
crossover_prob = 0.5
mutation_prob = 1/pop_size


#Tipo Individual representa uma possível solução

type Individual
  genotype::Array{Int8,1} # representa o código genético dessa solução: um vetor com valores 0 e 1
  fenotype::Array{Int32}  # representa as características emergentes do genótipo
  Sp::Array{Individual,1} # vetor de soluções dominadas por esse indivíduo, inicializado vazio
  np::Int                 # número de outros indivíduos que dominam esse, inicializado em 0
  fitness::Int            # valor de fitness, igual ao rank ou front que essa solução
  function Individual(size::Int) # construtor do tipo recebe inteiro e cria o Individual com valores aleatórios
    genotype = initGene(size)
    fenotype = initFenotype(genotype)
    new(genotype,fenotype ,[],0,0)
  end
  function Individual(gene::Array{Int8}) # construtor do tipo que recebe vetor de inteiros e cria o Individual com ele como genotype
    genotype = copy(gene)
    fenotype = initFenotype(genotype)
    new(genotype,fenotype,[],0,0)
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

#Função singleBitMutation recebe um vetor e troca o valor em um locus aleatório
function singleBitMutation(gene::Array)
  x = rand(1:length(gene))
  if gene[x] > 0
    gene[x] = 0
  else
    gene[x] = 1
  end
end

#Função singleBitMutation versão Individual
function singleBitMutation(individualA::Individual)
  x = rand(1:length(individualA.genotype))
  if individualA.genotype[x] > 0
     individualA.genotype[x] = 0
  else
     individualA.genotype[x] = 1
  end
    individualA.fenotype = initFenotype(individualA.genotype)
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
#Versão para tipo Individual
function crossover(individualA::Individual,individualB::Individual)
  if length(individualA.genotype) !=  length(individualB.genotype)
    println("Erro na função crossover: tamanho dos genes diferentes.")
    return
  end
  i = rand(1:length(individualA.genotype))
  #println(i) # Imprime locus aleatório
  v_aux = copy(individualA.genotype)
  individualA.genotype[i:end] = individualB.genotype[i:end]
  individualB.genotype[i:end] = v_aux[i:end]

  individualA.fenotype = initFenotype(individualA.genotype)
  individualB.fenotype = initFenotype(individualB.genotype)

end

# Retirado de http://samuelcolvin.github.io/JuliaByExample/#Arrays
function printsum(a)
    # summary generates a summary of an object
    println(summary(a), ": ", repr(a))
end
#--

#Função expandPopulation recebe a população original e o tamanho da população e cria novos indivíduos
# Seleciona por torneio binário, aplica crossover e mutação com probabilidade definida
function expandPopulation(p::Array{Individual}, pop_size)

  for i = 1:((pop_size - length(p))/2)
      newIndividual      = binaryTournament(p[rand(1:length(p))],p[rand(1:length(p))])
      otherNewIndividual = binaryTournament(p[rand(1:length(p))],p[rand(1:length(p))])
        if rand(0:1) >= crossover_prob
          crossover(newIndividual, otherNewIndividual)
        end
        if rand(0:1) >= mutation_prob
          singleBitMutation(newIndividual)
        end
        if rand(0:1) >= mutation_prob
          singleBitMutation(otherNewIndividual)
        end
     p = push!(p, newIndividual)
     p = push!(p, otherNewIndividual)
  end

end

#Função binaryTournament recebe dois indivíduos e os compara, retorna cópia do melhor
function binaryTournament(firstContender::Individual, secondContender::Individual)
  # Próximas versões terão mais parâmetros de comparação
  # Nessa quem tiver o menor número de valor de fenotype ganha
  if firstContender.fenotype[1] < secondContender.fenotype[1]
    return Individual(firstContender.genotype)
  end

  if(firstContender.fenotype[1] > secondContender.fenotype[1])
    return Individual(secondContender.genotype)
  end

  if(rand(0:100) > 50) #Caso os dois tenham resultados iguais
    return Individual(firstContender.genotype)
  else
    return Individual(secondContender.genotype)
  end
end

#Função que imprime alguns valores de uma população de indivíduos
function printPopulation(p::Array{Individual})
  for i = 1:length(p)
    print(i, " : ", p[i].genotype)
    println(" : ", p[i].fenotype)
  end
end

function nsga2()
  #Testes
  P = initPopulation(initial_pop_size)
  expandPopulation(P,pop_size)
  printPopulation(P)
  #sort!(P, lt = (x,y)-> x.fenotype[1] > y.fenotype[1])
end
