module GadgetDataHandle

include("gadget_data_structure.jl")
export GadgetData, GadgetFilename,
    GadgetFilenameWithData, GadgetOnlyData,
    default_selection_function

include("snap_reader.jl")
export get_snap_data, get_snap_data!,
    get_snap_data_in_box,get_snap_data_in_box!,
    get_snap_header, get_snap_header!

include("sub_reader.jl")
export get_sub_data, get_sub_data!

include("remove_data.jl")
export has_snap_data, has_sub_data,
    remove_snap_data!, remove_sub_data!

include("gadget_general.jl")

include("simulation_data_structure.jl")
export GadgetSimulation,
    GadgetSimulationDir,
    GadgetSimulationDirWithData,
    largest_snapnum
include("simulation.jl")
export get_last_snapshot, get_last_snapnumber,
    get_snapshot

include("units.jl")
export GadgetUnits

include(joinpath("diagnostic_files","read_sfr.jl"))
export read_sfr_txt

include(joinpath("diagnostic_files","read_cpu.jl"))
export read_cpu_file, cpu_value_evolution

end # module
