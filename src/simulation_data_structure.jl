using Formatting

abstract type GadgetSimulation end

struct GadgetSimulationDir <: GadgetSimulation
    dir::String

    function GadgetSimulationDir(dir::String)
        new(dir)
    end
end

struct GadgetSimulationDirWithData{T<:GadgetData} <: GadgetSimulation
    dir::String
    data::Vector{T}

    function GadgetSimulationDirWithData{T}(dir::String) where {T<:GadgetData}
        new(dir,Vector{T}(undef,largest_snapnum(dir)+1))
    end
end

"""
    largest_snapnum(dir::String)

Return the largest snapshot number, checking snapshots directly in `dir` (snap_XXX), and in sub-directories (snapdir_XXX).
"""
function largest_snapnum(dir::String)
    max_index = -1

    for entry in readdir(dir)
        # Check for file match: snap_XXX
        if occursin(r"^snap_\d+$", entry)
            idx = parse(Int64, split(entry, "_")[end])
            max_index = max(max_index, idx)
        # Check for directory match: snapdir_XXX
        elseif occursin(r"^snapdir_\d+$", entry)
            idx = parse(Int64, split(entry, "_")[end])
            max_index = max(max_index, idx)
        end
    end

    if max_index == -1
        error("dir seems to contain no snapshot")
    end

    return max_index
end

"""
    snapshot_in_directory(dir::String, i_snap::Int64, i_subsnap::Int64)

Return the name of the snapshot in format dir/snapdir_<i_snap>/snap_<i_snap>.<i_subsnap>.
"""
function snapshot_in_directory(dir::String, i_snap::Int64, i_subsnap::Int64)
    return snapshot_in_directory(dir, i_snap)*"."*sprintf1("%d",i_subsnap)
end
"""
    snapshot_in_directory(dir::String, i_snap::Int64)

Return the name of the snapshot in format dir/snapdir_<i_snap>/snap_<i_snap>.
"""
function snapshot_in_directory(dir::String, i_snap::Int64)
    return joinpath(dir, "snapdir_"*sprintf1("%03d",i_snap), "snap_"*sprintf1("%03d",i_snap))
end
"""
    snapshot_without_directory(dir::String, i_snap::Int64)

Return the name of the snapshot in format dir/snap_<i_snap>
"""
function snapshot_without_directory(dir::String, i_snap::Int64)
    return joinpath(dir, "snap_"*sprintf1("%03d",i_snap))
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

