# Initial code by Jashandeep Sohi (2013, jashandeep.s.sohi@gmail.com)
# adapted by Marco Job (2019, marco.job@bluewin.ch)
# Update Meven Jeanne-Rose 2023

from libc.stdint cimport uint8_t, uint16_t, uint32_t, uint64_t, int8_t, int16_t, int32_t, int64_t
from libc.stdlib cimport free, malloc

ctypedef uint8_t u1
ctypedef uint16_t u2
ctypedef uint32_t u4
ctypedef uint64_t u8

ctypedef int8_t i1
ctypedef int16_t i2
ctypedef int32_t i4
ctypedef int64_t i8

ctypedef float f4
ctypedef double f8

ctypedef char c1

cdef dict BLOCKPARSERS


cdef packed struct MeasEpoch:
    u4 TOW
    u2 WNc
    u1 N1
    u1 SB1Length
    u1 SB2Length
    u1 CommonFlags
    u1 CumClkJumps
    u1 Reserved


cdef packed struct MeasEpoch_Type_1:
    u1 RxChannel
    u1 Type
    u1 SVID
    u1 Misc
    u4 CodeLSB
    i4 Doppler
    u2 CarrierLSB
    i1 CarrierMSB
    u1 CN0
    u2 LockTime
    u1 ObsInfo
    u1 N2


cdef packed struct MeasEpoch_Type_2:
    u1 Type
    u1 LockTime
    u1 CN0
    u1 OffsetMSB
    i1 CarrierMSB
    u1 ObsInfo
    u2 CodeOffsetLSB
    u2 CarrierLSB
    u2 DopplerOffsetLSB


cdef packed struct MeasExtra:
    u4 TOW
    u2 WNc
    u1 N
    u1 SBLength
    f4 DopplerVarFactor


cdef packed struct MeasExtraChannelSub:
    u1 RxChannel
    u1 Type
    i2 MPCorrection
    i2 SmoothingCorr
    u2 CodeVar
    u2 CarrierVar
    u2 LockTime
    u1 CumLossCont
    i1 CarMPCorr
    u1 Info
    u1 Misc


cdef packed struct EndOfMeas:
    u4 TOW
    u2 WNc


cdef packed struct GPSRawCA:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 CRCPassed
    u1 ViterbiCount
    u1 Source
    u1 FreqNr
    u1 RxChannel
    u4[10] NAVBits


cdef packed struct GPSRawL2C:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 CRCPassed
    u1 ViterbiCount
    u1 Source
    u1 FreqNr
    u1 RxChannel
    u4[10] NAVBits


cdef packed struct GPSRawL5:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 CRCPassed
    u1 ViterbiCount
    u1 Source
    u1 FreqNr
    u1 RxChannel
    u4[10] NAVBits


cdef packed struct GLORawCA:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 CRCPassed
    u1 ViterbiCount
    u1 Source
    u1 FreqNr
    u1 RxChannel
    u4[3] NAVBits


cdef packed struct GALRawFNAV:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 CRCPassed
    u1 ViterbiCount
    u1 Source
    u1 FreqNr
    u1 RxChannel
    u4[8] NAVBits


cdef packed struct GALRawINAV:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 CRCPassed
    u1 ViterbiCount
    u1 Source
    u1 FreqNr
    u1 RxChannel
    u4[8] NAVBits


cdef packed struct GALRawCNAV:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 CRCPassed
    u1 ViterbiCount
    u1 Source
    u1 FreqNr
    u1 RxChannel
    u4[16] NAVBits


cdef packed struct GEORawL1:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 CRCPassed
    u1 ViterbiCount
    u1 Source
    u1 FreqNr
    u1 RxChannel
    u4[8] NAVBits


cdef packed struct GEORawL5:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 CRCPassed
    u1 ViterbiCount
    u1 Source
    u1 FreqNr
    u1 RxChannel
    u4[8] NAVBits


cdef packed struct BDSRaw:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 CRCPassed
    u1 ViterbiCnt
    u1 Source
    u1 Reserved
    u1 RxChannel
    u4[10] NAVBits


cdef packed struct BDSRawB1C:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 CRCSF2
    u1 CRCSF3
    u1 Source
    u1 Reserved
    u1 RxChannel
    u4[57] NAVBits


cdef packed struct BDSRawB2a:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 CRCPassed
    u1 ViterbiCnt
    u1 Source
    u1 Reserved
    u1 RxChannel
    u4[18] NAVBits


cdef packed struct BDSRawB2b:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 CRCPassed
    u1 Reserved1
    u1 Source
    u1 Reserved2
    u1 RxChannel
    u4[31] NAVBits


cdef packed struct QZSRawL1CA:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 CRCPassed
    u1 Reserved
    u1 Source
    u1 Reserved2
    u1 RxChannel
    u4[10] NAVBits


