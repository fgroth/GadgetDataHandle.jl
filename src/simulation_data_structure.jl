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

function snapshot_in_directory(dir::String, i_snap::Int64, i_subsnap::Int64)
    return snapshot_in_directory(dir, i_snap)*"."*sprintf1("%d",i_subsnap)
end
function snapshot_in_directory(dir::String, i_snap::Int64)
    return joinpath(dir, "snapdir_"*sprintf1("%03d",i_snap), "snap_"*sprintf1("%03d",i_snap))
end
function snapshot_without_directory(dir::String, i_snap::Int64)
    return joinpath(dir, "snapdir_"*sprintf1("%03d",i_snap), "snap_"*sprintf1("%03d",i_snap)*".0")
end


# additional constructors based on GadgetSimulationDir type
function GadgetFilename(simulation::GadgetSimulationDir, i_snap::Int64; kwargs...)
    if isfile(snapshot_in_directory(simulation.dir, i_snap, 0))
        return GadgetFilename(snapshot_in_directory(simulation.dir, i_snap); kwargs...)
    elseif isfile(snapshot_without_directory(dir, i_snap))
        return GadgetFilename(snapshot_without_directory(dir, i_snap); kwargs...)
    else
        error("Snapshot not existing")
    end
end
function GadgetFilenameWithData(simulation::GadgetSimulationDir, i_snap::Int64; kwargs...)
    if isfile(snapshot_in_directory(simulation.dir, i_snap, 0))
        return GadgetFilenameWithData(snapshot_in_directory(simulation.dir, i_snap); kwargs...)
    elseif isfile(snapshot_without_directory(dir, i_snap))
        return GadgetFilenameWithData(snapshot_without_directory(dir, i_snap); kwargs...)
    else
        error("Snapshot not existing")
    end
end
