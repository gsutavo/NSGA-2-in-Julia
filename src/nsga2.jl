##
# 26 de novembro de 2015
# NSGA-II in Julia
# Gustavo Fernandes de Almeida 10/0012183
#
##
type Solution
  genotype::Array{Int8,1}
  Sp::Array{Solution,1}
  np::Int

  Solution(size::Int) = new(initGene(size), [],0)

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
   printsum(array)
   return array
end

function nsga2()
  P::Array{Solution} =[]
  for i = 1:10
    P = push!(P, Solution(20))
  end
  printsum(P)
end