cdef packed struct QZSRawL2C:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 CRCPassed
    u1 ViterbiCount
    u1 Source
    u1 Reserved
    u1 RxChannel
    u4[10] NAVBits


cdef packed struct QZSRawL5:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 CRCPassed
    u1 ViterbiCount
    u1 Source
    u1 Reserved
    u1 RxChannel
    u4[10] NAVBits


cdef packed struct NAVICRaw:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 CRCPassed
    u1 ViterbiCount
    u1 Source
    u1 Reserved
    u1 RxChannel
    u4[10] NAVBits


cdef packed struct GPSNav:
    u4 TOW
    u2 WNc
    u1 PRN
    u1 Reserved
    u2 WN
    u1 CAorPonL2
    u1 URA
    u1 health
    u1 L2DataFlag
    u2 IODC
    u1 IODE2
    u1 IODE3
    u1 FitIntFlg
    u1 Reserved2
    f4 T_gd
    u4 t_oc
    f4 a_f2
    f4 a_f1
    f4 a_f0
    f4 C_rs
    f4 DEL_N
    f8 M_0
    f4 C_uc
    f8 e
    f4 C_us
    f8 SQRT_A
    u4 t_oe
    f4 C_ic
    f8 OMEGA_0
    f4 C_is
    f8 i_0
    f4 C_rc
    f8 omega
    f4 OMEGADOT
    f4 IDOT
    u2 WNt_oc
    u2 WNt_oe


cdef packed struct GPSAlm:
    u4 TOW
    u2 WNc
    u1 PRN
    u1 Reserved
    f4 e
    u4 t_oa
    f4 delta_i
    f4 OMEGADOT
    f4 SQRT_A
    f4 OMEGA_0
    f4 omega
    f4 M_0
    f4 a_f1
    f4 a_f0
    u1 WN_a
    u1 config
    u1 health8
    u1 health6


cdef packed struct GPSIon:
    u4 TOW
    u2 WNc
    u1 PRN
    u1 Reserved
    f4 alpha_0
    f4 alpha_1
    f4 alpha_2
    f4 alpha_3
    f4 beta_0
    f4 beta_1
    f4 beta_2
    f4 beta_3


cdef packed struct GPSUtc:
    u4 TOW
    u2 WNc
    u1 PRN
    u1 Reserved
    f4 A_1
    f8 A_0
    u4 t_ot
    u1 WN_t
    i1 DEL_t_LS
    u1 WN_LSF
    u1 DN
    i1 DEL_t_LSF


cdef packed struct GPSCNav:
    u4 TOW
    u2 WNc
    u1 PRN
    u1 Flags
    u2 WN
    u1 health
    i1 URA_ED
    u4 t_op
    u4 t_oe
    f8 A
    f8 A_DOT
    f4 DELTA_N
    f4 DELTA_N_DOT
    f8 M_0
    f8 e
    f8 omega
    f8 OMEGA_0
    f8 OMEGADOT
    f8 i_0
    f4 IDOT
    f4 C_is
    f4 C_ic
    f4 C_rs
    f4 C_rc
    f4 C_us
    f4 C_uc
    u4 t_oc
    i1 URA_NED0
    u1 URA_NED1
    u1 URA_NED2
    u1 WN_op
    f4 a_f2
    f4 a_f1
    f8 a_f0
    f4 T_gd
    f4 ISC_L1CA
    f4 ISC_L2C
    f4 ISC_L5I5
    f4 ISC_L5Q5


cdef packed struct GLONav:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 FreqNr
    f8 X
    f8 Y
    f8 Z
    f4 Dx
    f4 Dy
    f4 Dz
    f4 Ddx
    f4 Ddy
    f4 Ddz
    f4 gamma
    f4 tau
    f4 dtau
    u4 t_oe
    u2 WN_toe
    u1 P1
    u1 P2
    u1 E
    u1 B
    u2 tb
    u1 M
    u1 P
    u1 l
    u1 P4
    u2 N_T
    u2 F_T
    u1 C


cdef packed struct GLOAlm:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 FreqNr
    f4 epsilon
    u4 t_oa
    f4 Delta_i
    f4 Lambda
    f4 t_ln
    f4 omega
    f4 Delta_T
    f4 dDelta_T
    f4 tau
    u1 WN_a
    u1 C
    u2 N
    u1 M
    u1 N_4


cdef packed struct GLOTime:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 FreqNr
    u1 N_4
    u1 KP
    u2 N
    f4 tau_GPS
    f8 tau_c
    f4 B1
    f4 B2


