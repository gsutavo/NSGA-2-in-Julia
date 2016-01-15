##
# January 15th, 2016
# NSGA-II in Julia
# Gustavo Fernandes de Almeida  (gsutavo@outlook.com)
# Front Type
# Tipo Front
##

"""
Front Type represents a sub-group a population.
A population may be divided as fronts, the first front englobes individuals that dominate all others.
The second front, the individuals that are only dominated by the ones in the first front and that dominate all other individuals.
The third is dominated by the first and second and so on. There can be as many fronts as individuals.

Tipo Front representa um subgrupo de uma população.
Uma população pode ser dividida em fronts, o primeiro front engloba indivíduos (Individuals) que dominam todos os outros.
O segundo front é composto pelos indivíduos que são dominados apenas por aqueles do primeiro front e dominam todos os outros.
O terceiro é dominado pelo primeiro e segundo e assim por diante. Podem haver tantos fronts quanto indivíduos.

"""

type Front
  individuals::Array{Individual,1}  #

  function Front(pop::Array{Individual})
    individuals = copy(pop)
    new(individuals)
  end

  function add(new::Individual)
   individuals = push!(individuals,new)
  end

end
