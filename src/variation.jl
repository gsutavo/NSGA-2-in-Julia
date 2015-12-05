##
# 4 de dezembro de 2015
# NSGA-II in Julia
# Gustavo Fernandes de Almeida 10/0012183
# Funções que introduzem variação
##

#Função bit_mutation recebe um vetor e troca o valor em um locus aleatório
function bit_mutation(gene::Array)
  x = rand(1:length(gene))
  if gene[x] > 0
    gene[x] = 0
  else
    gene[x] = 1
  end
end

#Função bit_mutation versão Individual
function bit_mutation(individualA::Individual)
  x = rand(1:length(individualA.genotype))
  if individualA.genotype[x] > 0
     individualA.genotype[x] = 0
  else
     individualA.genotype[x] = 1
  end
    individualA.fenotype = initialize_fenotype(individualA.genotype)
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
function crossover(x::Individual, y::Individual)
  if length(x.genotype) != length(y.genotype)
    println("Erro na função crossover: tamanho dos genes diferentes.")
    return
  end

  crossoverPoint = rand(1:length(x.genotype))
  #println(i) # Imprime locus aleatório
  v_aux = copy(x.genotype)
  x.genotype[crossoverPoint:end] = y.genotype[crossoverPoint:end]
  y.genotype[crossoverPoint:end] = v_aux[crossoverPoint:end]

  x.fenotype = initialize_fenotype(x.genotype)
  y.fenotype = initialize_fenotype(y.genotype)

end