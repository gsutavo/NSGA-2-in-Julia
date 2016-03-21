##
# March 13 2016
# NSGA-II in Julia
# Gustavo Fernandes de Almeida (gsutavo@outlook.com)
# Display functions
# Funções de apresentação
##
"""
Plots simple 2D graph that gives a summary of a population distribution
"""
function debug_plot(p::Array{Individual})
  x1::Array{Int} = []
  y1::Array{Int} = []
  println("Plotting...")
  for counter in 1:pop_size
    x1 = push!(x1, p[counter].fenotype[1])
    y1 = push!(y1, p[counter].fenotype[2])
  end
    plot(x = x1, y = y1,  Guide.XLabel("How many areas"), Guide.YLabel("How many aleles"),  Geom.beeswarm)

end

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
Prints in a file and prompt some solutions, helps debugging
"""
function debug_printFile(p::Array{Individual})

  outfile = open("exit.txt", "w")

  for i = 1:length(p)
    if p[i].fenotype[1] < 9 && p[i].fenotype[2] == 55
      for j = 1:length(p[i].genotype)
        if(p[i].genotype[j]>0)
        write(outfile, j,"-" )
        print(j, "-")
        end
      end
     write(outfile,"\n")
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

