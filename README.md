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

