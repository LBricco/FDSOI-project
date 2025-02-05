File
{
*INPUT FILES
Grid ="n1_21_FDSOI_presimulation_fps.tdr"
* physical parameters
Parameter = "sdevice.par"

*OUTPUT FILES
Plot = "n@node@_des.tdr"
* electrical characteristics at the electrodes
Current= "n@node@_des.plt"
}

Electrode
{
{ name="source" Voltage=0.0 }
{ name="drain" Voltage=0.0 }
{ name="gate" Voltage=0.0 }
{ name="substrate" Voltage=0.0}
}

Thermode
{
{ Name = "source" Temperature = 300 }
{ Name = "drain" Temperature = 300 }
{ Name = "gate" Temperature = 300 }
{ Name = "substrate" Temperature = 300 }
}

Physics
{
	EffectiveIntrinsicDensity(NoBandGapNarrowing)
	Mobility(DopingDependence,HighFieldSaturation)
	Recombination(SRH)
	Temperature=300
}

Plot
{
	Potential ElectricField/Vector
	eEparallel eEnormal
	hEparallel hEnormal
	eDensity hDensity SpaceCharge
	Affinity IntrinsicDensity
	eCurrent/Vector hCurrent/Vector TotalCurrentDensity/Vector 
	eMobility hMobility eVelocity hVelocity
	Doping DonorConcentration AcceptorConcentration
	DonorPlusConcentration AccepMinusConcentration 
	ConductionBandEnergy ValenceBandEneergy
	eQuasiFermiEnergy hQuasiFermiEnergy
	eAvalancheGeneration hAvalancheGeneration
	BandGap DielectricConstant
}

Math
{
	Extrapolate
	* use full derivatives in Newton method
	Derivatives
	* control on relative errors
	RelErrControl
	* relative error= 10^(-Digits)
	Digits=5
	* maximum number of iteration at each step
	Iterations=100
	ExitOnFailure 
}

Solve
{
############ VDS=2V, VGS sweep 0-2V ##############
	Poisson
	Coupled { Poisson Electron Hole  } 
	Plot(FilePrefix="equil")
	
quasistationary (InitialStep=0.005 MaxStep = 0.1 MinStep=1e-6
Goal {name= "drain" voltage = 2})
{coupled { Poisson  Electron Hole }
CurrentPlot ( Time = (range = (0 2) intervals = 200)) 
Plot(FilePrefix = "IDVD" Time=(2.0))}

quasistationary (InitialStep=0.005 MaxStep = 0.1 MinStep=1e-6
Goal {name= "gate" voltage = 2})
{coupled { Poisson Electron Hole } 
CurrentPlot ( Time = (range = (0 2) intervals = 200)) 
Plot(FilePrefix = "IDVG" Time=(2.0))}

############ VDS=0.2V, VGS sweep 0-2V ##############
	Load(FilePrefix= "equil")

NewCurrentPrefix = "IDVD_VD0d2_"
quasistationary (InitialStep=0.005 MaxStep = 0.1 MinStep=1e-6
Goal {name= "drain" voltage = 0.2})
{coupled { Poisson  Electron Hole }
CurrentPlot ( Time = (range = (0 0.2) intervals = 200)) 
Plot(FilePrefix = "IDVD_VD0d2_" Time=(2.0))}

NewCurrentPrefix = "IDVG_VD0d2_"
quasistationary (InitialStep=0.005 MaxStep = 0.1 MinStep=1e-6
Goal {name= "gate" voltage = 2})
{coupled { Poisson Electron Hole } 
CurrentPlot ( Time = (range = (0 2) intervals = 200)) 
Plot(FilePrefix = "IDVG_VD0d2_" Time=(2.0))}
}
