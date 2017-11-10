# Keybindings
# Should define repoloc in juliarc
include(joinpath(repoloc, "set_loadpath.jl"))
# include(joinpath(dirname(JULIA_HOME),"share","julia","build_sysimg.jl")); build_sysimg(force=true)

import Base: LineEdit, REPL

#=
function dbg(dat...)
    str = join(dat, " ")
    open(joinpath(repoloc,".snipdbgfile.jl"), "a") do f
        write(f, sprint(println, Dates.format(now(),"HH:MM:SS"), " >  ", str))
    end
end
=#
const mykeys = Dict{Any,Any}(
  # Up Arrow - k
  # "^[k" => (s,o...)->(LineEdit.edit_move_up(s) || LineEdit.enter_prefix_search(s, LineEdit.mode(s).hist, true)),
  #"^[k" => (s,data,c)->(LineEdit.history_prev_prefix(s, LineEdit.mode(s).hist)),
  #"^[k" => (s,o...)->(LineEdit.edit_move_up(s) || LineEdit.history_prev_prefix(s, LineEdit.mode(s).hist)),
  # )"\e[5~" => (s,o...)->(LineEdit.history_prev_prefix(s, LineEdit.mode(s).hist)),

  # Down Arrow - j
  "^[k" => (s,o...)->(LineEdit.edit_move_up(s) || LineEdit.history_prev(s, LineEdit.mode(s).hist)),
  "^[j" => (s,o...)->(LineEdit.edit_move_up(s) || LineEdit.history_next(s, LineEdit.mode(s).hist))
)

function customize_keys(repl)
  repl.interface = REPL.setup_interface(repl; extra_repl_keymap = mykeys)
end

atreplinit(customize_keys)

# global const NOPC = true

SEPARATOR = "\n"

emerge() = (Pkg.update(); Pkg.build(); recompile())

function recompile()
    for pkg in Pkg.available()
        try
            info("Compiling: $pkg")
            pkgsym = Symbol(pkg)
            eval(:(using $pkgsym))
            # eval(Expr(:toplevel, Expr(:using, Symbol(pkg))))
            println(SEPARATOR)
        catch err
            warn("Unable to precompile: $pkg")
            warn(err)
            println(SEPARATOR)
        end
    end
end

@schedule begin
    sleep(0.1)
    @eval using Revise
end

# push!(LOAD_PATH, "/home/jay/ev/StatsBase.jl")
# push!(LOAD_PATH, "/home/jay/ev/")