cdef packed struct GALNav:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 Source
    f8 SQRT_A
    f8 M_0
    f8 e
    f8 i_0
    f8 omega
    f8 OMEGA_0
    f4 OMEGADOT
    f4 IDOT
    f4 DEL_N
    f4 C_uc
    f4 C_us
    f4 C_rc
    f4 C_rs
    f4 C_ic
    f4 C_is
    u4 t_oe
    u4 t_oc
    f4 a_f2
    f4 a_f1
    f8 a_f0
    u2 WNt_oe
    u2 WNt_oc
    u2 IODnav
    u2 Health_OSSOL
    u1 Health_PRS
    u1 SISA_L1E5a
    u1 SISA_L1E5b
    u1 SISA_L1AE6A
    f4 BGD_L1E5a
    f4 BGD_L1E5b
    f4 BGD_L1AE6A
    u1 CNAVenc


cdef packed struct GALAlm:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 Source
    f4 e
    u4 t_oa
    f4 delta_i
    f4 OMEGADOT
    f4 SQRT_A
    f4 OMEGA_0
    f4 omega
    f4 M_0
    f4 a_f1
    f4 a_f0
    u1 WN_a
    u1 SVID_A
    u2 health
    u1 IODa


cdef packed struct GALIon:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 Source
    f4 a_i0
    f4 a_i1
    f4 a_i2
    u1 StormFlags


cdef packed struct GALUtc:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 Source
    f4 A_1
    f8 A_0
    u4 t_ot
    u1 WN_ot
    i1 DEL_t_LS
    u1 WN_LSF
    u1 DN
    i1 DEL_t_LSF


cdef packed struct GALGstGps:
    u4 TOW
    u2 WNc
    u1 SVID
    u1 Source
    f4 A_1G
    f4 A_0G
    u4 t_oG
    u1 WN_oG


cdef packed struct BDSNav:
    u4 TOW
    u2 WNc
    u1 PRN
    u1 Reserved
    u2 WN
    u1 URA
    u1 SatH1
    u1 IODC
    u1 IODE
    u2 Reserved2
    f4 T_GD1
    f4 T_GD2
    u4 t_oc
    f4 a_f2
    f4 a_f1
    f4 a_f0
    f4 C_rs
    f4 DEL_N
    f8 M_0
    f4 C_uc
    f8 e
    f4 C_us
    f8 SQRT_A
    u4 t_oe
    f4 C_ic
    f8 OMEGA_0
    f4 C_is
    f8 i_0
    f4 C_rc
    f8 omega
    f4 OMEGADOT
    f4 IDOT
    u2 WNt_oc
    u2 WNt_oe


cdef packed struct BDSAlm:
    u4 TOW
    u2 WNc
    u1 PRN
    u1 WN_a
    u4 t_oa
    f4 SQRT_A
    f4 e
    f4 omega
    f4 M_0
    f4 OMEGA_0
    f4 OMEGADOT
    f4 delta_i
    f4 a_f0
    f4 a_f1
    u2 Health
    u1[2] Reserved


cdef packed struct BDSIon:
    u4 TOW
    u2 WNc
    u1 PRN
    u1 Reserved
    f4 alpha_0
    f4 alpha_1
    f4 alpha_2
    f4 alpha_3
    f4 beta_0
    f4 beta_1
    f4 beta_2
    f4 beta_3


cdef packed struct BDSUtc:
    u4 TOW
    u2 WNc
    u1 PRN
    u1 Reserved
    f4 A_1
    f8 A_0
    i1 DEL_t_LS
    u1 WN_LSF
    u1 DN
    i1 DEL_t_LSF


cdef packed struct QZSNav:
    u4 TOW
    u2 WNc
    u1 PRN
    u1 Reserved
    u2 WN
    u1 CAorPonL2
    u1 URA
    u1 health
    u1 L2DataFlag
    u2 IODC
    u1 IODE2
    u1 IODE3
    u1 FitIntFlg
    u1 Reserved2
    f4 T_gd
    u4 t_oc
    f4 a_f2
    f4 a_f1
    f4 a_f0
    f4 C_rs
    f4 DEL_N
    f8 M_0
    f4 C_uc
    f8 e
    f4 C_us
    f8 SQRT_A
    u4 t_oe
    f4 C_ic
    f8 OMEGA_0
    f4 C_is
    f8 i_0
    f4 C_rc
    f8 omega
    f4 OMEGADOT
    f4 IDOT
    u2 WNt_oc
    u2 WNt_oe


cdef packed struct QZSAlm:
    u4 TOW
    u2 WNc
    u1 PRN
    u1 Reserved
    f4 e
    u4 t_oa
    f4 delta_i
    f4 OMEGADOT
    f4 SQRT_A
    f4 OMEGA_0
    f4 omega
    f4 M_0
    f4 a_f1
    f4 a_f0
    u1 WN_a
    u1 Reserved2
    u1 health8
    u1 health6  


