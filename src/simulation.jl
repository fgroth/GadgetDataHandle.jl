using Formatting

"""
    get_last_snapshot(simulation::GadgetSimulationDir; kwargs...)
    get_last_snapshot(simulation_dir::String="./"; include_directory::Bool=false)

Get the name of the last snapshot. 
"""
function get_last_snapshot(simulation::GadgetSimulationDir; kwargs...)
    return get_last_snapshot(simulation.dir ; kwargs...)
end
function get_last_snapshot(simulation_dir::String="./"; include_directory::Bool=false)
    snaps = get_all_snapshots(GadgetSimulationDir(simulation_dir))
    last_snap = sort(snaps)[end]
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
        if "snap_"*sprintf1("%03d",this_i_snap) in all_files
            return joinpath(dir, "snap_"*sprintf1("%03d",this_i_snap))
        elseif "snapdir_"*sprintf1("%03d",this_i_snap) in all_files
            return joinpath(dir, "snapdir_"*sprintf1("%03d",this_i_snap), "snap_"*sprintf1("%03d",this_i_snap))
        end
    end
end

"""
    issnap(file::String)

Return if a file or directory is a snapshot according to its name. 
"""
function issnap(file::String)
    return startswith(file,"snap_") || startswith(file,"snapdir_")
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

Return all snapshots for give `simulation`.
"""
function get_all_snapshots(simulation::GadgetSimulationDir)
    all_files = readdir(simulation.dir)
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

Return all subfind outputs for given `simulation`.
"""
function get_all_subs(simulation::GadgetSimulationDir)
    all_files = readdir(simulation.dir)
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
        if "snap_"*sprintf1("%03d",previous_snap) in all_snaps
            "snap_"*sprintf1("%03d",previous_snap)
        elseif joinpath("snapdir_"*sprintf1("%03d",previous_snap), "snap_"*sprintf1("%03d",previous_snap)) in all_snaps
            joinpath("snapdir_"*sprintf1("%03d",previous_snap), "snap_"*sprintf1("%03d",previous_snap))
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
        if "snap_"*sprintf1("%03d",next_snap) in all_snaps
            "snap_"*sprintf1("%03d",next_snap)
        elseif joinpath("snapdir_"*sprintf1("%03d",next_snap), "snap_"*sprintf1("%03d",next_snap)) in all_snaps
            joinpath("snapdir_"*sprintf1("%03d",next_snap), "snap_"*sprintf1("%03d",next_snap))
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
