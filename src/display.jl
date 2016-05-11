##
# March 13 2016
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
Prints in a file
"""
function createInterFile(p::Array{Individual})

  outfile = open("inter.csv", "w")

  for i = 1:length(p)
      write(outfile, string(p[i].fenotype[1],",",p[i].fenotype[2],",",p[i].fenotype[3],",",p[i].fenotype[4],"\n"))
  end
  close(outfile)
end


"""
Prints in a file and prompt some solutions, helps debugging
"""
function debug_printFile(p::Array{Individual})

  outfile = open("exit.txt", "w")

  for i = 1:length(p)
    if p[i].fenotype[1] < 9 && p[i].fenotype[2] == 0
      for j = 1:length(p[i].genotype)
        if(p[i].genotype[j]>0)
          write(outfile, string(j,"-") )
          print(j, "-")
        end
      end
     write(outfile,string("\n"))
     print("\n")
    end
  end
  close(outfile)
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