cdef packed struct GEOMT00:
    u4 TOW
    u2 WNc
    u1 PRN


cdef packed struct GEOPRNMask:
    u4 TOW
    u2 WNc
    u1 PRN
    u1 IODP
    u1 NbrPRNs
    u1 * PRNMask


cdef packed struct GEOFastCorr:
    u4 TOW
    u2 WNc
    u1 PRN
    u1 MT
    u1 IODP
    u1 IODF
    u1 N
    u1 SBLength


cdef packed struct GEOFastCorr_FastCorr:
    u1 PRNMaskNo
    u1 UDREI
    u1[2] Reserved
    f4 PRC


cdef packed struct GEOIntegrity:
    u4 TOW
    u2 WNc
    u1 PRN
    u1 Reserved
    u1[4] IODF
    u1[51] UDREI


cdef packed struct GEOFastCorrDegr:
    u4 TOW
    u2 WNc
    u1 PRN
    u1 IODP
    u1 t_lat
    u1[51] AI


cdef packed struct GEONav:
    u4 TOW
    u2 WNc
    u1 PRN
    u1 Reserved
    u2 IODN
    u2 URA
    u4 t0
    f8 Xg
    f8 Yg
    f8 Zg
    f8 Xgd
    f8 Ygd
    f8 Zgd
    f8 Xgdd
    f8 Ygdd
    f8 Zgdd
    f4 AGf0
    f4 AGf1


cdef packed struct GEODegrFactors:
    u4 TOW
    u2 WNc
    u1 PRN
    u1 Reserved
    f8 Brrc
    f8 Cltc_lsb
    f8 Cltc_v1
    u4 Iltc_v1
    f8 Cltc_v0
    u4 Iltc_v0
    f8 Cgeo_lsb
    f8 Cgeo_v
    u4 Igeo
    f4 Cer
    f8 Ciono_step
    u4 Iiono
    f8 Ciono_ramp
    u1 RSSudre
    u1 RSSiono
    u1[2] Reserved2
    f8 Ccovariance


cdef packed struct GEONetworkTime:
    u4 TOW
    u2 WNc
    u1 PRN
    u1 Reserved
    f4 A1
    f8 A0
    u4 t_ot
    u1 WN_t
    i1 DEL_t_1S
    u1 WN_LSF
    u1 DN
    i1 DEL_t_LSF
    u1 UTC_std
    u2 GPS_WN
    u4 GPS_TOW
    u1 GLONASSind


cdef packed struct GEOAlm:
    u4 TOW
    u2 WNc
    u1 PRN
    u1 Reserved0
    u1 DataID
    u1 Reserved1
    u2 Health
    u4 t_oa
    f8 Xg
    f8 Yg
    f8 Zg
    f8 Xgd
    f8 Ygd
    f8 Zgd


cdef packed struct GEOIGPMask:
    u4 TOW
    u2 WNc
    u1 PRN
    u1 NbrBands
    u1 BandNbr
    u1 IODI
    u1 NbrIGPs
    u1 * IGPMask


cdef packed struct GEOLongTermCorr:
    u4 TOW
    u2 WNc
    u1 PRN
    u1 N
    u1 SBLength
    u1[3] Reserved


cdef packed struct GEOLongTermCorr_LTCorr:
    u1 VelocityCode
    u1 PRNMaskNo
    u1 IODP
    u1 IODE
    f4 dx
    f4 dy
    f4 dz
    f4 dxRate
    f4 dyRate
    f4 dzRate
    f4 da_f0
    f4 da_f1
    u4 t_oe


cdef packed struct GEOIonoDelay:
    u4 TOW
    u2 WNc
    u1 PRN
    u1 BandNbr
    u1 IODI
    u1 N
    u1 SBLength
    u1 Reserved


cdef packed struct GEOIonoDelay_IDC:
    u1 IGPMaskNo
    u1 GIVEI
    u1[2] Reserved
    f4 VerticalDelay


cdef packed struct GEOServiceLevel:
    u4 TOW
    u2 WNc
    u1 PRN
    u1 Reserved
    u1 IODS
    u1 NrMessages
    u1 MessageNr
    u1 PriorityCode
    u1 dUDREI_In
    u1 dUDREI_Out
    u1 N
    u1 SBLength


cdef packed struct GEOServiceLevel_ServiceRegion:
    i1 Latitude1
    i1 Latitude2
    i2 Longitude1
    i2 Longitude2
    u1 RegionShape
    u1 Reserved


cdef packed struct GEOClockEphCovMatrix:
    u4 TOW
    u2 WNc
    u1 PRN
    u1 IODP
    u1 N
    u1 SBLength
    u1[2] Reserved


