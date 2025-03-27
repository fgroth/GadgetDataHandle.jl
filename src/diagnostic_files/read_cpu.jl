"""
    read_cpu_file(filename::String="cpu.txt")

Extract all timer information from the CPU file.
"""
function read_cpu_file(filename::String="cpu.txt")
    # first get the total number of steps
    last_line=""
    open(filename) do f
        while ! eof(f)
            line = readline(f)
            if occursin("Step ", line)
                last_line = line
            end
        end
    end
    n_steps, = interpret_first_cpu_line(last_line)
    # array of Dict to store data
    cpu = Vector{Dict}(undef, n_steps+1)
    
    open(filename) do f
        # skip the first two (header) lines
        readline(f)
        readline(f)
        # now start to read the relevant content
        while ! eof(f)
            line = readline(f)
            if startswith(line, "Step")
                i_step, time, MPI = interpret_first_cpu_line(line)
                cpu[i_step+1] = Dict() # this is our main Dict
                cpu[i_step+1]["time"] = time
                cpu[i_step+1]["MPI-tasks"] = MPI
            else
                error("Format of the file seems to be broken, timestep header is missing.")
            end
            line = readline(f)
            if startswith(line,"Total wall clock time for Global = ")
                total_wall_clock_time = extract_wall_clock_time_cpu(line)
                cpu[i_step+1]["total_wallclock"] = total_wall_clock_time
            else
                error("Format of the file seems to be broken, wallclock time not present.")
            end
            # extract all individual timers
            read_cpu_step!(f, cpu[i_step+1])
        end
    end
    
    return cpu
end

"""
    interpret_first_cpu_line(line::String)

Extract and return `i_step`, `time`, and `MPI-Tasks` from first `line` of block in cpu.txt
"""
function interpret_first_cpu_line(line::String)
    line_content = split(line)
    i_step = parse(Int64, line_content[2])
    time = parse(Float64, split(split(line_content[4],",")[1],"=")[2])
    MPI_tasks = parse(Int64, line_content[6])
    return i_step, time, MPI_tasks
end

"""
    extract_wall_clock_time_cpu(line::String)

Extract and return the total wallclock time.
"""
function extract_wall_clock_time_cpu(line::String)
    line_content = split(line)
    wallclock = parse(Float64, line_content[8])
end

"""
    read_cpu_step!(f::IOStream, cpu_step::Dict)

Add the timer information of the individual step to the `cpu_step` Dict.
"""
function read_cpu_step!(f::IOStream, cpu_step::Dict)
    line = readline(f)
    key_hierarchy = []
    Dict_hierarchy = []
    append!(Dict_hierarchy,[cpu_step])
    while ! eof(f) || isempty(line)
        if isempty(strip(line))
            break
        end
        key, sec, percent, level = read_cpu_entry(line)
        while level <= length(key_hierarchy)
            pop!(key_hierarchy)
            pop!(Dict_hierarchy)
        end
        if level > length(key_hierarchy)
            append!(key_hierarchy,[key])
            Dict_hierarchy[end][key] = Dict() # create new Dict for each timer within the dictionary if the parent timer.
            append!(Dict_hierarchy,[Dict_hierarchy[end][key]])
        end
        Dict_hierarchy[end]["sec"] = sec
        Dict_hierarchy[end]["percent"] = percent

        line = readline(f)
    end
end

"""
    read_cpu_entry(line::String)

Return `name`, `sec`, `percent`, and `level` from cpu.txt line.
"""
function read_cpu_entry(line::String)
    line_content = split(line)
    level = 1
    while line_content[level] == "-"
        level += 1
    end
    name = line_content[level+1]
    sec = parse(Float64, line_content[level+3])
    percent = parse(Float64, split(line_content[end],'%')[1])
    return name, sec, percent, level
end


# restructure the Vector of Dict to individual data vector.
"""
    cpu_value_evolution(cpu_dict::Vector{Dict}, key::Vector{String})

Convert `values` at `key` into Vector of `Float64` for better analysis.
"""
function cpu_value_evolution(cpu_dict::Vector{Dict}, key::Vector{String})
    values_vector = Vector{Float64}(undef,length(cpu_dict))
    for i_step in 1:length(cpu_dict)
        sub_dict = cpu_dict[i_step]
        for i_level in 1:length(key)
            if haskey(sub_dict, key[i_level])
                sub_dict = sub_dict[key[i_level]]
            else
                # entry is not present. Put a zero instead.
                sub_dict = Dict("sec"=>0)
                break
            end
        end
        values_vector[i_step] = sub_dict["sec"]
    end
    return values_vector
end
