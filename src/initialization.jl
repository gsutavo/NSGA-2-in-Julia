##
# 4 de dezembro de 2015
# NSGA-II in Julia
# Gustavo Fernandes de Almeida 10/0012183
# Funções de inicialização
##


"""
Retorna um gene de tamanho size, que é um array valores aleatórios 0 ou 1 (Int8).
"""
function initGene(size::Int)
  return [convert(Int8, rand(0:1)) for i in 1:size]
end


"""
Retorna o fenótipo relativo ao genótipo dado. Neste caso, é a quantidade de
1's presentes.
"""
function initFenotype(entry::Array)
  count::Int32 = 0
  for number in entry
    if number == 1
      count += 1
    end
  end
  return [count]
end


"""
Cria uma população com pop_size indivíduos.
"""
function initPopulation(pop_size::Int)
  return [Individual(geneSize) for i in 1:pop_size];
end
