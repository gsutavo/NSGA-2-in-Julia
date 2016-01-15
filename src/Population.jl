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