cdef packed struct GEOClockEphCovMatrix_CovMatrix:
    u1 PRNMaskNo
    u1[2] Reserved
    u1 ScaleExp
    u2 E11
    u2 E22
    u2 E33
    u2 E44
    i2 E12
    i2 E13
    i2 E14
    i2 E23
    i2 E24
    i2 E34


cdef packed struct PVTCartesian:
    u4 TOW
    u2 WNc
    u1 Mode
    u1 Error
    f8 X
    f8 Y
    f8 Z
    f4 Undulation
    f4 Vx
    f4 Vy
    f4 Vz
    f4 COG
    f8 RxClkBias
    f4 RxClkDrift
    u1 TimeSystem
    u1 Datum
    u1 NrSV
    u1 WACorrInfo
    u2 ReferenceID
    u2 MeanCorrAge
    u4 SignalInfo
    u1 AlertFlag
    u1 NrBases
    u2 PPPInfo
    u2 Latency
    u2 HAccuracy
    u2 VAccuracy
    u1 Misc

cdef packed struct PVTGeodetic:
    u4 TOW
    u2 WNc
    u1 Mode
    u1 Error
    f8 Latitude
    f8 Longitude
    f8 Height
    f4 Undulation
    f4 Vn
    f4 Ve
    f4 Vu
    f4 COG
    f8 RxClkBias
    f4 RxClkDrift
    u1 TimeSystem
    u1 Datum
    u1 NrSV
    u1 WACorrInfo
    u2 ReferenceID
    u2 MeanCorrAge
    u4 SignalInfo
    u1 AlertFlag
    u1 NrBases
    u2 PPPInfo
    u2 Latency
    u2 HAccuracy
    u2 VAccuracy
    u1 Misc


cdef packed struct PosCovCartesian:
    u4 TOW
    u2 WNc
    u1 Mode
    u1 Error
    f4 Cov_xx
    f4 Cov_yy
    f4 Cov_zz
    f4 Cov_bb
    f4 Cov_xy
    f4 Cov_xz
    f4 Cov_xb
    f4 Cov_yz
    f4 Cov_yb
    f4 Cov_zb


cdef packed struct PosCovGeodetic:
    u4 TOW
    u2 WNc
    u1 Mode
    u1 Error
    f4 Cov_latlat
    f4 Cov_lonlon
    f4 Cov_hgthgt
    f4 Cov_bb
    f4 Cov_latlon
    f4 Cov_lathgt
    f4 Cov_latb
    f4 Cov_lonhgt
    f4 Cov_lonb
    f4 Cov_hb


cdef packed struct VelCovCartesian:
    u4 TOW
    u2 WNc
    u1 Mode
    u1 Error
    f4 Cov_VxVx
    f4 Cov_VyVy
    f4 Cov_VzVz
    f4 Cov_DtDt
    f4 Cov_VxVy
    f4 Cov_VxVz
    f4 Cov_VxDt
    f4 Cov_VyVz
    f4 Cov_VyDt
    f4 Cov_VzDt


cdef packed struct VelCovGeodetic:
    u4 TOW
    u2 WNc
    u1 Mode
    u1 Error
    f4 Cov_VnVn
    f4 Cov_VeVe
    f4 Cov_VuVu
    f4 Cov_DtDt
    f4 Cov_VnVe
    f4 Cov_VnVu
    f4 Cov_VnDt
    f4 Cov_VeVu
    f4 Cov_VeDt
    f4 Cov_VuDt


cdef packed struct DOP:
    u4 TOW
    u2 WNc
    u1 NrSV
    u1 Reserved
    u2 PDOP
    u2 TDOP
    u2 HDOP
    u2 VDOP
    f4 HPL
    f4 VPL


cdef packed struct PosCart:
    u4 TOW
    u2 WNc
    u1 Mode
    u1 Error
    f8 X
    f8 Y
    f8 Z
    f8 Base2RoverX
    f8 Base2RoverY
    f8 Base2RoverZ
    f4 Cov_xx
    f4 Cov_yy
    f4 Cov_zz
    f4 Cov_xy
    f4 Cov_xz
    f4 Cov_yz
    u2 PDOP
    u2 HDOP
    u2 VDOP
    u1 Misc
    u1 Reserved
    u1 AlertFlag
    u1 Datum
    u1 NrSV
    u1 WACorrInfo
    u2 ReferenceId
    u2 MeanCorrAge
    u4 SignalInfo


cdef packed struct PosLocal:
    u4 TOW
    u2 WNc
    u1 Mode
    u1 Error
    f8 Lat
    f8 Lon
    f8 Alt
    u1 Datum


cdef packed struct PosProjected:
    u4 TOW
    u2 WNc
    u1 Mode
    u1 Error
    f8 Northing
    f8 Easting
    f8 Alt
    u1 Datum


