##
# 26 de novembro de 2015
# NSGA-II in Julia
# Gustavo Fernandes de Almeida 10/0012183
#
##
type Individual
  genotype::Array{Int8,1}
  Sp::Array{Individual,1}
  np::Int

  Individual(size::Int) = new(initGene(size), [],0)

end

# Retirado de http://samuelcolvin.github.io/JuliaByExample/#Arrays
function printsum(a)
    # summary generates a summary of an object
    println(summary(a), ": ", repr(a))
end
#--

function initGene(size::Int)
    array::Array{Int8,1} = []
  for i = 1:size
    array = push!(array,rand(0:1))
  end
   return array
end

function initPopulation(pop_size::Int)
    population::Array{Individual} =[]
  for i = 1:pop_size
    population = push!(population, Individual(20))
  end
 return population
end

function nsga2()
  P = initPopulation(5)
  #printsum(P)
end
