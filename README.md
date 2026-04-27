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

Types take the snapshot name, and optionally the subfind name as positional arguments for construction. `selection_function` and `select_particle_types` are passed as keyword arguments.
Data can be added in a next step (see sections on reading).

### Readig snapshot / subfind data

#### Snapshots

Read data with `get_snap_data`. Internally, this function uses `GadgetIO.read_block`.

Velocities can be corrected to internal code units from the output code units in the snapshot (multiplying with `atime^(3/2)`) by adding a "C" at the end of the fieldname (e.g. `"VELC"`, `"VRMSC"`).

The data is then limited to the selction. To this end, the selection function is evaluated if necessary, results can be reused by saving a field `("SELECTION",parttype)` to the `snap_data` for types that contain this field. The data is then returned as `Array`. 

If the information should be stored in the `snap_data` Dict, use the modifying reading function `get_snap_data!`.

#### Subfind

Read subfind data with `get_sub_data`. Internally, this function uses `GadgetIO.read_subfind`.

This function automatically checks for alternative naming conventions in subfind (e.g. `"R200"` vs `"RMEA"`, `"MTOP"` vs `"MVIR"`, etc).

If the information should be stored in the `sub_data` Dict, use the modifying reading function `get_sub_data!`.

### Adding additional data

New data can be added to the `snap_data` Dict using `set_snap_data`.

In the same way, new data can be added to the `sub_data` Dict using `set_sub_data`.