cdef packed struct BaseVectorCart:
    u4 TOW
    u2 WNc
    u1 N
    u1 SBLength


cdef packed struct BaseVectorCart_VectorInfoCart:
    u1 NrSV
    u1 Error
    u1 Mode
    u1 Misc
    f8 DeltaX
    f8 DeltaY
    f8 DeltaZ
    f4 DeltaVx
    f4 DeltaVy
    f4 DeltaVz
    u2 Azimuth
    i2 Elevation
    u2 ReferenceID
    u2 CorrAge
    u4 SignalInfo


cdef packed struct BaseVectorGeod:
    u4 TOW
    u2 WNc
    u1 N
    u1 SBLength


cdef packed struct BaseVectorGeod_VectorInfoGeod:
    u1 NrSV
    u1 Error
    u1 Mode
    u1 Misc
    f8 DeltaEast
    f8 DeltaNorth
    f8 DeltaUp
    f4 DeltaVe
    f4 DeltaVn
    f4 DeltaVu
    u2 Azimuth
    i2 Elevation
    u2 ReferenceID
    u2 CorrAge
    u4 SignalInfo


cdef packed struct EndOfPVT:
    u4 TOW
    u2 WNc


cdef packed struct AttEuler:
    u4 TOW
    u2 WNc
    u1 NrSV
    u1 Error
    u2 Mode
    u2 Reserved
    f4 Heading
    f4 Pitch
    f4 Roll
    f4 PitchDot
    f4 RollDot
    f4 HeadingDot


cdef packed struct AttCovEuler:
    u4 TOW
    u2 WNc
    u1 Reserved
    u1 Error
    f4 Cov_HeadHead
    f4 Cov_PitchPitch
    f4 Cov_RollRoll
    f4 Cov_HeadPitch
    f4 Cov_HeadRoll
    f4 Cov_PitchRoll


cdef packed struct EndOfAtt:
    u4 TOW
    u2 WNc


cdef packed struct ReceiverTime:
    u4 TOW
    u2 WNc
    i1 UTCYear
    i1 UTCMonth
    i1 UTCDay
    i1 UTCHour
    i1 UTCMin
    i1 UTCSec
    i1 DeltaLS
    u1 SyncLevel


cdef packed struct xPPSOffset:
    u4 TOW
    u2 WNc
    u1 SyncAge
    u1 Timescale
    f4 Offset


cdef packed struct ExtEvent:
    u4 TOW
    u2 WNc
    u1 Source
    u1 Polarity
    f4 Offset
    f8 RxClkBias
    u2 PVTAge


cdef packed struct ExtEventPVTCartesian:
    u4 TOW
    u2 WNc
    u1 Mode
    u1 Error
    f8 X
    f8 Y
    f8 Z
    f4 Undulation
    f4 Vx
    f4 Vy
    f4 Vz
    f4 COG
    f8 RxClkBias
    f4 RxClkDrift
    u1 TimeSystem
    u1 Datum
    u1 NrSV
    u1 WACorrInfo
    u2 ReferenceID
    u2 MeanCorrAge
    u4 SignalInfo
    u1 AlertFlag
    u1 NrBases
    u2 PPPInfo
    u2 Latency
    u2 HAccuracy
    u2 VAccuracy
    u1 Misc


cdef packed struct ExtEventPVTGeodetic:
    u4 TOW
    u2 WNc
    u1 Mode
    u1 Error
    f8 Latitude
    f8 Longitude
    f8 Height
    f4 Undulation
    f4 Vn
    f4 Ve
    f4 Vu
    f4 COG
    f8 RxClkBias
    f4 RxClkDrift
    u1 TimeSystem
    u1 Datum
    u1 NrSV
    u1 WACorrInfo
    u2 ReferenceID
    u2 MeanCorrAge
    u4 SignalInfo
    u1 AlertFlag
    u1 NrBases
    u2 PPPInfo
    u2 Latency
    u2 HAccuracy
    u2 VAccuracy
    u1 Misc


cdef packed struct ExtEventBaseVectGeod:
    u4 TOW
    u2 WNc
    u1 N
    u1 SBLength


cdef packed struct ExtEventVectorInfoGeod:
    u1 NrSV
    u1 Error
    u1 Mode
    u1 Misc
    f8 DeltaEast
    f8 DeltaNorth
    f8 DeltaUp
    f4 DeltaVe
    f4 DeltaVn
    f4 DeltaVu
    u2 Azimuth
    i2 Elevation
    u2 ReferenceID
    u2 CorrAge
    u4 SignalInfo


