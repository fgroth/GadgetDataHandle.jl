using GadgetIO

# subfind reading functions
"""
    get_sub_data(data::GadgetFilename, fieldname::String)

Read subfind data from `data.sub` with `fieldname`.
"""
function get_sub_data(data::GadgetFilename, fieldname::String)
    try
        return read_subfind(data.sub, fieldname)
    catch
        if fieldname == "R200"
            return get_sub_data(data,"RMEA")
        elseif fieldname == "RMEA"
            return get_sub_data(data,"R200")
        elseif fieldname == "M200"
            return get_sub_data(data,"MMEA")
        elseif fieldname == "MMEA"
            return get_sub_data(data,"M200")
        elseif fieldname == "MTOP"
            return get_sub_data(data,"MVIR")
        elseif fieldname == "MVIR"
            return get_sub_data(data,"MTOP")
        elseif fieldname == "RTOP"
            return get_sub_data(data,"RVIR")            
        elseif fieldname == "RVIR"
            return get_sub_data(data,"RTOP")
        else
            error("Block "*fieldname*" not present!")
        end
    end
end
"""
    get_sub_data(data::GadgetFilenameWithData, fieldname::String)

Get subfind data from `data.sub_data` if present, otherwise read from `data.sub`.
"""
function get_sub_data(data::GadgetFilenameWithData, fieldname::String)
    try
        if haskey(data.sub_data,fieldname)
            return data.sub_data[fieldname]
        else
            return read_subfind(data.sub, fieldname)
        end
    catch
        if fieldname == "R200"
            return get_sub_data(data,"RMEA")
        elseif fieldname == "RMEA"
            return get_sub_data(data,"R200")
        elseif fieldname == "M200"
            return get_sub_data(data,"MMEA")
        elseif fieldname == "MMEA"
            return get_sub_data(data,"M200")
        elseif fieldname == "MTOP"
            return get_sub_data(data,"MVIR")
        elseif fieldname == "MVIR"
            return get_sub_data(data,"MTOP")
        elseif fieldname == "RTOP"
            return get_sub_data(data,"RVIR")            
        elseif fieldname == "RVIR"
            return get_sub_data(data,"RTOP")
        else
            error("Block "*fieldname*" not present!")
        end
    end
end
"""
    get_sub_data(data::GadgetOnlyData, fieldname::String)

Get subfind data from `data.sub_data`.
"""
function get_sub_data(data::GadgetOnlyData, fieldname::String)
    try
        return data.sub_data[fieldname]
    catch
        if fieldname == "R200"
            return get_sub_data(data,"RMEA")
        elseif fieldname == "RMEA"
            return get_sub_data(data,"R200")
        elseif fieldname == "M200"
            return get_sub_data(data,"MMEA")
        elseif fieldname == "MMEA"
            return get_sub_data(data,"M200")
        elseif fieldname == "MTOP"
            return get_sub_data(data,"MVIR")
        elseif fieldname == "MVIR"
            return get_sub_data(data,"MTOP")
        elseif fieldname == "RTOP"
            return get_sub_data(data,"RVIR")            
        elseif fieldname == "RVIR"
            return get_sub_data(data,"RTOP")
        else
            error("Block "*fieldname*" not present!")
        end
    end
end

# subfind reading functions to add the data just read
"""
    get_sub_data!(data::GadgetData, fieldname::String)

See `get_sub_data(data::GadgetData, fieldname::String)`
"""
function get_sub_data!(data::GadgetData, fieldname::String)
    try
        return get_sub_data(data, fieldname)
    catch
        if fieldname == "R200"
            return get_sub_data(data,"RMEA")
        elseif fieldname == "RMEA"
            return get_sub_data(data,"R200")
        elseif fieldname == "M200"
            return get_sub_data(data,"MMEA")
        elseif fieldname == "MMEA"
            return get_sub_data(data,"M200")
        elseif fieldname == "MTOP"
            return get_sub_data(data,"MVIR")
        elseif fieldname == "MVIR"
            return get_sub_data(data,"MTOP")
        elseif fieldname == "RTOP"
            return get_sub_data(data,"RVIR")            
        elseif fieldname == "RVIR"
            return get_sub_data(data,"RTOP")
        else
            error("Block "*fieldname*" not present!")
        end
    end
end
"""
    get_sub_data(data::GadgetFilenameWithData, fieldname::String

Get subfind data from `data.sub_data` if present, otherwise read from `data.sub` and save in `data.sub_data`.
"""
function get_sub_data!(data::GadgetFilenameWithData, fieldname::String)
    try
        if haskey(data.sub_data,fieldname)
            return data.sub_data[fieldname]
        else
            new_sub_data = read_subfind(data.sub, fieldname)
            data.sub_data[fieldname] = new_sub_data
            return new_sub_data
        end
    catch
        if fieldname == "R200"
            return get_sub_data(data,"RMEA")
        elseif fieldname == "RMEA"
            return get_sub_data(data,"R200")
        elseif fieldname == "M200"
            return get_sub_data(data,"MMEA")
        elseif fieldname == "MMEA"
            return get_sub_data(data,"M200")
        elseif fieldname == "MTOP"
            return get_sub_data(data,"MVIR")
        elseif fieldname == "MVIR"
            return get_sub_data(data,"MTOP")
        elseif fieldname == "RTOP"
            return get_sub_data(data,"RVIR")            
        elseif fieldname == "RVIR"
            return get_sub_data(data,"RTOP")
        else
            error("Block "*fieldname*" not present!")
        end
    end
end

