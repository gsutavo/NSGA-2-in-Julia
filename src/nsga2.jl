##
# 4 de dezembro de 2015
# NSGA-II in Julia
# Gustavo Fernandes de Almeida 10/0012183
#
##

module NSGA2

# Determina constantes
geneSize = 20
pop_size = 20        # número par
crossover_prob = 0.5
mutation_prob = 1/pop_size
generationNumber = 100

include("Individual.jl")
include("initialization.jl")
include("variation.jl")
include("display.jl")

# Seria bom uma especialização de rand
function random(population::Array{Individual})
  return population[rand(1:pop_size)]
end

"""
Recebe a população original e dobra o número novos indivíduos
# Seleciona por torneio binário, aplica crossover e mutação com probabilidade definida
"""
function expandPopulation(p::Array{Individual})
  q::Array{Individual} = []

  for i = 1:((length(p))/2)
    first_parent  = binaryTournament(random(p), random(p))
    second_parent = binaryTournament(random(p), random(p))

    first_child = Individual(first_parent.genotype)
    second_child = Individual(second_parent.genotype)

    if crossover_prob <= rand()
      crossover(first_child, second_child)
    end

    if mutation_prob <= rand()
      singleBitMutation(first_child)
    end
    if rand(0:1) >= mutation_prob
      singleBitMutation(second_child)
    end

    q = push!(q, first_child)
    q = push!(q, second_child)
  end
  append!(p,q)
end

#Função binaryTournament recebe dois indivíduos e os compara, retorna cópia do melhor
function binaryTournament(firstContender::Individual, secondContender::Individual)
  # Próximas versões terão mais parâmetros de comparação
  # Nessa quem tiver o menor número de valor de fenotype ganha
  if firstContender.fenotype[1] < secondContender.fenotype[1]
    return firstContender
  end

  if(firstContender.fenotype[1] > secondContender.fenotype[1])
    return secondContender
  end

  if(rand() > 0.5) #Caso os dois tenham resultados iguais
    return firstContender
  else
    return secondContender
  end
end

#Função que determina o valor dos fronts, np e Sp
function setFronts(p::Array{Individual})
  for i = 1:length(p)
    for j = 1:length(p)
      if i != j
        if  (dominates(p[i],p[j]))
          p[i].Sp = push!(p[i].Sp, p[j])
          p[j].np += 1
        end
      end
    end
  end

  sort!(p, lt = (x,y)-> x.np < y.np) # Ordena a população com o valor de np ascendente
  lowestNp = p[1].np
  current_rank = 1

  for i = 1:length(p)
    if p[i].np == lowestNp
       p[i].rank = current_rank
    else
      current_rank+=1
      lowestNp = p[i].np
      p[i].rank = current_rank
    end
  end

end

#Função simplificada do processo de domicação
function dominates(a::Individual, b::Individual)
  return a.fenotype[1] < b.fenotype[1]
end

#Função que reinicia os valores de np e Sp
function reset(p::Array{Individual})
   for i = 1:length(p)
    p[i].np = 0
    p[i].Sp = []
  end
end

function nsga2()
  #Testes
  P = initPopulation(pop_size) # População de tamanho pop_size é criada
  expandPopulation(P)          # População inicial é expandida tamanho 2*pop_size, população pai + população filha
  setFronts(P)                 # Determina o valor dos np e ranks
  printPopulation(P)

  for i = 1:generationNumber
       newP = P[1:pop_size]
       reset(newP)
       expandPopulation(newP)
       setFronts(newP)
       P = newP
  end

  println("-----------------------------------")
  println("População final")
  println("-----------------------------------")
  printPopulation(P)

end


end # module