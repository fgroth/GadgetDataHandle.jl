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
