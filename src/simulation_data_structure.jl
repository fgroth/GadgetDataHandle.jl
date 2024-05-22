abstract type GadgetSimulation end

struct GadgetSimulationDir <: GadgetSimulation
    dir::String

    function GadgetSimulationDir(dir::String)
        new(dir)
    end
end

mutable struct GadgetSimulationDirWithData <: GadgetSimulation
    dir::String
    data::Vector{GadgetData}

    function GadgetSimulationDirWithData(dir::String)
        new(dir,Vector{GadgetData}(undef,1))
    end
end
