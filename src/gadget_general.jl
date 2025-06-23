"""
    snap2sub(snap::String)

Return the corresponding sub (groups file) name for given `snap` (snapshot file) name.
"""
function snap2sub(snap::String)
    sub = replace(replace(snap,"snapdir"=>"groups"),"snap"=>"sub")
end
