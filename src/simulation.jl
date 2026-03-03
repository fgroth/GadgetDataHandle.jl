
"""
    get_last_snapshot(simulation::GadgetSimulationDir; kwargs...)
    get_last_snapshot(simulation_dir::String="./"; include_directory::Bool=false)

Get the name of the last snapshot. 
"""
function get_last_snapshot(simulation::GadgetSimulationDir; kwargs...)
    return get_last_snapshot(simulation.dir ; kwargs...)
end
function get_last_snapshot(simulation_dir::String="./"; include_directory::Bool=false)
    last_snap = largest_snapnaum(simulation_dir, return_name=true)

    dir = if include_directory
        simulation_dir
    else
        ""
    end
    return joinpath(dir,last_snap)
end

"""
    get_last_snapnumber(simulation::GadgetSimulationDir)
    get_last_snapnumber(simulation_dir::String="./")

Get the number of the last snapshot.
"""
function get_last_snapnumber(simulation::GadgetSimulationDir)
    return get_last_snapnumber(simulation.dir)
end
function get_last_snapnumber(simulation_dir::String="./")
    return parse(Int64, get_last_snapshot(simulation_dir)[end-2:end])
end

"""
    largest_snapnum(dir::String; lower_end::Int64=0, upper_end::Int64=typemax(Int64), return_name::Bool=false)

Return the largest snapshot number, checking snapshots directly in `dir` (snap_XXX), and in sub-directories (snapdir_XXX).
"""
function largest_snapnum(dir::String; lower_end::Int64=0, upper_end::Int64=typemax(Int64), return_name::Bool=false)
    max_index = -1
    largest_snapname = ""

    for snap in get_all_snapshots(dir)
        # Check for file match: snap_XXX
        if is_single_snap(snap)
            idx = parse(Int64, split(snap, "_")[end])
            if lower_end <= idx <= upper_end
                max_index = max(max_index, idx)
                if return_name && idx==max_index
                    largest_snapname = snap
                end
            end
        # Check for directory match: snapdir_XXX
        elseif is_snapdir(snap)
            idx = parse(Int64, split(snap, "_")[end])
            if lower_end <= idx <= upper_end
                max_index = max(max_index, idx)
                if return_name && idx==max_index
                    largest_snapname = snap
                end
            end
        end
    end

    if max_index == -1
        if (lower_end != 0) || (upper_end != typemax(Int64))
            error("dir="*dir*" seems to contain no snapshot within given range ",(lower_end, upper_end))
        else
            error("dir="*dir*" seems to contain no snapshot")
        end
    end

    if return_name
        return largest_snapname
    end
    return max_index
end

"""
    get_snapshot(simulation_dir::String="./"; kwargs...)
    get_snapshot(simulation_dir::String="./"; include_directory::Bool=false,
                 i_snap::Int64=0,
                 first_snap_to_consider::Int64=0)

Return snapshot with desired number `i_snap`. If this does not exist, return the last existing snapshot before instead.
"""
function get_snapshot(simulation_dir::String="./"; kwargs...)
    return get_snapshot(simulation.dir ; kwargs...)
end
function get_snapshot(simulation_dir::String="./"; include_directory::Bool=false,
                      i_snap::Int64=0,
                      first_snap_to_consider::Int64=0)
    snaps = get_all_snapshots(GadgetSimulationDir(simulation_dir))
    dir = if include_directory
        simulation_dir
    else
        ""
    end
    for this_i_snap in i_snap:-1:first_snap_to_consider
        if single_snapshot(this_i_snap) in snaps
            return joinpath(dir, single_snapshot(this_i_snap))
        elseif snap_in_snapdir(this_i_snap) in snaps
            return joinpath(dir, snap_in_snapdir(this_i_snap))
        end
    end
end

"""
    issnap(file::String)

Return if a file or directory is a snapshot according to its name.

See also [`is_single_snap`](@ref) and [`is_single_snap`](@ref).
"""
function issnap(file::String)
    return is_single_snap(file) || is_snapdir(file)