cdef packed struct ExtEventAttEuler:
    u4 TOW
    u2 WNc
    u1 NrSV
    u1 Error
    u2 Mode
    u2 Reserved
    f4 Heading
    f4 Pitch
    f4 Roll
    f4 PitchDot
    f4 RollDot
    f4 HeadingDot

cdef packed struct DiffCorrIn:
    u4 TOW
    u2 WNc
    u1 Mode
    u1 Source
    c1 * MessageContent


cdef packed struct BaseStation:
    u4 TOW
    u2 WNc
    u2 BaseStationID
    u1 BaseType
    u1 Source
    u1 Datum
    u1 Reserved
    f8 X
    f8 Y
    f8 Z


cdef packed struct RTCMDatum:
    u4 TOW
    u2 WNc
    c1[32] SourceCRS
    c1[32] TargetCRS
    u1 Datum
    u1 HeightType
    u1 QualityInd


cdef packed struct LBandTrackerStatus:
    u4 TOW
    u2 WNc
    u1 N
    u1 SBLength


cdef packed struct LBandTrackerStatus_TrackData:
    u4 Frequency
    u2 Baudrate
    u2 ServiceID
    f4 FreqOffset
    u2 CN0
    i2 AvgPower
    i1 AGCGain
    u1 Mode
    u1 Status
    u1 SVID
    u2 LockTime
    u2 Source

cdef packed struct LBandBeams:
    u4 TOW
    u2 WNc
    u1 N
    u1 SBLength


cdef packed struct Beaminfo:
    u1 SVID
    c1[9] SatName
    i2 SatLongitude
    u4 BeamFreq


cdef packed struct LBandRaw:
    u4 TOW
    u2 WNc
    u2 N
    u4 Frequency
    u1 * UserData
    u1 Channel


cdef packed struct FugroStatus:
    u4 TOW
    u2 WNc
    u1[2] Reserved
    u4 Status
    i4 SubStartingTime
    i4 SubExpirationTime
    i4 SubHourGlass
    u4 SubscribedMode
    u4 SubCurrentMode
    u4 SubLinkVector
    u4 CRCGoodCount
    u4 CRCBadCount
    u2 LbandTrackerStatusIdx


cdef packed struct ChannelStatus:
    u4 TOW
    u2 WNc
    u1 N
    u1 SB1Length
    u1 SB2Length
    u1[3] Reserved


cdef packed struct ChannelStatus_ChannelSatInfo:
    u1 SVID
    u1 FreqNr
    u2 Reserved
    u2 Azimuth_RiseSet
    u2 HealthStatus
    i1 Elevation
    u1 N2
    u1 RxChannel
    u1 Reserved2


cdef packed struct ChannelStatus_ChannelStateInfo:
    u1 Antenna
    u1 Reserved
    u2 TrackingStatus
    u2 PVTStatus
    u2 PVTInfo


cdef packed struct ReceiverStatus:
    u4 TOW
    u2 WNc
    u1 CPULoad
    u1 ExtError
    u4 UpTime
    u4 RxState
    u4 RxError
    u1 N
    u1 SBLength
    u1 CmdCount
    u1 Temperature


cdef packed struct ReceiverStatus_AGCState:
    u1 FrontendID
    i1 Gain
    u1 SampleVar
    u1 BlankingStat


cdef packed struct SatVisibility:
    u4 TOW
    u2 WNc
    u1 N
    u1 SBLength


cdef packed struct SatVisibility_SatInfo:
    u1 SVID
    u1 FreqNr
    u2 Azimuth
    i2 Elevation
    u1 RiseSet
    u1 SatelliteInfo


cdef packed struct InputLink:
    u4 TOW
    u2 WNc
    u1 N
    u1 SBLength


cdef packed struct InputLink_InputStats:
    u1 CD
    u1 Type
    u2 AgeOfLastMessage
    u4 NrBytesReceived
    u4 NrBytesAccepted
    u4 NrMsgReceived
    u4 NrMsgAccepted


cdef packed struct OutputLink:
    u4 TOW
    u2 WNc
    u1 N1
    u1 SB1Length
    u1 SB2Length
    u1[3] Reserved


cdef packed struct OutputLink_OutputStats:
    u1 CD
    u1 N2
    u2 AllowedRate
    u4 NrBytesProduced
    u4 NrBytesSent
    u1 NrClients
    u1[3] Reserved


cdef packed struct OutputLink_OutputType:
    u1 Type
    u1 Percentage


cdef packed struct NTRIPClientStatus:
    u4 TOW
    u2 WNc
    u1 N
    u1 SBLength


cdef packed struct NTRIPClientConnection:
    u1 CDIndex
    u1 Status
    u1 ErrorCode
    u1 Info


cdef packed struct NTRIPServerStatus:
    u4 TOW
    u2 WNc
    u1 N
    u1 SBLength


