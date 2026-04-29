module GadgetDataHandle

include("gadget_general.jl")
include("gadget_data_structure.jl")
export GadgetData, GadgetFilename,
    GadgetFilenameWithData, GadgetOnlyData,
    default_selection_function

include("snap_reader.jl")
export get_snap_data, get_snap_data!,
    get_snap_data_in_box,get_snap_data_in_box!,
    get_snap_header, get_snap_header!
include("sub_reader.jl")
export choose_subfind_fieldname,
    get_sub_data, get_sub_data!

include("check_data.jl")
export has_snap_block, has_sub_block,
    has_snap_data, has_sub_data

include("modify_snap.jl")
export set_snap_data!
include("modify_sub.jl")
export set_sub_data!

include("remove_data.jl")
export remove_snap_data!, remove_sub_data!

include("helper_function.jl")
export has_key_files
include("snapshot.jl")
export get_number_of_sub_snaps,
    get_simulation_path,
    get_snapshot_number_from_name
include("estimate_pmgrid.jl")
export estimate_highres_pmgrid

include("units.jl")
export GadgetUnits, HubbleFactors


include(joinpath("diagnostic_files","read_cpu.jl"))
export read_cpu_file, cpu_value_evolution
include(joinpath("diagnostic_files","read_sfr.jl"))
export read_sfr_txt
include(joinpath("diagnostic_files","read_bh.jl"))
export read_blackholes_txt,
    read_bh_details


include("simulation_data_structure.jl")
export GadgetSimulation,
    GadgetSimulationDir,
    GadgetSimulationDirWithData

include("simulation.jl")
export get_last_snapshot, get_last_snapnumber,
    largest_snapnum,
    get_snapshot


end # module
