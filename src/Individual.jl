##
# December 12th, 2015
# NSGA-II in Julia
# Gustavo Fernandes de Almeida  (gsutavo@outlook.com)
# Individual Type
# Tipo Individual
##

"""
Individual Type represents a possible solution

Tipo Individual representa uma possível solução
"""
type Individual
  genotype::Array{Int8,1} # represents this solution's genetic code: an array of integers 0 or 1
                          # representa o código genético dessa solução: um vetor com valores 0 ou 1

  fenotype::Array{Int32}  # represents the features that emerge from this solution's genotype
                          # representa as características emergentes do genótipo

  Sp::Array{Individual,1} # array of Individuals dominated by this one, initialized empty
                          # vetor de soluções dominadas por esse indivíduo, inicializado vazio

  np::Int                 # number of Individuals that dominate this one, initialized 0
                          # número de outros indivíduos que dominam esse, inicializado em 0

  rank::Int               # Individual's rank
                          # rank ou front que essa solução pertence

  function Individual(size::Int)  # Individual's constructor, receives an integer and initializes a genotype with random values
                                  # construtor do tipo recebe inteiro e cria o Individual com valores aleatórios
    genotype = initGene(size)
    fenotype = initFenotype(genotype)
    new(genotype,fenotype ,[],0,0)
  end
  function Individual(gene::Array{Int8})  # Individual's constructor, receives an array of integers and initializes a genotype with it
                                          # construtor do tipo que recebe vetor de inteiros e cria o Individual com ele como genotype
    genotype = copy(gene)
    fenotype = initFenotype(genotype)
    new(genotype,fenotype,[],0,0)
  end
end
