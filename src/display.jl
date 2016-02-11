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
  println("Crowding distance:", p[i].crowdingDistance)

  print("Press enter to continue...");
  x = readline(STDIN)
  end
end

"""
Prints a brief description of each Individual in a population

Imprime uma descrição de cada Individual em uma população
"""
function printFile(p::Array{Individual})

  outfile = open("exit.txt", "w")

  for i = 1:length(p)
    if p[i].fenotype[1] < 9 && p[i].fenotype[2] == 55
      for j = 1:length(p[i].genotype)
        if(p[i].genotype[j]>0)
        print(j, "-")
        end
      end
     print("\n")
    end
  end
  close(outfile)
end

function aux()
  write(outfile, j,"-" )
    write(outfile,"\n")
write(outfile, repr(p[i].genotype ),"\n" )
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

