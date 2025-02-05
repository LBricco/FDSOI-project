# 2D MOSFET UTBB FDSOI (n type, 60 nm technology, conventional well process)
# ----------------------------------------------------
math coord.ucs

# Declare initial grid (half structure)
# ----------------------------------------------------
line x location= 0.0      spacing= 10.0<nm>  tag= SiTop        
line x location= 20.0<nm> spacing= 20.0<nm>                                         
line x location= 0.2<um>  spacing= 100.0<nm>  tag= SiBottom   
line y location= 0.0      spacing= 20<nm> tag= Mid         
line y location= 0.15<um> spacing=20<nm>  tag= Right 

# Silicon substrate definition
# ----------------------------------------------------
region Silicon xlo= SiTop xhi= SiBottom ylo= Mid yhi= Right

# Initialize the simulation
# ----------------------------------------------------
init concentration= 1.0e+15<cm-3> field= Boron !DelayFullD
AdvancedCalibration 
struct tdr=n@node@_01_FDSOI_substrate0; # p-type Si substrate

# SOI wafer preparation (BOX + p-type Si overlay)
# Alert: this is only an approximation of the real procedure! (typically smart-cut)
# ----------------------------------------------------
deposit material= {Oxide} type= isotropic thickness=0.065
struct tdr=n@node@_02_FDSOI_box; # buried oxide deposition

deposit material = {Silicon} type= isotropic thickness=0.016 fields.values= {Boron= 5e18}
struct tdr=n@node@_03_FDSOI_soi; # silicon overlay deposition

# Global mesh settings for automatic meshing in newly generated layers
# ----------------------------------------------------
grid set.min.normal.size= 1.0<nm> set.normal.growth.ratio.2d= 1.5
mgoals accuracy = 1e-5

# Dummy gate deposition (60 nm channel length)
# ----------------------------------------------------
deposit material= {PolySilicon} type= anisotropic time= 1 rate= {0.065}
struct tdr= n@node@_04_FDSOI_gate_dep;

# Poly gate pattern/etch 
# anisotropic etching, poly thickness (65 nm) + tolerance (2 nm) to avoid residuals
# mask only half-channel length to reduce simulation time
# ----------------------------------------------------
mask name= gate_mask left=-1 right= 30<nm> 
etch material= {PolySilicon} type= anisotropic time= 1 rate= {0.067} \
	mask = gate_mask
struct tdr= n@node@_05_FDSOI_gate_poly_etch;

# Poly reoxidation
# ----------------------------------------------------
diffuse temperature= 850<C> time= 0.5<min> O2
struct tdr= n@node@_06_FDSOI_poly_reox;

# LDD implantation and diffusion
# ----------------------------------------------------
refinebox Silicon min= {-0.081 0.025} max= {-0.065 0.04} \
	xrefine= {0.003 0.005} \
	yrefine= {0.002} add
grid remesh

implant Arsenic dose= 4e13<cm-2> energy= 0.01<keV> tilt= 0 rotation= 0
struct tdr= n@node@_07_FDSOI_LDD_implant;

diffuse temperature= 1050<C> time= 0.1<s>
struct tdr= n@node@_08_FDSOI_LDD_diffuse;

# Nitride spacers
# ----------------------------------------------------
deposit material= {Nitride} type= isotropic time= 1 rate= {0.02}
struct tdr= n@node@_09_FDSOI_spacer_dep;

etch material= {Nitride} type= anisotropic time = 1 rate= {0.022} \
	isotropic.overetch= 0.01
struct tdr= n@node@_10_FDSOI_spacer_etch;

etch material= {Oxide} type= anisotropic time= 1 rate= {0.002}
struct tdr= n@node@_11_FDSOI_spacer_ox_removal;

# Source/drain implantation
# ----------------------------------------------------
refinebox Silicon min= {-0.076 0.05} max= {-0.065 0.15} \
	xrefine= {0.003 0.005} \
	yrefine= {0.002} add
grid remesh

implant Arsenic dose= 7e13<cm-2> energy= 2<keV> \
        tilt= 7<degree> rotation= -90<degree>
struct tdr= n@node@_12_FDSOI_SD_implant;

# Final RTA
# ----------------------------------------------------
diffuse temperature= 1050<C> time= 5.0<s>
struct tdr= n@node@_13_FDSOI_SD_diffuse;

# RMG
# ----------------------------------------------------
mask name= gate_mask2 left=-1 right= 30<nm> negative
etch material= {PolySilicon} type= anisotropic time= 1 rate= {0.067} \
  mask = gate_mask2
struct tdr= n@node@_14_FDSOI_dummy_gate_etch;
deposit material= {Oxide} type= polygon polygon= {-0.081 0 -0.081 0.03 -0.082 0.03 -0.082 0}
struct tdr= n@node@_15_FDSOI_SiO2_deposition;

deposit material= {HfO2} type= polygon polygon= {-0.082 0 -0.082 0.03 -0.085 0.03 -0.085 0}
struct tdr= n@node@_16_FDSOI_HfO2_deposition;

deposit material= {Tungsten} type= polygon polygon= {-0.085 0 -0.085 0.03 -0.146 0.03 -0.146 0}
struct tdr= n@node@_17_FDSOI_rmg_deposition;

# Contacts
# ----------------------------------------------------
deposit material= {Aluminum} type= isotropic thickness= 0.009
struct tdr= n@node@_18_FDSOI_Al_dep; # Aluminium deposition

mask name= contacts_mask left= 0.09<um> right= 1.0<um>
etch material= {Aluminum} type= anisotropic thickness= 0.01 \
     mask= contacts_mask 
struct tdr= n@node@_19_FDSOI_Al_anisotropic_etch; # Aluminum anisotropic etching  

etch material= {Aluminum} type= isotropic thickness= 0.01 \
     mask= contacts_mask
struct tdr= n@node@_20_FDSOI_Al_isotropic_etch; # Aluminum isotropic etching  

deposit material= {Aluminum} type= anisotropic thickness= 0.009 \
     mask= gate_mask2 
struct tdr= n@node@_21_FDSOI_gate_contact; # gate contact creation

# Reflect
# ----------------------------------------------------
transform reflect left 
struct tdr= n@node@_22_FDSOI_reflect; # Final structure

# Remeshing
# ----------------------------------------------------
refinebox clear
refinebox clear.interface.mats
refinebox !keep.lines
line clear
pdbSet Grid SnMesh DelaunayType boxmethod

refinebox Silicon min= {-0.081 -0.04} max= {-0.065 -0.025} \
	xrefine= {0.003 0.005} \
	yrefine= {0.002}
refinebox Silicon min= {-0.076 -0.15} max= {-0.065 -0.05} \
	xrefine= {0.003 0.005} \
	yrefine= {0.002}
refinebox Silicon min= {-0.081 0.025} max= {-0.065 0.04} \
	xrefine= {0.003 0.005} \
	yrefine= {0.002}
refinebox Silicon min= {-0.076 0.05} max= {-0.065 0.15} \
	xrefine= {0.003 0.005} \
	yrefine= {0.002}
refinebox Silicon min= {-0.076 -0.02} max= {-0.065 0.02} \
	xrefine= {0.005 0.005} \
	yrefine= {0.005}
grid remesh

# Contacts
# ----------------------------------------------------
contact bottom name = substrate Silicon
contact name = gate x = -0.152 y = 0.0 Aluminum
contact name = source x = -0.085 y = -0.12 Aluminum
contact name = drain x = -0.085 y = 0.1 Aluminum
struct tdr= n@node@_23_FDSOI_presimulation
exit