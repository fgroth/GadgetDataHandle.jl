# GadgetDataHandle.jl

## Snapshot Handling

The main purpose of this package is to introduce wrapper functions for [GadgetIO](https://github.com/LudwigBoess/GadgetIO.jl)


### Data types

This package introduces several datatypes of AbstractType `GadgetData`.
They enable to:
- deal with snapshot and subfind data more easily, including some additional checks (e.g. for alterantive field naming conventions within subfind)
- and the possibility to preserve data between different functions.

The different types are stored as (mutable) structs, containing different combinations of the fields `snap_data`/`sub_data` and `snap`/`sub`.

`snap`/`sub` are the names/locations of the snapshot/subfind files. They are used with GadgetIO to read in additional data (see below).

`snap_data`/`sub_data` are dictionaries mapping field name and particle type to the data. It thus allows to pass the same information to several functions without reading it multiple times, and to store additional data missing in the snapshot obtained e.g. via post-processing.

In addition, they can have a field `selection_function` that allows for consistent filtering of data during reading. The behavior of the function is specified with the `select_particle_types` field. This function is applied during reading. 

In particular, the types introduced contain the following content:

| typename                | `snap`, `sub` | `snap_data`, `sub_data` | `selection_function`, `select_particle_types` |
| ----------------------- | ------------- | ----------------------- | --------------------------------------------- |
| GadgetFilename          | yes           | no                      | yes                                           |
| GadgetFilenameWithData  | yes           | yes                     | yes                                           |
| GadgetOnlyData          | no            | yes                     | yes                                           |

Types take the snapshot name, and optionally the subfind name as positional arguments for construction (if not provided, the subfind name is inferred from the snapshot name). `selection_function` and `select_particle_types` are passed as keyword arguments.


### Readig snapshot / subfind data

#### Snapshots

Read data with `get_snap_data`. Internally, this function uses `GadgetIO.read_block`.

Velocities can be corrected to internal code units from the output code units in the snapshot (multiplying with `atime^(3/2)`) by adding a "C" at the end of the fieldname (e.g. `"VELC"`, `"VRMSC"`).

The data is then limited to the selction. To this end, the selection function is evaluated if necessary, results can be reused by saving a field `("SELECTION",parttype)` to the `snap_data` for types that contain this field. The data is then returned as `Array`. 

For reading particles in a box, use `get_snap_data_in_box`, internally based on `GadgetIO.read_particles_in_box`.

If the information should be stored in the `snap_data` Dict, use the modifying reading function `get_snap_data!`/`get_snap_data_in_box!`.

The header can be obtained using `get_snap_header`/`get_snap_header!` based on `GadgetIO.read_header`.

#### Subfind

Read subfind data with `get_sub_data`. Internally, this function uses `GadgetIO.read_subfind`.

This function automatically checks for alternative naming conventions in subfind (e.g. `"R200"` vs `"RMEA"`, `"MTOP"` vs `"MVIR"`, etc).

If the information should be stored in the `sub_data` Dict, use the modifying reading function `get_sub_data!`.


### Checking data

To check for data in the `snap_data` Dict use `has_snap_data`. To check if data is available either in the `snap_data`, or directly in the snapshot, use `has_snap_block`.

The same can be done for subfind data with `has_sub_data`, `has_sub_block`.


### Adding additional data

New data can be added to the `snap_data` Dict using `set_snap_data`.

In the same way, new data can be added to the `sub_data` Dict using `set_sub_data`.


### Removing data

To cleanup the `snap_data`/`sub_data` dictionaries, data can eb deleted using `remove_snap_data!`/`remove_sub_data!`. They return `true` if data has indeed been deleted, and `false` otherwise (e.g. no `snap_data`/`sub_data` Dict present at all or data not present).


### Helper functions

To check the way how snapshot/subfind data is stored, this package introduces some helper functions:

`has_key_files` checks if key files are present for more efficient reading. This function is used to detect automatically if keyfiles can be used in the reading functions.

`get_number_of_snaps` returns the number of sub snapshot files. Returns 1 if the snapshot is stored in a single file.

From a snapshot, the simulation directory can be inferred using `get_simulation_path`. The snapshot number can be inferred using `get_snapshot_number_from_name`.


## Units

This package defines two datatypes (structs) that contain relevant conversions between internal code units and physical units.

`GadgetUnits` contains conversion factors from code units to cgs.

`HubbleFactors` contains conversion factors from units including the Hubble parameter (e.g. kpc/h) to units without such a factor (e.g. kpc).


## Diagnostic files

Gadget outputs several diagnostic files with useful information in plain text format. They can be read with the following functions:

`read_cpu_file` extracts timer information from the CPU file, stored in a Vector (entry per timestep) of Dict (storing all timer information).
`cpu_value_evolution` can extract timer information from the `Vector{Dict}` for a specific key into `Vector{Float64}` format for better analysis.

`read_sfr.txt` returns the content of the sfr.txt file into Dict of Vectors with the five columns stored as individual keys.

`read_blackholes_txt` returns the content of blackholes.txt into a Dict of Vectors with the columns stored as individual keys.
`read_bh_details` returns the per-blackhole information stored in blackhole_details/blackhole_details_*.txt. At the moment, only `"ENERGY"` and `"BHGROWTH"` type lines are read, others are omitted.


## Simulations

This part of the package is still preliminary and needs further work to be fully functional.


### Data types

To deal with simulations with several snapshots more easily, this package introduces several datatypes of AbstractType `GadgetSimulation` to hold information of the whole simulation, similarly to the snapshot types:

`GadgetSimulationDir`, `GadgetSimulationDirWithData`.


### Getting snapshots

The last snapshot of the simulation can be obtained using `get_last_snapshot`/`get_last_snapnumber`.
The largest snapshot within a specified limit can be obtained using `largest_snapnum`.

A specific snapshot with desired `i_snap` can be returned using `get_snapshot`.
