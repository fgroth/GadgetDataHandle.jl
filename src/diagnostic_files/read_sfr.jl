using DelimitedFiles

"""
    read_sfr_txt(filename::String="sfr.txt")

Return all information contained in sfr.txt file as a `Dict`.
"""
function read_sfr_txt(filename::String="sfr.txt")

    data = readdlm(filename)

    sfr_data = Dict()
    sfr_data["time"] = data[:,1] # time (expansion factor)
    sfr_data["total_sm"] = data[:,2] # amount of stars expected to form
    sfr_data["sfr"] = data[:,3] # expected star formation rate
    sfr_data["rate_in_msun_per_year"] = data[:,4] # expected star formation rate in Msun / yr
    sfr_data["total_sum_mass_stars"] = data[:,5] # mass of stars formed in this timestep

    return sfr_data
    
end
