using Formatting

"""
    single_snapshot(snapnum::Int64)

Return name of a snapshot.
"""
function single_snapshot(snapnum::Int64)
    return "snap_"*sprintf1("%03d", snapnum)
end

"""
    snapdir(snapnum::Int64)

Return name of a snapdir.
"""
function snapdir(snapnum::Int64)
    return "snapdir_"*sprintf1("%03d", snapnum)
end

"""
    snap_in_snapdir(snapnum::Int64)

Return the name of a snapshot in a snapdir. See [`snapdir`](@ref) and [`single_snapshot`](@ref).
"""
function snap_in_snapdir(snapnum::Int64)
    return joinpath(snapdir(snapnum), single_snapshot(snapnum))
end

"""
    get_number_of_sub_snaps(dir::String, snapnum::Int64)

Return the number of sub-snapshots.
"""
function get_number_of_sub_snaps(dir::String, snapnum::Int64)
    this_snapdir = joinpath(dir, snapdir(snapnum))
    if isdir(this_snapdir)
        all_subsnaps = readdir(this_snapdir)
        return sum(is_single_snap.(all_subsnaps))
    elseif isfile(joinpath(dir, single_snapshot(snapnum)))
        return 1
    end
    
    # no snapshot has been found
    return 0
end

"""
    get_simulation_path(snapname::String)

Return the simulation path for standard snapshot naming conventions.
"""
function get_simulation_path(snapname::String)
    # identify the snap name/directory
    m = match(r"^(.*?)(?:/snapdir_\d{3})?/snap_\d{3}$", snapname)
    if isnothing(m)
        error("Snapname does not follow standard snapshot directory conventions")
    end
    # return the main simulation directory
    return m.captures[1]
end

"""
    get_snapshot_number_from_name(snapname::String)

Return the snapshot number for standard snapshot naming conventions.
"""
function get_snapshot_number_from_name(snapname::String)
    # identify the pattern
    m = match(r"^.*?(?:/snapdir_\d{3})?/snap_(\d{3})$", snapname)
    if isnothing(m)
        error("Snapname does not follow standard snapshot directory conventions")
    end
    return parse(Int, m.captures[1])
end

