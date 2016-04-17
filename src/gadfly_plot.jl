##
# March 24 2016
# NSGA-II in Julia
# Gustavo Fernandes de Almeida (gsutavo@outlook.com)
# Display functions - Plotting using Gadfly
# Funções de apresentação
##

using Gadfly

"""
Plots simple 2D graph that gives a summary of a population distribution
"""
function plot_bee()
  data = readcsv("inter.csv")
  x1::Array{Int} = []
  y1::Array{Int} = []
  println("Plotting...")
  for counter in 1:size(data)[1]
    x1 = push!(x1, data[counter,1])
    y1 = push!(y1, data[counter,2])
  end
    plot( x = x1,
          y = y1,
          Stat.xticks(ticks=[-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]),
          Stat.yticks(ticks=[-5,0,5,10,15,20,25,30,35,40,45,50,55]),
          Guide.XLabel("How many areas"),
          Guide.YLabel("How many missing alelles"),
          Guide.title("NSGA-II's results"),
          Geom.beeswarm)

end

function plot_point()
  data = readcsv("inter.csv")
  x1::Array{Int} = []
  y1::Array{Int} = []
  println("Plotting...")
  for counter in 1:size(data)[1]
    x1 = push!(x1, data[counter,1])
    y1 = push!(y1, data[counter,2])
  end
    plot( x = x1,
          y = y1,
          Stat.xticks(ticks=[-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]),
          Stat.yticks(ticks=[-5,0,5,10,15,20,25,30,35,40,45,50,55]),
          Guide.XLabel("How many areas"),
          Guide.YLabel("How many missing alelles"),
          Guide.title("NSGA-II's results"),
          Geom.point)

end
