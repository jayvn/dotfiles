function recompile()
    @eval using Pkg
    for pkg in keys(Pkg.installed())
        println("Compiling ", pkg)
        @eval using $(Symbol(pkg))
    end
end


@async begin
    sleep(0.1)
    @eval using Revise
end

# using OhMyREPL

const nCr = binomial
# nPr(n, r) = n == r + 1 ? r + 1 : n * nPr(n-1, r)
nPr(n, r) = factorial(n) / factorial(r)

# ENV["PLOTS_DEFAULT_BACKEND"] = pyplot
#
