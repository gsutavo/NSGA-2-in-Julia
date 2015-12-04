##
# 4 de dezembro de 2015
# NSGA-II in Julia
# Gustavo Fernandes de Almeida 10/0012183
# Tipo Individual
##

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