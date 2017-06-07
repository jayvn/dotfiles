# Keybindings
# Should define repoloc in juliarc
include(joinpath(repoloc, "set_loadpath.jl"))
import Base: LineEdit, REPL

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

global const NOPC = true

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

function recompile()
    for pkg in Pkg.available()
        try
            pkgsym = Symbol(pkg)
            eval(:(using $pkgsym))
        catch
        end
    end
end

pkgupdate() = (Pkg.update(); recompile())
include("juliadebug.jl")
