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
    read_bh_details(directory::String="blackhole_details/";
                    output_every::Int64=typemax(Int64))

Return a `Dict` containing all information from the blackhole_details files, sorted by particle ID, then by information type, then individual arrays per relevant information.
"""
function read_bh_details(directory::String="blackhole_details/";
                         output_every::Int64=typemax(Int64))

    files = filter(f -> startswith(basename(f), "blackhole_details_") && endswith(f, ".txt"),
                   readdir(directory; join=true))

    bh_data = Dict{Int, Dict{String, Any}}()

    lines = 0
    for file in files
        open(file, "r") do f
            for line in eachline(f)
                if isempty(line)
                    continue
                end
                lines += 1

                fields = split(line,(' ',':'))
                if fields[1] == "ENERGY"
                    # feedback energy
                    id = parse(Int64, fields[3][6:end])
                    bh = get!(bh_data, id) do
                        Dict{String, Any}()
                    end
                    entry = get!(bh, "ENERGY") do
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
                    id = parse(Int64, fields[3][6:end])
                    bh = get!(bh_data, id) do
                        Dict{String, Any}()
                    end
                    entry = get!(bh, "BHGROWTH") do
                        (pos = Vector{NTuple{3, Float64}}(),
                         time = Float64[],
                         mass = Float64[],
                         rho = Float64[],
                         mdot_cold = Float64[],
                         rho_cold = Float64[],
                         csnd_cold = Float64[],
                         bhvel_cold = Float64[],
                         mdot_hot = Float64[],
                         rho_hot = Float64[],
                         csnd_hot = Float64[],
                         bhvel_hot = Float64[],
                         mdot_edd = Float64[],
                         eps_tot_feed = Float64[],
                         eps_tot = Float64[],
                         dt = Float64[],
                         mdot = Float64[],
                         mass_now = Float64[],
                         )
                    end
                    push!(entry.pos,        (Parsers.parse(Float64, fields[4][2:end]),
                                             Parsers.parse(Float64, fields[5]),
                                             Parsers.parse(Float64, fields[6][1:end-1])))
                    push!(entry.time,        Parsers.parse(Float64, fields[7][6:end]))
                    push!(entry.mass,        Parsers.parse(Float64, fields[8][5:end]))
                    push!(entry.rho,         Parsers.parse(Float64, fields[10][5:end]))

                    push!(entry.mdot_cold,   Parsers.parse(Float64, fields[14][6:end]))
                    push!(entry.rho_cold,    Parsers.parse(Float64, fields[15][5:end]))
                    push!(entry.csnd_cold,   Parsers.parse(Float64, fields[16][6:end]))
                    push!(entry.bhvel_cold,  Parsers.parse(Float64, fields[17][7:end]))

                    push!(entry.mdot_hot,    Parsers.parse(Float64, fields[22][6:end]))
                    push!(entry.rho_hot,     Parsers.parse(Float64, fields[23][5:end]))
                    push!(entry.csnd_hot,    Parsers.parse(Float64, fields[24][6:end]))
                    push!(entry.bhvel_hot,   Parsers.parse(Float64, fields[25][7:end]))

                    push!(entry.mdot_edd,    Parsers.parse(Float64, fields[27][9:end]))
                    push!(entry.eps_tot_feed,Parsers.parse(Float64, fields[28][12:end]))
                    push!(entry.eps_tot,     Parsers.parse(Float64, fields[29][8:end]))
                    push!(entry.dt,          Parsers.parse(Float64, fields[30][4:end]))
                    push!(entry.mdot,        Parsers.parse(Float64, fields[31][6:end]))
                    push!(entry.mass_now,    Parsers.parse(Float64, fields[32][6:end]))
                elseif fields[1] == "SWALLOW"
                    # gas particles accreted, todo
                elseif fields[1] == "FRICTION"
                    # computation of dynamical friction, todo
                elseif fields[1] == "BHSEED"
                    # BH seeding, todo
                elseif startswith(fields[1],"ThisTask")
                    #mergers, todo
                end
                # todo: remove those lines
                if lines%output_every == 0
                    println(lines)
                end
            end
        end
    end

    return bh_data

end
