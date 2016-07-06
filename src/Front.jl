##
# NSGA-II in Julia
# Gustavo Fernandes de Almeida  (gsutavo@outlook.com)
# Front Type
##

"""
Front Type represents a sub-group a population.
A population may be divided as fronts, the first front englobes individuals that dominate all others.
The second front, the individuals that are only dominated by the ones in the first front and that dominate all other individuals.
The third is dominated by the first and second and so on. There can be as many fronts as individuals.
"""

type Front
  individuals::Array{Individual,1}

  function Front(pop::Array{Individual})
    individuals = copy(pop)
    new(individuals)
  end

  function add(new::Individual)
   individuals = push!(individuals,new)
  end

end
