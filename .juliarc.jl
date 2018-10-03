SEPARATOR = "\n"
function recompile_packages()
  for pkg in keys(Pkg.installed())
    try
      info("Compiling: $pkg")
      eval(Expr(:toplevel, Expr(:using, Symbol(pkg))))
      println(SEPARATOR)
    catch err
      warn("Unable to precompile: $pkg")
      warn(err)
      println(SEPARATOR)
    end
  end
end

emerge() = (Pkg.update(); Pkg.build(); recompile_packages())

#=
Why does this segfault
function recompile2()
  for pkg in Pkg.available()
    println(pkg)
    try
      pkgsym = Symbol(pkg)
      eval(:(using $pkgsym))
    catch
    end
  end
end
=#

function recompile()
  for pkg in keys(Pkg.installed())
    pkg == "Gtk" && continue
    println("Compiling ", pkg)
    pkgsym = Symbol(pkg)
    eval(:(using $pkgsym))
  end
end

#=
@schedule begin
    sleep(0.1)
    @eval using Revise
end
=#

const nCr = binomial
nPr(n, r) = factorial(n, n-r)

gen_coll(f, itr) = [ f(x) for x in itr ]

using OhMyREPL
