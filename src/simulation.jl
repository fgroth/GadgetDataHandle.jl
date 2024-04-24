"""
    get_last_snapshot(simulation_dir::String="./"; include_directory::Bool=false)

Get the name of the last snapshot. 
"""
function get_last_snapshot(simulation_dir::String="./"; include_directory::Bool=false)
    all_files = readdir(simulation_dir)
    snaps=all_files[contains.(all_files,"snap_") .|| contains.(all_files,"snapdir_")]
    last_snap = sort(snaps)[end]
    dir = if include_directory
        simulation_dir
    else
        ""
    end
    if contains(last_snap,"snapdir_")
        return dir*last_snap*"/snap_"*last_snap[end-2:end]
    else
        return dir*last_snap
    end
end

"""
    get_last_snapnumber(simulation_dir::String="./")

Get the number of the last snapshot.
"""
function get_last_snapnumber(simulation_dir::String="./")
    return parse(Int64, get_last_snapshot(simulation_dir)[end-2:end])
end
