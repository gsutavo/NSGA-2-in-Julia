##
# December 12th, 2015
# NSGA-II in Julia
# Gustavo Fernandes de Almeida (gsutavo@outlook.com)
# Display functions
# Funções de apresentação
##

"""
Prints a brief description of each Individual in a population

Imprime uma descrição de cada Individual em uma população
"""
function printPopulation(p::Array{Individual})
  for i = 1:length(p)
  println("-----------------------------------")
  println("Genotype:",repr(p[i].genotype))
  println("Fenotype:",repr(p[i].fenotype))
  println("S:",summary(p[i].S))
  println("n:",repr(p[i].n))
  println("Rank:", p[i].rank)
  end
end

"""
Prints a summary of each element of a type
Taken from: http://samuelcolvin.github.io/JuliaByExample/#Arrays

Imprime sumário de um tipo
Retirado de: http://samuelcolvin.github.io/JuliaByExample/#Arrays
"""
function printsum(a)
    # summary generates a summary of an object
    println(summary(a), ": ", repr(a))
end

