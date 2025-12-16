using DelimitedFiles
using Parsers

"""
    read_blackholes_txt(filename::String="blackholes.txt")

Return all information contained in blackholes.txt file as a `Dict`.
"""
function read_blackholes_txt(filename::String="blackholes.txt")

    data = readdlm(filename)

    bh_data = Dict()
    bh_data["time"] = data[:,1] # time (expansion factor)
    bh_data["total_bh"] = data[:,2] # total number of black holes in the simulation
    bh_data["total_bh_mass"] = data[:,3] # total physical mass (internal units), based on P.Mass
    bh_data["total_bh_mdot"] = data[:,4] # total BH mass accretion rate (internal units), based on BPP.BH_Mdot
    bh_data["total_bh_mdot_physical"] = data[:,5] # total BH mass accretion rate (Msun/yr), based on BPP.BH_Mdot
    bh_data["total_bh_dynamical_mass"] = data[:,6] # total BH dynamical mass (internal units), based on BPP.BH_Mass
    bh_data["avg_eddington"] = data[:,7] # average Eddington fraction (Mdot/Mdot_Edd)

    return bh_data
    
end


"""
    read_bh_details(directory::String="blackhole_details/")

Return a `Dict` containing all information from the blackhole_details files, sorted by particle ID, then by information type, then individual arrays per relevant information.
"""
function read_bh_details(directory::String="blackhole_details/")

    files = filter(f -> startswith(basename(f), "blackhole_details_") && endswith(f, ".txt"),
                   readdir(directory; join=true))

    bh_data = Dict{Int, Dict{String, Any}}()

    for file in files
        open(file, "r") do f
            for line in eachline(f)
                if isempty(line)
                    continue
                end

                fields = split(line,(' ',':'))
                if fields[1] == "ENERGY"
                    # feedback energy
                    id = parse(Int64, fields[3][6:end])
                    bh = get!(bh_data, id) do
                        Dict{String, Any}()
                    end
                    entry = get!(bh, "BHGROWTH") do
                        (time = Float64[],
                         mass = Float64[],
                         mdot = Float64[],
                         dt = Float64[],
                         id_gas = Int64[],
                         energy = Float64[],
                         total_energy = Float64[],
                         )
                    end
                    push!(entry.time,         Parsers.parse(Float64, fields[4][6:end]))
                    push!(entry.mass,         Parsers.parse(Float64, fields[6][5:end]))
                    push!(entry.mdot,         Parsers.parse(Float64, fields[7][6:end]))
                    push!(entry.dt,           Parsers.parse(Float64, fields[8][4:end]))
                    push!(entry.id_gas,       Parsers.parse(Int64,   fields[10][7:end]))
                    push!(entry.energy,       Parsers.parse(Float64, fields[12]))
                    push!(entry.total_energy, Parsers.parse(Float64, fields[14]))
                elseif fields[1] == "BHGROWTH"
                    # accretion rate computation
                    # todo
                elseif fields[1] == "SWALLOW"
                    # gas particles accreted, todo
                elseif fields[1] == "FRICTION"
                    # computation of dynamical friction, todo
                elseif fields[1] == "BHSEED"
                    # BH seeding, todo
                elseif startswith(fields[1],"ThisTask")
                    #mergers, todo
                end
            end
        end
    end

    return bh_data

end
