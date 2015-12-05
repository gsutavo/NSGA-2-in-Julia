##
# 4 de dezembro de 2015
# NSGA-II in Julia
# Gustavo Fernandes de Almeida 10/0012183
#
##

module Nsga2

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


"""
Retorna um indivíduo aleatório da população dada.
"""
function random(population::Array{Individual})
  # Seria bom uma especialização de rand
  return population[rand(1:pop_size)]
end


"""
Seleciona aleatoriamente 2 indivíduos da população.
"""
function random_parents(population::Array{Individual})
  first  = binary_tournament(random(population), random(population))
  second = binary_tournament(random(population), random(population))

  return first, second
end

function should_crossover()
  return crossover_prob <= rand()
end

function should_mutate()
  return mutation_prob <= rand()
end

"""
Recebe a população original e dobra o número novos indivíduos
# Seleciona por torneio binário, aplica crossover e mutação com probabilidade definida
"""
function expand_population(population::Array{Individual})
  q::Array{Individual} = []

  num_steps = length(population)/2

  for i = 1:num_steps
    # children::Array{Individual} = random_parents(population)
    first_child, second_child = random_parents(population)

    if should_crossover()
      crossover(first_child, second_child)
      # crossover(children)
    end

    children = [first_child, second_child]
    for child in children
      if should_mutate()
        bit_mutation(child)
      end
    end

    append!(q, children)
  end

  append!(population, q)
end


"""
Indica se são equivalentes.
"""
function equals(a::Individual, b::Individual)
  return a.fenotype[1] == b.fenotype[1]
end


"""
Retorna o vencedor entre uma disputa.
"""
function winner(a::Individual, b::Individual)
  return a.fenotype[1] < b.fenotype[1] ? a : b
end


#Função binary_tournament recebe dois indivíduos e os compara, retorna cópia do melhor
function binary_tournament(firstContender::Individual, secondContender::Individual)
  # Próximas versões terão mais parâmetros de comparação
  # Nessa quem tiver o menor número de valor de fenotype ganha
  if equals(firstContender, secondContender)
    return (rand() > 0.5) ? firstContender : secondContender
  end

  return winner(firstContender, secondContender)
end

#Função que determina o valor dos fronts, np e Sp
function set_fronts(p::Array{Individual})
  for i = 1:length(p)
    for j = 1:length(p)
      if i != j
        if dominates(p[i],p[j])
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
  P = initialize_population(pop_size) # População de tamanho pop_size é criada
  expand_population(P)          # População inicial é expandida tamanho 2*pop_size, população pai + população filha
  set_fronts(P)                 # Determina o valor dos np e ranks
  print_population(P)

  for i = 1:generationNumber
       newP = P[1:pop_size]
       reset(newP)
       expand_population(newP)
       set_fronts(newP)
       P = newP
  end

  println("-----------------------------------")
  println("População final")
  println("-----------------------------------")
  print_population(P)

end


end # module