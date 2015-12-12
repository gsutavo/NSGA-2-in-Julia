##
# December 12th, 2015
# NSGA-II in Julia
# Gustavo Fernandes de Almeida  (gsutavo@outlook.com)
# Variation functions
# Funções que introduzem variação
##

"""
Receives an array of integers and flips a bit (0 to 1 or 1 to 0) in a random locus

Função singleBitMutation recebe um vetor e troca o valor em um locus aleatório
"""

function singleBitMutation(gene::Array)
  x = rand(1:length(gene))
  if gene[x] > 0
    gene[x] = 0
  else
    gene[x] = 1
  end
end

"""
Receives a Individual and flips a bit in a random locus

Função singleBitMutation versão Individual
"""

function singleBitMutation(individualA::Individual)
  x = rand(1:length(individualA.genotype))
  if individualA.genotype[x] > 0
     individualA.genotype[x] = 0
  else
     individualA.genotype[x] = 1
  end
    individualA.fenotype = initFenotype(individualA.genotype)
end

"""
Receives two vetors and switch their values from a random locus

Função crossover recebe dois vetores e troca os valores entre eles a partir em um locus aleatório
"""
function crossover(geneA::Array{Int8} , geneB::Array{Int8})
  if length(geneA) !=  length(geneB)
    println("Erro na função crossover: tamanho dos genes diferentes.")
    return
  end
  i = rand(1:length(geneA))
  #println(i) # Prints random locus
  v_aux = copy(geneA)
  geneA[i:end] = geneB[i:end]
  geneB[i:end] = v_aux[i:end]
end

"""
Crossover function version for Individual type

Versão da função crossover para tipo Individual
"""

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
