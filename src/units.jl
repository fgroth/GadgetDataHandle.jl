"""
    GadgetUnits

Type (struct) to hold information on unit system that was used for simulation.

Initialized using `UnitLength_in_cm`, `UnitVelocity_in_cm_per_s`, `UnitMass_in_g`, `UnitMagneticField_in_gauss`. Other factors are calculated from these.
"""
struct GadgetUnits
    # input
    UnitLength_in_cm::Number
    UnitVelocity_in_cm_per_s::Number
    UnitMass_in_g::Number
    UnitMagneticField_in_gauss::Number
    
    # derived quantities
    UnitTime_in_s::Number
    UnitDensity_in_cgs::Number
    UnitPressure_in_cgs::Number
    UnitCoolingRate_in_cgs::Number
    UnitEnergy_in_cgs::Number
    function GadgetUnits(; UnitLength_in_cm::Number = 3.085678e21, # 1 kpc
                         UnitVelocity_in_cm_per_s::Number = 1e5, # 1 km/s
                         UnitMass_in_g::Number = 1.989e43, # 1e10 M_sun
                         UnitMagneticField_in_gauss::Number = 1.0)
        # calculate derived quantities
        UnitTime_in_s = UnitLength_in_cm / UnitVelocity_in_cm_per_s
        UnitDensity_in_cgs = UnitMass_in_g / UnitLength_in_cm^3
        UnitPressure_in_cgs = UnitMass_in_g / UnitLength_in_cm / UnitTime_in_s^2
        UnitCoolingRate_in_cgs = UnitPressure_in_cgs / UnitTime_in_s
        UnitEnergy_in_cgs = UnitMass_in_g * UnitLength_in_cm^2 / UnitTime_in_s^2
        # return the initialized struct
        new(UnitLength_in_cm, UnitVelocity_in_cm_per_s,
            UnitMass_in_g, UnitMagneticField_in_gauss,
            # derived quantities
            UnitTime_in_s, UnitDensity_in_cgs,
            UnitPressure_in_cgs, UnitCoolingRate_in_cgs,
            UnitEnergy_in_cgs)
    end
end

"""
    HubbleFactors

Type (struct) to hold Hubble conversion factors to convert code units to physical units.

Initialized using `HubbleParam`, calculating unit conversion factors.
"""
struct HubbleFactors
    HubbleParam::Number
    # derived quantities
    UnitLength_remove_h0::Number
    UnitVelocity_remove_h0::Number
    UnitMass_remove_h0::Number
    UnitTime_remove_h0::Number
    UnitDensity_remove_h0::Number
    UnitPressure_remove_h0::Number
    UnitCoolingRate_remove_h0::Number
    UnitEnergy_remove_h0::Number
    UnitMagneticField_remove_h0::Number
    function HubbleFactors(HubbleParam::Number)
        # calculate derived quantities
        UnitLength_remove_h0 = 1 / HubbleParam
        UnitVelocity_remove_h0 = 1
        UnitMass_remove_h0 = 1 / HubbleParam
        UnitTime_remove_h0 = UnitLength_remove_h0 / UnitVelocity_remove_h0
        UnitDensity_remove_h0 = UnitMass_remove_h0 / UnitLength_remove_h0^3
        UnitPressure_remove_h0 = UnitMass_remove_h0 / UnitLength_remove_h0 / UnitTime_remove_h0^2
        UnitCoolingRate_remove_h0 = UnitPressure_remove_h0 / UnitTime_remove_h0
        UnitEnergy_remove_h0 = UnitMass_remove_h0 * UnitLength_remove_h0^2 / UnitTime_remove_h0^2
        UnitMagneticField_remove_h0 = 1 / sqrt(UnitTime_remove_h0 * UnitTime_remove_h0 * UnitLength_remove_h0 / UnitMass_remove_h0)
        # return new struct
        new(HubbelParam,
            # derived quantities
            UnitLength_remove_h0,
            UnitVelocity_remove_h0,
            UnitMass_remove_h0,
            UnitTime_remove_h0,
            UnitDensity_remove_h0,
            UnitPressure_remove_h0,
            UnitCoolingRate_remove_h0,
            UnitEnergy_remove_h0,
            UnitMagneticField_remove_h0
            )
    end
end

struct CosmoFactors
    atime::Number
    # derived quantities
    # add in the same way as for the other two structs.

    function CosmoFactors(atime::Number, hubble_a)
        #calculate derived quantities

        # return new struct
        new()
    end
end

## add struct to hold information from all three

# these can be passed to a function and easily tell the unit system that was used. We can then use it to transform to physical units for analysis/ plots.

