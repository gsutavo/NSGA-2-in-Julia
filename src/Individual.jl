##
# NSGA-II in Julia
# Gustavo Fernandes de Almeida  (gsutavo@outlook.com)
# Individual Type
##

"""
Individual Type represents a possible solution
"""
type Individual
  genotype::Array{Int8,1}   # represents this solution's genetic code: an array of integers 0 or 1
  fenotype::Array{Float32}  # represents the features that emerge from this solution's genotype
  S::Array{Individual,1}    # array of Individuals dominated by this one, initialized empty
  n::Int                    # number of Individuals that dominate this one, initialized 0
  rank::Int                 # Individual's rank
  crowdingDistance::Float32 # Crowding distance value

# Individual's constructor, receives an integer and initializes
# a genotype with random values
  function Individual(size::Int)
    genotype = initGene(size)
    fenotype = initFenotype(genotype)
    new(genotype,fenotype ,[],0,0,0)
  end
   # Individual's constructor, receives an array of integers and initializes
   #a genotype with it
  function Individual(gene::Array{Int8})

    genotype = copy(gene)
    fenotype = initFenotype(genotype)
    new(genotype,fenotype,[],0,0,0)
  end
end
