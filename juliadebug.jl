function dbg(dat...)
    str = join(dat, " ")
    open(joinpath(repoloc,".snipdbgfile.jl"), "a") do f
        write(f, sprint(println, Dates.format(now(),"HH:MM:SS"), " >  ", str))
    end
end
