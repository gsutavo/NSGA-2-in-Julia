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
function crossover(individualA::Individual, individualB::Individual)
  if length(individualA.genotype) !=  length(individualB.genotype)
    println("Erro na função crossover: tamanho dos genes diferentes.")
    return
  end
  i = rand(1:length(individualA.genotype))
  #println(i) # Imprime locus aleatório
  v_aux = copy(individualA.genotype)
  individualA.genotype[i:end] = individualB.genotype[i:end]
  individualB.genotype[i:end] = v_aux[i:end]

  individualA.fenotype = initialize_fenotype(individualA.genotype)
  individualB.fenotype = initialize_fenotype(individualB.genotype)

end