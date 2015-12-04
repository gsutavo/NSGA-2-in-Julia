##
# 4 de dezembro de 2015
# NSGA-II in Julia
# Gustavo Fernandes de Almeida 10/0012183
# Funções de apresentação
##

#Função que imprime alguns valores de uma população de indivíduos
function printPopulation(p::Array{Individual})
  for i = 1:length(p)
  println("--------------------")
  println("Genotype:",repr(p[i].genotype))
  println("Fenotype:",repr(p[i].fenotype))
  println("Sp:",summary(p[i].Sp))
  println("Np:",repr(p[i].np))
  end
end

# Retirado de http://samuelcolvin.github.io/JuliaByExample/#Arrays
function printsum(a)
    # summary generates a summary of an object
    println(summary(a), ": ", repr(a))
end
#--

