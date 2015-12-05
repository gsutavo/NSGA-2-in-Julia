##
# 4 de dezembro de 2015
# NSGA-II in Julia
# Gustavo Fernandes de Almeida 10/0012183
# Funções de inicialização
##


"""
Retorna um gene de tamanho size, que é um array valores aleatórios 0 ou 1 (Int8).
"""
function initialize_gene(size::Int)
  return [convert(Int8, rand(0:1)) for i in 1:size]
end


"""
Retorna a quantidade de ocorrências de x no array.
"""
function count(x, array::Array)
  counter = 0
  for element in array
    if element == x
      counter += 1
    end
  end
  return counter
end


"""
Retorna o fenótipo relativo ao genótipo dado. Neste caso, é a quantidade de
1's presentes.
"""
function initialize_fenotype(entry::Array)
  return [convert(Int32, count(1, entry))]
end


"""
Cria uma população com pop_size indivíduos.
"""
function initialize_population(pop_size::Int)
  return [Individual(GENE_SIZE) for i in 1:pop_size];
end
