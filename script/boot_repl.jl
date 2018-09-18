let
if VERSION > v"0.7-"
  port = parse(Int, popfirst!(ARGS))
else
  port = parse(Int, shift!(ARGS))
end

junorc = haskey(ENV, "JUNORC_PATH")? normpath(joinpath(ENV["JUNORC_PATH"], ".junorc.jl")): abspath(homedir(), ".junorc.jl")

if (VERSION > v"0.7-" ? Base.find_package("Atom") : Base.find_in_path("Atom")) == nothing
  p = VERSION > v"0.7-" ? (x) -> printstyled(x, color=:cyan, bold=true) : (x) -> print_with_color(:cyan, x, bold=true)
  p("\nHold on tight while we're installing some packages for you.\nThis should only take a few seconds...\n\n")

  if VERSION > v"0.7-"
    using Pkg
    Pkg.activate()
  end

  Pkg.add("Atom")
  Pkg.add("Juno")

  println()
end

println("Starting Julia...")

try
  import Atom
  using Juno
  Atom.handle("junorc") do
    ispath(junorc) && include(junorc)
    nothing
  end
  Atom.connect(port)
catch
  rethrow()
end

end