cdef packed struct NTRIPServerConnection:
    u1 CDIndex
    u1 Status
    u1 ErrorCode
    u1 Info


cdef packed struct IPStatus:
    u4 TOW
    u2 WNc
    u1[6] MACAddress
    u1[16] IPAddress
    u1[16] Gateway
    u1 Netmask
    u1[3] Reserved
    c1[33] HostName


cdef packed struct DynDNSStatus:
    u4 TOW
    u2 WNc
    u1 Status
    u1 ErrorCode
    u1[16] IPAddress


cdef packed struct QualityInd:
    u4 TOW
    u2 WNc
    u1 N
    u1 Reserved
    u2* Indicators


cdef packed struct DiskStatus:
    u4 TOW
    u2 WNc
    u1 N
    u1 SBLength
    u1[4] Reserved


cdef packed struct DiskData:
    u1 DiskID
    u1 Status
    u2 DiskUsageMSB
    u4 DiskUsageLSB
    u4 DiskSize
    u1 CreateDeleteCount
    u1 Error


cdef packed struct RFStatus:
    u4 TOW
    u2 WNc
    u1 N
    u1 SBLength
    u1 Flags
    u1[3] Reserved


cdef packed struct RFBand:
    u4 Frequency
    u2 Bandwidth
    u1 Info


cdef packed struct P2PPStatus:
    u4 TOW
    u2 WNc
    u1 N
    u1 SBLength


cdef packed struct P2PPSession:
    u1 SessionID
    u1 Port
    u1 Status
    u1 ErrorCode


cdef packed struct CosmosStatus:
    u4 TOW
    u2 WNc
    u1 Status


cdef packed struct GALAuthStatus:
    u4 TOW
    u2 WNc
    u2 OSNMAStatus
    f4 TrustedTimeDelta
    u8 GalActiveMask
    u8 GalAuthenticMask
    u8 GpsActiveMask
    u8 GpsAuthenticMask


cdef packed struct ReceiverSetup:
    u4 TOW
    u2 WNc
    u1[2] Reserved
    c1[60] MarkerName
    c1[20] MarkerNumber
    c1[20] Observer
    c1[40] Agency
    c1[20] RxSerialNumber
    c1[20] RxName
    c1[20] RxVersion
    c1[20] AntSerialNbr
    c1[20] AntType
    f4 deltaH
    f4 deltaE
    f4 deltaN
    c1[20] MarkerType
    c1[40] GNSSFWVersion
    c1[40] ProductName
    f8 Latitude
    f8 Longitude
    f4 Height
    c1[10] StationCode
    u1 MonumentIdx
    u1 ReceiverIdx
    c1[3] CountryCode
    c1[21] Reserved1


cdef packed struct RxMessage:
    u4 TOW
    u2 WNc
    u1 Type
    u1 Severity
    u4 MessageID
    u2 StringLn
    u1[2] Reserved2
    c1 * Message


cdef packed struct Commands:
    u4 TOW
    u2 WNc
    u1[2] Reserved
    c1 * CmdData


cdef packed struct Comment:
    u4 TOW
    u2 WNc
    u2 CommentLn
    c1 * Comment


cdef packed struct BBSamples:
    u4 TOW
    u2 WNc
    u2 N
    u1 Info
    u1[3] Reserved
    u4 SampleFreq
    u4 LOFreq
    u2 * Samples


cdef packed struct ASCIIIn:
    u4 TOW
    u2 WNc
    u1 CD
    u1[3] Reserved1
    u2 StringLn
    c1[20] SensorModel
    c1[20] SensorType
    u1[60] Reserved2
    c1 * ASCIIString


cdef packed struct EncapsulatedOutput:
    u4 TOW
    u2 WNc
    u1 Mode
    u1 Reserved
    u2 N
    u2 ReservedId
    u1 * Payload


cdef packed struct GISAction:
    u4 TOW
    u2 WNc
    u2 CommentLn
    u4 ItemIDMSB
    u4 ItemIDLSB
    u1 Action
    u1 Trigger
    u1 Database
    u1 Reserved
    c1 * Comment



cdef packed struct GISStatus:
    u4 TOW
    u2 WNc
    u1 N
    u1 SBLength


cdef packed struct DatabaseStatus:
    u1 Database
    u1 OnlineStatus
    u1 Error
    u1 Reserved
    u4 NrItems
    u4 NrNotSync

cdef packed struct ISMR:
    u4 TOW
    u2 WNc
    u1 N
    u1 SBLength
    u1[3] Reserved
    u1 N_MSB

cdef packed struct ISMRChannel:
    u1 RXChannel
    u1 Type
    u1 SVID
    u1 Reserved
    u2 S4
    u2 SigmaPhi
