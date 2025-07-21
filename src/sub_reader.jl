using GadgetIO

"""
    choose_subfind_fieldname(data::GadgetData, fieldname::String)

Return the correct choice of the fieldname, either original value, or alternative name if applicable.
"""
function choose_subfind_fieldname(data::GadgetData, fieldname::String)
    alternative_fieldname = Dict("R200" => "RMEA", "RMEA"=>"R200",
                                 "M200" => "MMEA", "MMEA"=>"M200",
                                 "RTOP" => "RVIR", "RVIR"=>"RTOP",
                                 "MTOP" => "MVIR", "MVIR"=>"MTOP"
                                 )
    if has_sub_block(data, fieldname)
        # the field is present
        return fieldname
    elseif has_sub_block(data, alternative_fieldname[fieldname])
        return alternative_fieldname[fieldname]
    else
        # neither the field, nor the alternative name is present.
        return fieldname
    end
end

# subfind reading functions
"""
    get_sub_data(data::GadgetFilename, fieldname::String)

Read subfind data from `data.sub` with `fieldname`.
"""
function get_sub_data(data::GadgetFilename, fieldname::String)
    read_subfind(data.sub, choose_subfind_fieldname(data, fieldname))
end
"""
    get_sub_data(data::GadgetFilenameWithData, fieldname::String)

Get subfind data from `data.sub_data` if present, otherwise read from `data.sub`.
"""
function get_sub_data(data::GadgetFilenameWithData, fieldname::String)
    this_fieldname = choose_subfind_fieldname(data, fieldname)
    if haskey(data.sub_data,this_fieldname)
        return data.sub_data[this_fieldname]
    else
        return read_subfind(data.sub, this_fieldname)
    end
end
"""
    get_sub_data(data::GadgetOnlyData, fieldname::String)

Get subfind data from `data.sub_data`.
"""
function get_sub_data(data::GadgetOnlyData, fieldname::String)
    return data.sub_data[choose_subfind_fieldname(data, fieldname)]
end

# subfind reading functions to add the data just read
"""
    get_sub_data!(data::GadgetData, fieldname::String)

See `get_sub_data(data::GadgetData, fieldname::String)`
"""
function get_sub_data!(data::GadgetData, fieldname::String)
    return get_sub_data(data, choose_subfind_fieldname(data, fieldname))
end
"""
    get_sub_data(data::GadgetFilenameWithData, fieldname::String

Get subfind data from `data.sub_data` if present, otherwise read from `data.sub` and save in `data.sub_data`.
"""
function get_sub_data!(data::GadgetFilenameWithData, fieldname::String)
    this_fieldname = choose_subfind_fieldname(data, fieldname)
    if haskey(data.sub_data,this_fieldname)
        return data.sub_data[this_fieldname]
    else
        new_sub_data = read_subfind(data.sub, this_fieldname)
        data.sub_data[this_fieldname] = new_sub_data
        return new_sub_data
    end
end
