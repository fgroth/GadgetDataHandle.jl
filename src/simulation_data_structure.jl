using Formatting

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

# additional constructors based on GadgetSimulationDir type
function GadgetFilename(simulation::GadgetSimulationDir, i_snap::Int64; kwargs...)
    if isfile(joinpath(simulation.dir, "snapdir_"*sprintf1("%03d",i_snap), "snap_"*sprintf1("%03d",i_snap)*".0"))
        return GadgetFilename(joinpath(simulation.dir, "snapdir_"*sprintf1("%03d",i_snap), "snap_"*sprintf1("%03d",i_snap)); kwargs...)
    elseif isfile(joinpath(simulation.dir, "snap_"*sprintf1("%03d",i_snap)))
        return GadgetFilename(joinpath(simulation.dir, "snap_"*sprintf1("%03d",i_snap)); kwargs...)
    else
        error("Snapshot not existing")
    end
end
