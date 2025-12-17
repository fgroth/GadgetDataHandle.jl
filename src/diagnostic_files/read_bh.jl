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

struct BHEnergyData
    # id_gas is Int64, store separately
    id_gas::Vector{Int64}
    # other 6 vields are packed togetheras Float64 tuple
    data::Vector{NTuple{6, Float64}}
end
struct BHGrowthData
    pos::Vector{NTuple{3, Float64}}
    data::Vector{NTuple{17,Float64}}
end

struct BHData
    energy::Union{Nothing, BHEnergyData}
    growth::Union{Nothing, BHGrowthData}
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

    bh_data = Dict{Int, BHData}()

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
                        BHData(nothing, nothing)
                    end
                    entry = bh.energy
                    if entry == nothing
                        entry = BHEnergyData(Int[64], Vector{NTuple{6, Float64}}())
                        bh_data[id] = BHData(entry, bh.growth)
                    end
                    time=         Parsers.parse(Float64, @view fields[4][6:end])
                    mass=         Parsers.parse(Float64, @view fields[6][5:end])
                    mdot=         Parsers.parse(Float64, @view fields[7][6:end])
                    dt=           Parsers.parse(Float64, @view fields[8][4:end])
                    id_gas=       Parsers.parse(Int64,   @view fields[10][7:end])
                    energy=       Parsers.parse(Float64, fields[12])
                    total_energy= Parsers.parse(Float64, fields[14])

                    push!(entry.id_gas, id_gas)
                    push!(entry.data, (time, mass, mdot, dt, energy, total_energy))
                elseif fields[1] == "BHGROWTH"
                    # accretion rate computation
                    id = parse(Int64, fields[3][6:end])
                    bh = get!(bh_data, id) do
                        BHData(nothing, nothing)
                    end
                    entry = bh.growth
                    if entry == nothing
                        entry = BHGrowthData(Vector{NTuple{3, Float64}}(), Vector{NTuple{17, Float64}}())
                        bh_data[id] = BHData(bh.energy, entry)
                    end
                    push!(entry.pos,        (Parsers.parse(Float64, @view fields[4][2:end]),
                                             Parsers.parse(Float64, fields[5]),
                                             Parsers.parse(Float64, @view fields[6][1:end-1])))
                    time=        Parsers.parse(Float64, @view fields[7][6:end])
                    mass=        Parsers.parse(Float64, @view fields[8][5:end])
                    rho=         Parsers.parse(Float64, @view fields[10][5:end])

                    mdot_cold=   Parsers.parse(Float64, @view fields[14][6:end])
                    rho_cold=    Parsers.parse(Float64, @view fields[15][5:end])
                    csnd_cold=   Parsers.parse(Float64, @view fields[16][6:end])
                    bhvel_cold=  Parsers.parse(Float64, @view fields[17][7:end])

                    mdot_hot=    Parsers.parse(Float64, @view fields[22][6:end])
                    rho_hot=     Parsers.parse(Float64, @view fields[23][5:end])
                    csnd_hot=    Parsers.parse(Float64, @view fields[24][6:end])
                    bhvel_hot=   Parsers.parse(Float64, @view fields[25][7:end])

                    mdot_edd=    Parsers.parse(Float64, @view fields[27][9:end])
                    eps_tot_feed=Parsers.parse(Float64, @view fields[28][12:end])
                    eps_tot=     Parsers.parse(Float64, @view fields[29][8:end])
                    dt=          Parsers.parse(Float64, @view fields[30][4:end])
                    mdot=        Parsers.parse(Float64, @view fields[31][6:end])
                    mass_now=    Parsers.parse(Float64, @view fields[32][6:end])

                    push!(entry.data, (time, mass, rho,
                                       mdot_cold, rho_cold, csnd_cold, bhvel_cold,
                                       mdot_hot, rho_hot, csnd_hot, bhvel_hot,
                                       mdot_edd, eps_tot_feed, eps_tot, dt, mdot, mass_now))
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