end
"""
    is_single_snap(file::String)

Return if a file is a snapshot according to its name.
"""
function is_single_snap(file::String)
    return startswith(file,"snap_")
end
"""
    is_snapdir(file::String)

Return if a file / directory is a snapshot directory according to its name.
"""
function is_snapdir(file::String)
    return startswith(file,"snapdir_")
end

"""
    issub(file::String)

Return if a file or directory is a subfind output according to its name. 
"""
function issub(file::String)
    return startswith(file,"sub_") || startswith(file,"groups_")
end

"""
    get_all_snapshots(simulation::GadgetSimulationDir)
    get_all_snapshots(simulation_dir::String)

Return all snapshots for given `simulation`/`simulation_dir`.
"""
function get_all_snapshots(simulation::GadgetSimulationDir)
    get_all_snapshots(simulation.dir)
end
function get_all_snapshots(simulation_dir::String)
    all_files = readdir(simulation_dir)
    snaps = all_files[issnap.(all_files)]
    # now add the file instead of the directory if snaps are inside directorires
    for i_snap in 1:length(snaps)
        if startswith(snaps[i_snap],"snapdir_")
            snaps[i_snap] = joinpath(snaps[i_snap], "snap_"*snaps[i_snap][end-2:end])
        end
    end
    return snaps
end

"""
    get_all_subs(simulation::GadgetSimulationDir)
    get_all_subs(simulation_dir::String)

Return all subfind outputs for given `simulation`/`simulation_dir`.
"""
function get_all_subs(simulation::GadgetSimulationDir)
    get_all_subs(simulation.dir)
end
function get_all_subs(simulation_dir::String)
    all_files = readdir(simulation_dir)
    subs = all_files[issub.(all_files)]
    # now add the file instead of the directory if subs are inside directorires
    for i_sub in 1:length(sub)
        if startswith(subs[i_sub],"groups_")
            subs[i_sub] = joinpath(subs[i_sub], "sub_"*snaps[i_sub][end-2:end])
        end
    end
    return subs
end

"""
    get_previous_snapshot(i_snap::Int64, simulation::GadgetSimulationDir)

Get name of previous snapshot before current number.
"""
function get_previous_snapshot(i_snap::Int64, simulation::GadgetSimulationDir)
    all_snaps = get_all_snapshots(simulation)
    for previous_snap in i_snap-1:-1:0
        if single_snapshot(previous_snap) in all_snaps
            single_snapshot(previous_snap)
        elseif snap_in_snapdir(previous_snap) in all_snaps
            snap_in_snapdir(previous_snap)
        end
    end
    # if we reach this point, there is no further snapshot in simulation
end

"""
    get_next_snapshot(i_snap::Int64, simulation::GadgetSimulationDir)

Get name of next snapshot after current number.
"""
function get_next_snapshot(i_snap::Int64, simulation::GadgetSimulationDir)
    for next_snap in i_snap+1:get_last_snapnumber(simulation)
        if single_snapshot(next_snap) in all_snaps
            single_snapshot(next_snap)
        elseif snap_in_snapdir(next_snap) in all_snaps
            snap_in_snapdir(next_snap)
        end

    end
    # if we reach this point, there is no further snapshot in simulation
end

"""
    get_snapshot_closest_to_redshift(simulation::GadgetSimulationDir, redshift::Number)

Return the snapshot closest to the given redshift.
"""
function get_snapshot_closest_to_redshift(simulation::GadgetSimulationDir, redshift::Number)
    all_snaps = get_all_snapshots(simulation)
    all_redshift = Vector{Float64}(undef, length(all_snaps))
    for i_snap in 1:length(all_snaps)
        all_redshift[i_snap] = get_snap_header(GadgetFilename(all_snaps[i_snap])).z
    end
    
    relevant = argmin(abs.(all_redshift .- redshift))

    return all_snaps[relevant]
end
