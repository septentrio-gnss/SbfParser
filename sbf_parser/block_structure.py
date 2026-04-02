# Contains block description according to sepentrio reference
# Initial code by Jashandeep Sohi (2013, jashandeep.s.sohi@gmail.com)
# adapted by Marco Job (2019, marco.job@bluewin.ch)
# Update Meven Jeanne-Rose 2023
# Update Louis-Max Harter 2025


BLOCKNUMBERS = [
    4027, 4000, 4109,
    4110, 4111, 4112,
    4113, 5922, 4017,
    4018, 4019, 4026,
    4022, 4023, 4024,
    4020, 4021, 4047,
    4218, 4219, 4242,
    4066, 4067, 4068,
    4093, 5891, 5892,
    5893, 5894, 4042,
    4004, 4005, 4036,
    4002, 4003, 4030,
    4031, 4032, 4034,
    4081, 4119, 4120,
    4121, 4095, 4116,
    5925, 5926, 5927,
    5928, 5929, 5896,
    5930, 5918, 5897,
    5931, 5932, 5933,
    5917, 5934, 4006,
    4007, 5905, 5906,
    5907, 5908, 4001,
    4044, 4052, 4094,
    4043, 4028, 4076,
    4079, 5921, 5938,
    5939, 5943, 5914,
    5911, 5924, 4037,
    4038, 4217, 4237,
    5919, 5949, 4049,
    4201, 4204, 4211,
    4212, 4214, 4013,
    4014, 4012, 4090,
    4091, 4053, 4122,
    4058, 4105, 4082,
    4059, 4092, 4238,
    4243, 4245, 5902,
    4103, 4015, 5936,
    4040, 4075, 4097,
    4106, 4107, 4086,
]

BLOCKNAMES = [
    'MeasEpoch',            'MeasExtra',     'Meas3Ranges',
    'Meas3CN0HiRes',         'Meas3Doppler',          'Meas3PP',
    'Meas3MP',            'EndOfMeas',             'GPSRawCA',
    'GPSRawL2C',               'GPSRawL5',           'GLORawCA',
    'GALRawFNAV',             'GALRawINAV',          'GALRawCNAV',
    'GEORawL1',           'GEORawL5',         'BDSRaw',
    'BDSRawB1C',               'BDSRawB2a',         'BDSRawB2b',
    'QZSRawL1CA',             'QZSRawL2C',             'QZSRawL5',
    'NAVICRaw',               'GPSNav',             'GPSAlm',
    'GPSIon',               'GPSUtc',            'GPSCNav',
    'GLONav',               'GLOAlm',             'GLOTime',
    'GALNav',            'GALAlm',          'GALIon',
    'GALUtc',           'GALGstGps',        'GALSARRLM',
    'BDSNav',      'BDSAlm',             'BDSIon',
    'BDSUtc',       'QZSNav',             'QZSAlm',
    'GEOMT00',       'GEOPRNMask',       'GEOFastCorr',
    'GEOIntegrity', 'GEOFastCorrDegr',       'GEONav',
    'GEODegrFactors',  'GEONetworkTime',       'GEOAlm',
    'GEOIGPMask',      'GEOLongTermCorr',     'GEOIonoDelay',
    'GEOServiceLevel',       'GEOClockEphCovMatrix',    'PVTCartesian',
    'PVTGeodetic',               'PosCovCartesian',            'PosCovGeodetic',
    'VelCovCartesian',      'VelCovGeodetic',  'DOP',
    'PosCart',       'PosLocal',     'PosProjected',
    'BaseVectorCart',             'BaseVectorGeod',          'PVTSupport',
    'PVTSupportA',        'EndOfPVT',      'AttEuler',
    'AttCovEuler',        'EndOfAtt',        'ReceiverTime',
    'xPPSOffset',          'ExtEvent',           'ExtEventPVTCartesian',
    'ExtEventPVTGeodetic',             'ExtEventBaseVectGeod',    'ExtEventAttEuler',
    'DiffCorrIn',           'BaseStation',           'RTCMDatum',
    'LBandTrackerStatus',  'LBandBeams',         'FugroDDS',
    'LBandRaw',   'FugroStatus', 'ChannelStatus',
    'ReceiverStatus',        'SatVisibility',    'InputLink',
    'OutputLink',       'NTRIPClientStatus',     'NTRIPServerStatus',
    'IPStatus',    'DynDNSStatus',      'QualityInd',
    'DiskStatus',           'RFStatus',           'P2PPStatus',
    'CosmosStatus',             'GALAuthStatus',            'ReceiverSetup',
    'RxMessage', 'Commands', 'Comment',
    'BBSamples', 'ASCIIIn', 'EncapsulatedOutput',
    'GISAction', 'GISStatus', 'ISMR',
]

MeasEpoch = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('N1', 'u1'),
    ('SB1Length', 'u1'),
    ('SB2Length', 'u1'),
    ('CommonFlags', 'u1'),
    ('CumClkJumps', 'u1'),
    ('Reserved', 'u1'),
)

MeasEpoch_Type_1 = (
    ('RxChannel', 'u1'),
    ('Type', 'u1'),
    ('SVID', 'u1'),
    ('Misc', 'u1'),
    ('CodeLSB', 'u4'),
    ('Doppler', 'i4'),
    ('CarrierLSB', 'u2'),
    ('CarrierMSB', 'i1'),
    ('CN0', 'u1'),
    ('LockTime', 'u2'),
    ('ObsInfo', 'u1'),
    ('N2', 'u1'),
)

MeasEpoch_Type_2 = (
    ('Type', 'u1'),
    ('LockTime', 'u1'),
    ('CN0', 'u1'),
    ('OffsetMSB', 'u1'),
    ('CarrierMSB', 'i1'),
    ('ObsInfo', 'u1'),
    ('CodeOffsetLSB', 'u2'),
    ('CarrierLSB', 'u2'),
    ('DopplerOffsetLSB', 'u2'),
)

MeasExtra = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('N', 'u1'),
    ('SBLength', 'u1'),
    ('DopplerVarFactor', 'f4'),
)

MeasExtraChannelSub = (
    ('RxChannel', 'u1'),
    ('Type', 'u1'),
    ('MPCorrection ', 'i2'),
    ('SmoothingCorr', 'i2'),
    ('CodeVar', 'u2'),
    ('CarrierVar', 'u2'),
    ('LockTime', 'u2'),
    ('CumLossCont', 'u1'),
    ('CarMPCorr', 'i1'),
    ('Info', 'u1'),
    ('Misc', 'u1')
)

EndOfMeas = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
)

GPSRawCA = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('CRCPassed', 'u1'),
    ('ViterbiCount', 'u1'),
    ('Source', 'u1'),
    ('FreqNr', 'u1'),
    ('RxChannel', 'u1'),
    ('NAVBits', 'u4[10]'),
)

GPSRawL2C = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('CRCPassed', 'u1'),
    ('ViterbiCount', 'u1'),
    ('Source', 'u1'),
    ('FreqNr', 'u1'),
    ('RxChannel', 'u1'),
    ('NAVBits', 'u4[10]'),
)

GPSRawL5 = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('CRCPassed', 'u1'),
    ('ViterbiCount', 'u1'),
    ('Source', 'u1'),
    ('FreqNr', 'u1'),
    ('RxChannel', 'u1'),
    ('NAVBits', 'u4[10]'),
)

GLORawCA = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('CRCPassed', 'u1'),
    ('ViterbiCount', 'u1'),
    ('Source', 'u1'),
    ('FreqNr', 'u1'),
    ('RxChannel', 'u1'),
    ('NAVBits', 'u4[3]'),
)

GALRawFNAV = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('CRCPassed', 'u1'),
    ('ViterbiCount', 'u1'),
    ('Source', 'u1'),
    ('FreqNr', 'u1'),
    ('RxChannel', 'u1'),
    ('NAVBits', 'u4[8]'),
)

GALRawINAV = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('CRCPassed', 'u1'),
    ('ViterbiCount', 'u1'),
    ('Source', 'u1'),
    ('FreqNr', 'u1'),
    ('RxChannel', 'u1'),
    ('NAVBits', 'u4[8]'),
)

GALRawCNAV = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('CRCPassed', 'u1'),
    ('ViterbiCount', 'u1'),
    ('Source', 'u1'),
    ('FreqNr', 'u1'),
    ('RxChannel', 'u1'),
    ('NAVBits', 'u4[16]'),
)

GEORawL1 = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('CRCPassed', 'u1'),
    ('ViterbiCount', 'u1'),
    ('Source', 'u1'),
    ('FreqNr', 'u1'),
    ('RxChannel', 'u1'),
    ('NAVBits', 'u4[8]'),
)

GEORawL5 = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('CRCPassed', 'u1'),
    ('ViterbiCount', 'u1'),
    ('Source', 'u1'),
    ('FreqNr', 'u1'),
    ('RxChannel', 'u1'),
    ('NAVBits', 'u4[8]'),
)

BDSRaw = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('CRCPassed', 'u1'),
    ('ViterbiCnt', 'u1'),
    ('Source', 'u1'),
    ('Reserved', 'u1'),
    ('RxChannel', 'u1'),
    ('NAVBits', 'u4[10]')
)

BDSRawB1C = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('CRCSF2', 'u1'),
    ('CRCSF3', 'u1'),
    ('Source', 'u1'),
    ('Reserved', 'u1'),
    ('RxChannel', 'u1'),
    ('NAVBits', 'u4[57]'),
)

BDSRawB2a = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('CRCPassed', 'u1'),
    ('ViterbiCnt', 'u1'),
    ('Source', 'u1'),
    ('Reserved', 'u1'),
    ('RxChannel', 'u1'),
    ('NAVBits', 'u4[18]'),
)

BDSRawB2b = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('CRCPassed', 'u1'),
    ('Reserved1', 'u1'),
    ('Source', 'u1'),
    ('Reserved2', 'u1'),
    ('RxChannel', 'u1'),
    ('NAVBits', 'u4[31]'),
)

QZSRawL1CA = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('CRCPassed', 'u1'),
    ('Reserved', 'u1'),
    ('Source', 'u1'),
    ('Reserved2', 'u1'),
    ('RxChannel', 'u1'),
    ('NAVBits', 'u4[10]'),
)

QZSRawL2C = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('CRCPassed', 'u1'),
    ('ViterbiCount', 'u1'),
    ('Source', 'u1'),
    ('Reserved', 'u1'),
    ('RxChannel', 'u1'),
    ('NAVBits', 'u4[10]'),
)

QZSRawL5 = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('CRCPassed', 'u1'),
    ('ViterbiCount', 'u1'),
    ('Source', 'u1'),
    ('Reserved', 'u1'),
    ('RxChannel', 'u1'),
    ('NAVBits', 'u4[10]'),
)

NAVICRaw = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('CRCPassed', 'u1'),
    ('ViterbiCount', 'u1'),
    ('Source', 'u1'),
    ('Reserved', 'u1'),
    ('RxChannel', 'u1'),
    ('NAVBits', 'u4[10]'),
)

GPSNav = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
    ('Reserved', 'u1'),
    ('WN', 'u2'),
    ('CAorPonL2', 'u1'),
    ('URA', 'u1'),
    ('health', 'u1'),
    ('L2DataFlag', 'u1'),
    ('IODC', 'u2'),
    ('IODE2', 'u1'),
    ('IODE3', 'u1'),
    ('FitIntFlg', 'u1'),
    ('Reserved2', 'u1'),
    ('T_gd', 'f4'),
    ('t_oc', 'u4'),
    ('a_f2', 'f4'),
    ('a_f1', 'f4'),
    ('a_f0', 'f4'),
    ('C_rs', 'f4'),
    ('DEL_N', 'f4'),
    ('M_0', 'f8'),
    ('C_uc', 'f4'),
    ('e', 'f8'),
    ('C_us', 'f4'),
    ('SQRT_A', 'f8'),
    ('t_oe', 'u4'),
    ('C_ic', 'f4'),
    ('OMEGA_0', 'f8'),
    ('C_is', 'f4'),
    ('i_0', 'f8'),
    ('C_rc', 'f4'),
    ('omega', 'f8'),
    ('OMEGADOT', 'f4'),
    ('IDOT', 'f4'),
    ('WNt_oc', 'u2'),
    ('WNt_oe', 'u2'),
)

GPSAlm = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
    ('Reserved', 'u1'),
    ('e', 'f4'),
    ('t_oa', 'u4'),
    ('delta_i', 'f4'),
    ('OMEGADOT', 'f4'),
    ('SQRT_A', 'f4'),
    ('OMEGA_0', 'f4'),
    ('omega', 'f4'),
    ('M_0', 'f4'),
    ('a_f1', 'f4'),
    ('a_f0', 'f4'),
    ('WN_a', 'u1'),
    ('config', 'u1'),
    ('health8', 'u1'),
    ('health6', 'u1'),
)

GPSIon = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
    ('Reserved', 'u1'),
    ('alpha_0', 'f4'),
    ('alpha_1', 'f4'),
    ('alpha_2', 'f4'),
    ('alpha_3', 'f4'),
    ('beta_0', 'f4'),
    ('beta_1', 'f4'),
    ('beta_2', 'f4'),
    ('beta_3', 'f4'),
)

GPSUtc = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
    ('Reserved', 'u1'),
    ('A_1', 'f4'),
    ('A_0', 'f8'),
    ('t_ot', 'u4'),
    ('WN_t', 'u1'),
    ('DEL_t_LS', 'i1'),
    ('WN_LSF', 'u1'),
    ('DN', 'u1'),
    ('DEL_t_LSF', 'i1'),
)

GPSCNav = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
    ('Flags', 'u1'),
    ('WN', 'u2'),
    ('health', 'u1'),
    ('URA_ED', 'i1'),
    ('t_op', 'u4'),
    ('t_oe', 'u4'),
    ('A', 'f8'),
    ('A_DOT', 'f8'),
    ('DELTA_N', 'f4'),
    ('DELTA_N_DOT', 'f4'),
    ('M_0', 'f8'),
    ('e', 'f8'),
    ('omega', 'f8'),
    ('OMEGA_0', 'f8'),
    ('OMEGADOT', 'f8'),
    ('i_0', 'f8'),
    ('IDOT', 'f4'),
    ('C_is', 'f4'),
    ('C_ic', 'f4'),
    ('C_rs', 'f4'),
    ('C_rc', 'f4'),
    ('C_us', 'f4'),
    ('C_uc', 'f4'),
    ('t_oc', 'u4'),
    ('URA_NED0', 'i1'),
    ('URA_NED1', 'i1'),
    ('URA_NED2', 'i1'),
    ('WN_op', 'u1'),
    ('a_f2', 'f4'),
    ('a_f1', 'f4'),
    ('a_f0', 'f8'),
    ('T_gd', 'f4'),
    ('ISC_L1CA', 'f4'),
    ('ISC_L2C', 'f4'),
    ('ISC_L5I5', 'f4'),
    ('ISC_L5Q5', 'f4'),
)

GLONav = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('FreqNr', 'u1'),
    ('X', 'f8'),
    ('Y', 'f8'),
    ('Z', 'f8'),
    ('Dx', 'f4'),
    ('Dy', 'f4'),
    ('Dz', 'f4'),
    ('Ddx', 'f4'),
    ('Ddy', 'f4'),
    ('Ddz', 'f4'),
    ('gamma', 'f4'),
    ('tau', 'f4'),
    ('dtau', 'f4'),
    ('t_oe', 'u4'),
    ('WN_toe', 'u2'),
    ('P1', 'u1'),
    ('P2', 'u1'),
    ('E', 'u1'),
    ('B', 'u1'),
    ('tb', 'u2'),
    ('M', 'u1'),
    ('P', 'u1'),
    ('l', 'u1'),
    ('P4', 'u1'),
    ('N_T', 'u2'),
    ('F_T', 'u2'),
    ('C', 'u1'),
)

GLOAlm = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('FreqNr', 'u1'),
    ('epsilon', 'f4'),
    ('t_oa', 'u4'),
    ('Delta_i', 'f4'),
    ('Lambda', 'f4'),
    ('t_ln', 'f4'),
    ('omega', 'f4'),
    ('Delta_T', 'f4'),
    ('dDelta_T', 'f4'),
    ('tau', 'f4'),
    ('WN_a', 'u1'),
    ('C', 'u1'),
    ('N', 'u2'),
    ('M', 'u1'),
    ('N_4', 'u1'),
)

GLOTime = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('FreqNr', 'u1'),
    ('N_4', 'u1'),
    ('KP', 'u1'),
    ('N', 'u2'),
    ('tau_GPS', 'f4'),
    ('tau_c', 'f8'),
    ('B1', 'f4'),
    ('B2', 'f4'),
)

GALNav = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('Source', 'u1'),
    ('SQRT_A', 'f8'),
    ('M_0', 'f8'),
    ('e', 'f8'),
    ('i_0', 'f8'),
    ('omega', 'f8'),
    ('OMEGA_0', 'f8'),
    ('OMEGADOT', 'f4'),
    ('IDOT', 'f4'),
    ('DEL_N', 'f4'),
    ('C_uc', 'f4'),
    ('C_us', 'f4'),
    ('C_rc', 'f4'),
    ('C_rs', 'f4'),
    ('C_ic', 'f4'),
    ('C_is', 'f4'),
    ('t_oe', 'u4'),
    ('t_oc', 'u4'),
    ('a_f2', 'f4'),
    ('a_f1', 'f4'),
    ('a_f0', 'f8'),
    ('WNt_oe', 'u2'),
    ('WNt_oc', 'u2'),
    ('IODnav', 'u2'),
    ('Health_OSSOL', 'u2'),
    ('Health_PRS', 'u1'),
    ('SISA_L1E5a', 'u1'),
    ('SISA_L1E5b', 'u1'),
    ('SISA_L1AE6A', 'u1'),
    ('BGD_L1E5a', 'f4'),
    ('BGD_L1E5b', 'f4'),
    ('BGD_L1AE6A', 'f4'),
    ('CNAVenc', 'u1'),
)

GALAlm = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('Source', 'u1'),
    ('e', 'f4'),
    ('t_oa', 'u4'),
    ('delta_i', 'f4'),
    ('OMEGADOT', 'f4'),
    ('SQRT_A', 'f4'),
    ('OMEGA_0', 'f4'),
    ('omega', 'f4'),
    ('M_0', 'f4'),
    ('a_f1', 'f4'),
    ('a_f0', 'f4'),
    ('WN_a', 'u1'),
    ('SVID_A', 'u1'),
    ('health', 'u2'),
    ('IODa', 'u1'),
)

GALIon = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('Source', 'u1'),
    ('a_i0', 'f4'),
    ('a_i1', 'f4'),
    ('a_i2', 'f4'),
    ('StormFlags', 'u1'),
)

GALUtc = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('Source', 'u1'),
    ('A_1', 'f4'),
    ('A_0', 'f8'),
    ('t_ot', 'u4'),
    ('WN_ot', 'u1'),
    ('DEL_t_LS', 'i1'),
    ('WN_LSF', 'u1'),
    ('DN', 'u1'),
    ('DEL_t_LSF', 'i1'),
)

GALGstGps = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SVID', 'u1'),
    ('Source', 'u1'),
    ('A_1G', 'f4'),
    ('A_0G', 'f4'),
    ('t_oG', 'u4'),
    ('WN_oG', 'u1'),
)

BDSNav = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
    ('Reserved', 'u1'),
    ('WN', 'u2'),
    ('URA', 'u1'),
    ('SatH1', 'u1'),
    ('IODC', 'u1'),
    ('IODE', 'u1'),
    ('Reserved2', 'u2'),
    ('T_GD1', 'f4'),
    ('T_GD2', 'f4'),
    ('t_oc', 'u4'),
    ('a_f2', 'f4'),
    ('a_f1', 'f4'),
    ('a_f0', 'f4'),
    ('C_rs', 'f4'),
    ('DEL_N', 'f4'),
    ('M_0', 'f8'),
    ('C_uc', 'f4'),
    ('e', 'f8'),
    ('C_us', 'f4'),
    ('SQRT_A', 'f8'),
    ('t_oe', 'u4'),
    ('C_ic', 'f4'),
    ('OMEGA_0', 'f8'),
    ('C_is', 'f4'),
    ('i_0', 'f8'),
    ('C_rc', 'f4'),
    ('omega', 'f8'),
    ('OMEGADOT', 'f4'),
    ('IDOT', 'f4'),
    ('WNt_oc', 'u2'),
    ('WNt_oe', 'u2'),
)

BDSAlm = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
    ('WN_a', 'u1'),
    ('t_oa', 'u4'),
    ('SQRT_A', 'f4'),
    ('e', 'f4'),
    ('omega', 'f4'),
    ('M_0', 'f4'),
    ('OMEGA_0', 'f4'),
    ('OMEGADOT', 'f4'),
    ('delta_i', 'f4'),
    ('a_f0', 'f4'),
    ('a_f1', 'f4'),
    ('Health', 'u2'),
    ('Reserved', 'u1[2]'),
)

BDSIon = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
    ('Reserved', 'u1'),
    ('alpha_0', 'f4'),
    ('alpha_1', 'f4'),
    ('alpha_2', 'f4'),
    ('alpha_3', 'f4'),
    ('beta_0', 'f4'),
    ('beta_1', 'f4'),
    ('beta_2', 'f4'),
    ('beta_3', 'f4'),
)

BDSUtc = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
    ('Reserved', 'u1'),
    ('A_1', 'f4'),
    ('A_0', 'f8'),
    ('DEL_t_LS', 'i1'),
    ('WN_LSF', 'u1'),
    ('DN', 'u1'),
    ('DEL_t_LSF', 'i1'),
)

QZSNav = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
    ('Reserved', 'u1'),
    ('WN', 'u2'),
    ('CAorPonL2', 'u1'),
    ('URA', 'u1'),
    ('health', 'u1'),
    ('L2DataFlag', 'u1'),
    ('IODC', 'u2'),
    ('IODE2', 'u1'),
    ('IODE3', 'u1'),
    ('FitIntFlg', 'u1'),
    ('Reserved2', 'u1'),
    ('T_gd', 'f4'),
    ('t_oc', 'u4'),
    ('a_f2', 'f4'),
    ('a_f1', 'f4'),
    ('a_f0', 'f4'),
    ('C_rs', 'f4'),
    ('DEL_N', 'f4'),
    ('M_0', 'f8'),
    ('C_uc', 'f4'),
    ('e', 'f8'),
    ('C_us', 'f4'),
    ('SQRT_A', 'f8'),
    ('t_oe', 'u4'),
    ('C_ic', 'f4'),
    ('OMEGA_0', 'f8'),
    ('C_is', 'f4'),
    ('i_0', 'f8'),
    ('C_rc', 'f4'),
    ('omega', 'f8'),
    ('OMEGADOT', 'f4'),
    ('IDOT', 'f4'),
    ('WNt_oc', 'u2'),
    ('WNt_oe', 'u2'),
)

QZSAlm = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
    ('Reserved', 'u1'),
    ('e', 'f4'),
    ('t_oa', 'u4'),
    ('delta_i', 'f4'),
    ('OMEGADOT', 'f4'),
    ('SQRT_A', 'f4'),
    ('OMEGA_0', 'f4'),
    ('omega', 'f4'),
    ('M_0', 'f4'),
    ('a_f1', 'f4'),
    ('a_f0', 'f4'),
    ('WN_a', 'u1'),
    ('Reserved2', 'u1'),
    ('health8', 'u1'),
    ('health6', 'u1'),
)

GEOMT00 = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
)

GEOPRNMask = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
    ('IODP', 'u1'),
    ('NbrPRNs', 'u1'),
    ('PRNMask', 'u1[NbrPRNs]'),
)

GEOFastCorr = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
    ('MT', 'u1'),
    ('IODP', 'u1'),
    ('IODF', 'u1'),
    ('N', 'u1'),
    ('SBLength', 'u1'),
)

GEOFastCorr_FastCorr = (
    ('PRNMaskNo', 'u1'),
    ('UDREI', 'u1'),
    ('Reserved', 'u1[2]'),
    ('PRC', 'f4'),
)

GEOIntegrity = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
    ('Reserved', 'u1'),
    ('IODF', 'u1[4]'),
    ('UDREI', 'u1[51]'),
)

GEOFastCorrDegr = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
    ('IODP', 'u1'),
    ('t_lat', 'u1'),
    ('AI', 'u1[51]'),
)

GEONav = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
    ('Reserved', 'u1'),
    ('IODN', 'u2'),
    ('URA', 'u2'),
    ('t0', 'u4'),
    ('Xg', 'f8'),
    ('Yg', 'f8'),
    ('Zg', 'f8'),
    ('Xgd', 'f8'),
    ('Ygd', 'f8'),
    ('Zgd', 'f8'),
    ('Xgdd', 'f8'),
    ('Ygdd', 'f8'),
    ('Zgdd', 'f8'),
    ('AGf0', 'f4'),
    ('AGf1', 'f4'),
)

GEODegrFactors = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
    ('Reserved', 'u1'),
    ('Brrc', 'f8'),
    ('Cltc_lsb', 'f8'),
    ('Cltc_v1', 'f8'),
    ('Iltc_v1', 'u4'),
    ('Cltc_v0', 'f8'),
    ('Iltc_v0', 'u4'),
    ('Cgeo_lsb', 'f8'),
    ('Cgeo_v', 'f8'),
    ('Igeo', 'u4'),
    ('Cer', 'f4'),
    ('Ciono_step', 'f8'),
    ('Iiono', 'u4'),
    ('Ciono_ramp', 'f8'),
    ('RSSudre', 'u1'),
    ('RSSiono', 'u1'),
    ('Reserved2', 'u1[2]'),
    ('Ccovariance', 'f8'),
)


GEONetworkTime = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
    ('Reserved', 'u1'),
    ('A1', 'f4'),
    ('A0', 'f8'),
    ('t_ot', 'u4'),
    ('WN_t', 'u1'),
    ('DEL_t_1S', 'i1'),
    ('WN_LSF', 'u1'),
    ('DN', 'u1'),
    ('DEL_t_LSF', 'i1'),
    ('UTC_std', 'u1'),
    ('GPS_WN', 'u2'),
    ('GPS_TOW', 'u4'),
    ('GLONASSind', 'u1'),
)

GEOAlm = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
    ('Reserved0', 'u1'),
    ('DataID', 'u1'),
    ('Reserved1', 'u1'),
    ('Health', 'u2'),
    ('t_oa', 'u4'),
    ('Xg', 'f8'),
    ('Yg', 'f8'),
    ('Zg', 'f8'),
    ('Xgd', 'f8'),
    ('Ygd', 'f8'),
    ('Zgd', 'f8'),
)


GEOIGPMask = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
    ('NbrBands', 'u1'),
    ('BandNbr', 'u1'),
    ('IODI', 'u1'),
    ('NbrIGPs', 'u1'),
    ('IGPMask', 'u1[NbrIGPs]'),
)


GEOLongTermCorr = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
    ('N', 'u1'),
    ('SBLength', 'u1'),
    ('Reserved', 'u1[3]'),
)

GEOLongTermCorr_LTCorr = (
    ('VelocityCode', 'u1'),
    ('PRNMaskNo', 'u1'),
    ('IODP', 'u1'),
    ('IODE', 'u1'),
    ('dx', 'f4'),
    ('dy', 'f4'),
    ('dz', 'f4'),
    ('dxRate', 'f4'),
    ('dyRate', 'f4'),
    ('dzRate', 'f4'),
    ('da_f0', 'f4'),
    ('da_f1', 'f4'),
    ('t_oe', 'u4'),
)


GEOIonoDelay = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
    ('BandNbr', 'u1'),
    ('IODI', 'u1'),
    ('N', 'u1'),
    ('SBLength', 'u1'),
    ('Reserved', 'u1'),
)

GEOIonoDelay_IDC = (
    ('IGPMaskNo', 'u1'),
    ('GIVEI', 'u1'),
    ('Reserved', 'u1[2]'),
    ('VerticalDelay', 'f4'),
)

GEOServiceLevel = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
    ('Reserved', 'u1'),
    ('IODS', 'u1'),
    ('NrMessages', 'u1'),
    ('MessageNr', 'u1'),
    ('PriorityCode', 'u1'),
    ('dUDREI_In', 'u1'),
    ('dUDREI_Out', 'u1'),
    ('N', 'u1'),
    ('SBLength', 'u1'),
)

GEOServiceLevel_ServiceRegion = (
    ('Latitude1', 'i1'),
    ('Latitude2', 'i1'),
    ('Longitude1', 'i2'),
    ('Longitude2', 'i2'),
    ('RegionShape', 'u1'),
    ('Reserved', 'u1'),
)

GEOClockEphCovMatrix = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('PRN', 'u1'),
    ('IODP', 'u1'),
    ('N', 'u1'),
    ('SBLength', 'u1'),
    ('Reserved', 'u1[2]'),
)

GEOClockEphCovMatrix_CovMatrix = (
    ('PRNMaskNo', 'u1'),
    ('Reserved', 'u1[2]'),
    ('ScaleExp', 'u1'),
    ('E11', 'u2'),
    ('E22', 'u2'),
    ('E33', 'u2'),
    ('E44', 'u2'),
    ('E12', 'i2'),
    ('E13', 'i2'),
    ('E14', 'i2'),
    ('E23', 'i2'),
    ('E24', 'i2'),
    ('E34', 'i2'),
)

PVTCartesian = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('Mode', 'u1'),
    ('Error', 'u1'),
    ('X', 'f8'),
    ('Y', 'f8'),
    ('Z', 'f8'),
    ('Undulation', 'f4'),
    ('Vx', 'f4'),
    ('Vy', 'f4'),
    ('Vz', 'f4'),
    ('COG', 'f4'),
    ('RxClkBias', 'f8'),
    ('RxClkDrift', 'f4'),
    ('TimeSystem', 'u1'),
    ('Datum', 'u1'),
    ('NrSV', 'u1'),
    ('WACorrInfo', 'u1'),
    ('ReferenceID', 'u2'),
    ('MeanCorrAge', 'u2'),
    ('SignalInfo', 'u4'),
    ('AlertFlag', 'u1'),
    ('NrBases', 'u1'),
    ('PPPInfo', 'u2'),
    ('Latency', 'u2'),
    ('HAccuracy', 'u2'),
    ('VAccuracy', 'u2'),
    ('Misc', 'u1'),
)

PVTGeodetic = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('Mode', 'u1'),
    ('Error', 'u1'),
    ('Latitude', 'f8'),
    ('Longitude', 'f8'),
    ('Height', 'f8'),
    ('Undulation', 'f4'),
    ('Vn', 'f4'),
    ('Ve', 'f4'),
    ('Vu', 'f4'),
    ('COG', 'f4'),
    ('RxClkBias', 'f8'),
    ('RxClkDrift', 'f4'),
    ('TimeSystem', 'u1'),
    ('Datum', 'u1'),
    ('NrSV', 'u1'),
    ('WACorrInfo', 'u1'),
    ('ReferenceID', 'u2'),
    ('MeanCorrAge', 'u2'),
    ('SignalInfo', 'u4'),
    ('AlertFlag', 'u1'),
    ('NrBases', 'u1'),
    ('PPPInfo', 'u2'),
    ('Latency', 'u2'),
    ('HAccuracy', 'u2'),
    ('VAccuracy', 'u2'),
    ('Misc', 'u1'),
)

PosCovCartesian = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('Mode', 'u1'),
    ('Error', 'u1'),
    ('Cov_xx', 'f4'),
    ('Cov_yy', 'f4'),
    ('Cov_zz', 'f4'),
    ('Cov_bb', 'f4'),
    ('Cov_xy', 'f4'),
    ('Cov_xz', 'f4'),
    ('Cov_xb', 'f4'),
    ('Cov_yz', 'f4'),
    ('Cov_yb', 'f4'),
    ('Cov_zb', 'f4'),
)

PosCovGeodetic = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('Mode', 'u1'),
    ('Error', 'u1'),
    ('Cov_latlat', 'f4'),
    ('Cov_lonlon', 'f4'),
    ('Cov_hgthgt', 'f4'),
    ('Cov_bb', 'f4'),
    ('Cov_latlon', 'f4'),
    ('Cov_lathgt', 'f4'),
    ('Cov_latb', 'f4'),
    ('Cov_lonhgt', 'f4'),
    ('Cov_lonb', 'f4'),
    ('Cov_hb', 'f4'),
)

VelCovCartesian = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('Mode', 'u1'),
    ('Error', 'u1'),
    ('Cov_VxVx', 'f4'),
    ('Cov_VyVy', 'f4'),
    ('Cov_VzVz', 'f4'),
    ('Cov_DtDt', 'f4'),
    ('Cov_VxVy', 'f4'),
    ('Cov_VxVz', 'f4'),
    ('Cov_VxDt', 'f4'),
    ('Cov_VyVz', 'f4'),
    ('Cov_VyDt', 'f4'),
    ('Cov_VzDt', 'f4'),
)

VelCovGeodetic = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('Mode', 'u1'),
    ('Error', 'u1'),
    ('Cov_VnVn', 'f4'),
    ('Cov_VeVe', 'f4'),
    ('Cov_VuVu', 'f4'),
    ('Cov_DtDt', 'f4'),
    ('Cov_VnVe', 'f4'),
    ('Cov_VnVu', 'f4'),
    ('Cov_VnDt', 'f4'),
    ('Cov_VeVu', 'f4'),
    ('Cov_VeDt', 'f4'),
    ('Cov_VuDt', 'f4'),
)

DOP = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('NrSV', 'u1'),
    ('Reserved', 'u1'),
    ('PDOP', 'u2'),
    ('TDOP', 'u2'),
    ('HDOP', 'u2'),
    ('VDOP', 'u2'),
    ('HPL', 'f4'),
    ('VPL', 'f4'),
)

PosCart = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('Mode', 'u1'),
    ('Error', 'u1'),
    ('X', 'f8'),
    ('Y', 'f8'),
    ('Z', 'f8'),
    ('Base2RoverX', 'f8'),
    ('Base2RoverY', 'f8'),
    ('Base2RoverZ', 'f8'),
    ('Cov_xx', 'f4'),
    ('Cov_yy', 'f4'),
    ('Cov_zz', 'f4'),
    ('Cov_xy', 'f4'),
    ('Cov_xz', 'f4'),
    ('Cov_yz', 'f4'),
    ('PDOP', 'u2'),
    ('HDOP', 'u2'),
    ('VDOP', 'u2'),
    ('Misc', 'u1'),
    ('Reserved', 'u1'),
    ('AlertFlag', 'u1'),
    ('Datum', 'u1'),
    ('NrSV', 'u1'),
    ('WACorrInfo', 'u1'),
    ('ReferenceId', 'u2'),
    ('MeanCorrAge', 'u2'),
    ('SignalInfo', 'u4'),
)

PosLocal = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('Mode', 'u1'),
    ('Error', 'u1'),
    ('Lat', 'f8'),
    ('Lon', 'f8'),
    ('Alt', 'f8'),
    ('Datum', 'u1'),
)

PosProjected = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('Mode', 'u1'),
    ('Error', 'u1'),
    ('Northing', 'f8'),
    ('Easting', 'f8'),
    ('Alt', 'f8'),
    ('Datum', 'u1'),
)

BaseVectorCart = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('N', 'u1'),
    ('SBLength', 'u1'),
)

BaseVectorCart_VectorInfoCart = (
    ('NrSV', 'u1'),
    ('Error', 'u1'),
    ('Mode', 'u1'),
    ('Misc', 'u1'),
    ('DeltaX', 'f8'),
    ('DeltaY', 'f8'),
    ('DeltaZ', 'f8'),
    ('DeltaVx', 'f4'),
    ('DeltaVy', 'f4'),
    ('DeltaVz', 'f4'),
    ('Azimuth', 'u2'),
    ('Elevation', 'i2'),
    ('ReferenceID', 'u2'),
    ('CorrAge', 'u2'),
    ('SignalInfo', 'u4'),
)

BaseVectorGeod = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('N', 'u1'),
    ('SBLength', 'u1'),
)

BaseVectorGeod_VectorInfoGeod = (
    ('NrSV', 'u1'),
    ('Error', 'u1'),
    ('Mode', 'u1'),
    ('Misc', 'u1'),
    ('DeltaEast', 'f8'),
    ('DeltaNorth', 'f8'),
    ('DeltaUp', 'f8'),
    ('DeltaVe', 'f4'),
    ('DeltaVn', 'f4'),
    ('DeltaVu', 'f4'),
    ('Azimuth', 'u2'),
    ('Elevation', 'i2'),
    ('ReferenceID', 'u2'),
    ('CorrAge', 'u2'),
    ('SignalInfo', 'u4'),
)

EndOfPVT = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
)

AttEuler = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('NrSV', 'u1'),
    ('Error', 'u1'),
    ('Mode', 'u2'),
    ('Reserved', 'u2'),
    ('Heading', 'f4'),
    ('Pitch', 'f4'),
    ('Roll', 'f4'),
    ('PitchDot', 'f4'),
    ('RollDot', 'f4'),
    ('HeadingDot', 'f4'),
)

AttCovEuler = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('Reserved', 'u1'),
    ('Error', 'u1'),
    ('Cov_HeadHead', 'f4'),
    ('Cov_PitchPitch', 'f4'),
    ('Cov_RollRoll', 'f4'),
    ('Cov_HeadPitch', 'f4'),
    ('Cov_HeadRoll', 'f4'),
    ('Cov_PitchRoll', 'f4'),
)

EndOfAtt = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
)

ReceiverTime = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('UTCYear', 'i1'),
    ('UTCMonth', 'i1'),
    ('UTCDay', 'i1'),
    ('UTCHour', 'i1'),
    ('UTCMin', 'i1'),
    ('UTCSec', 'i1'),
    ('DeltaLS', 'i1'),
    ('SyncLevel', 'u1'),
)

xPPSOffset = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SyncAge', 'u1'),
    ('Timescale', 'u1'),
    ('Offset', 'f4'),
)

ExtEvent = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('Source', 'u1'),
    ('Polarity', 'u1'),
    ('Offset', 'f4'),
    ('RxClkBias', 'f8'),
    ('PVTAge', 'u2'),
)

ExtEventPVTCartesian = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('Mode', 'u1'),
    ('Error', 'u1'),
    ('X', 'f8'),
    ('Y', 'f8'),
    ('Z', 'f8'),
    ('Undulation', 'f4'),
    ('Vx', 'f4'),
    ('Vy', 'f4'),
    ('Vz', 'f4'),
    ('COG', 'f4'),
    ('RxClkBias', 'f8'),
    ('RxClkDrift', 'f4'),
    ('TimeSystem', 'u1'),
    ('Datum', 'u1'),
    ('NrSV', 'u1'),
    ('WACorrInfo', 'u1'),
    ('ReferenceID', 'u2'),
    ('MeanCorrAge', 'u2'),
    ('SignalInfo', 'u4'),
    ('AlertFlag', 'u1'),
    ('NrBases', 'u1'),
    ('PPPInfo', 'u2'),
    ('Latency', 'u2'),
    ('HAccuracy', 'u2'),
    ('VAccuracy', 'u2'),
    ('Misc', 'u1'),
)

ExtEventPVTGeodetic = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('Mode', 'u1'),
    ('Error', 'u1'),
    ('Latitude', 'f8'),
    ('Longitude', 'f8'),
    ('Height', 'f8'),
    ('Undulation', 'f4'),
    ('Vn', 'f4'),
    ('Ve', 'f4'),
    ('Vu', 'f4'),
    ('COG', 'f4'),
    ('RxClkBias', 'f8'),
    ('RxClkDrift', 'f4'),
    ('TimeSystem', 'u1'),
    ('Datum', 'u1'),
    ('NrSV', 'u1'),
    ('WACorrInfo', 'u1'),
    ('ReferenceID', 'u2'),
    ('MeanCorrAge', 'u2'),
    ('SignalInfo', 'u4'),
    ('AlertFlag', 'u1'),
    ('NrBases', 'u1'),
    ('PPPInfo', 'u2'),
    ('Latency', 'u2'),
    ('HAccuracy', 'u2'),
    ('VAccuracy', 'u2'),
    ('Misc', 'u1'),
)

ExtEventBaseVectGeod = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('N', 'u1'),
    ('SBLength', 'u1'),
)

ExtEventVectorInfoGeod = (
    ('NrSV', 'u1'),
    ('Error', 'u1'),
    ('Mode', 'u1'),
    ('Misc', 'u1'),
    ('DeltaEast', 'f8'),
    ('DeltaNorth', 'f8'),
    ('DeltaUp', 'f8'),
    ('DeltaVe', 'f4'),
    ('DeltaVn', 'f4'),
    ('DeltaVu', 'f4'),
    ('Azimuth', 'u2'),
    ('Elevation', 'i2'),
    ('ReferenceID', 'u2'),
    ('CorrAge', 'u2'),
    ('SignalInfo', 'u4'),
)

ExtEventAttEuler = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('NrSV', 'u1'),
    ('Error', 'u1'),
    ('Mode', 'u2'),
    ('Reserved', 'u2'),
    ('Heading', 'f4'),
    ('Pitch', 'f4'),
    ('Roll', 'f4'),
    ('PitchDot', 'f4'),
    ('RollDot', 'f4'),
    ('HeadingDot', 'f4'),
)

# Need more info on this block.
DiffCorrIn = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('Mode', 'u1'),
    ('Source', 'u1'),
    ('MessageContent', 'c1*'),
)

BaseStation = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('BaseStationID', 'u2'),
    ('BaseType', 'u1'),
    ('Source', 'u1'),
    ('Datum', 'u1'),
    ('Reserved', 'u1'),
    ('X', 'f8'),
    ('Y', 'f8'),
    ('Z', 'f8'),
)

RTCMDatum = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('SourceCRS', 'c1[32]'),
    ('TargetCRS', 'c1[32]'),
    ('Datum', 'u1'),
    ('HeightType', 'u1'),
    ('QualityInd', 'u1'),
)

LBandTrackerStatus = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('N', 'u1'),
    ('SBLength', 'u1'),
)

LBandTrackerStatus_TrackData = (
    ('Frequency', 'u4'),
    ('Baudrate', 'u2'),
    ('ServiceID', 'u2'),
    ('FreqOffset', 'f4'),
    ('CN0', 'u2'),
    ('AvgPower', 'i2'),
    ('AGCGain', 'i1'),
    ('Mode', 'u1'),
    ('Status', 'u1'),
    ('SVID', 'u1'),
    ('LockTime', 'u2'),
    ('Source', 'u2'),
)

LBandBeams = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('N', 'u1'),
    ('SBLength', 'u1'),
)

Beaminfo = (
    ('SVID', 'u1'),
    ('SatName', 'c1[9]'),
    ('SatLongitude', 'i2'),
    ('BeamFreq', 'u4'),
)

LBandRaw = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('N', 'u2'),
    ('Frequency', 'u4'),
    ('UserData', 'u1[N]'),
    ('Channel', 'u1'),
)

FugroStatus = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('Reserved', 'u1[2]'),
    ('Status', 'u4'),
    ('SubStartingTime', 'i4'),
    ('SubExpirationTime', 'i4'),
    ('SubHourGlass', 'i4'),
    ('SubscribedMode', 'u4'),
    ('SubCurrentMode', 'u4'),
    ('SubLinkVector', 'u4'),
    ('CRCGoodCount', 'u4'),
    ('CRCBadCount', 'u4'),
    ('LbandTrackerStatusIdx', 'u2'),
)

ChannelStatus = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('N', 'u1'),
    ('SB1Length', 'u1'),
    ('SB2Length', 'u1'),
    ('Reserved', 'u1[3]'),
)

ChannelStatus_ChannelSatInfo = (
    ('SVID', 'u1'),
    ('FreqNr', 'u1'),
    ('Reserved', 'u2'),
    ('Azimuth_RiseSet', 'u2'),
    ('HealthStatus', 'u2'),
    ('Elevation', 'i1'),
    ('N2', 'u1'),
    ('RxChannel', 'u1'),
    ('Reserved2', 'u1'),
)

ChannelStatus_ChannelStateInfo = (
    ('Antenna', 'u1'),
    ('Reserved', 'u1'),
    ('TrackingStatus', 'u2'),
    ('PVTStatus', 'u2'),
    ('PVTInfo', 'u2'),
)

ReceiverStatus = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('CPULoad', 'u1'),
    ('ExtError', 'u1'),
    ('UpTime', 'u4'),
    ('RxState', 'u4'),
    ('RxError', 'u4'),
    ('N', 'u1'),
    ('SBLength', 'u1'),
    ('CmdCount', 'u1'),
    ('Temperature', 'u1'),
)

ReceiverStatus_AGCState = (
    ('FrontendID', 'u1'),
    ('Gain', 'i1'),
    ('SampleVar', 'u1'),
    ('BlankingStat', 'u1'),
)

SatVisibility = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('N', 'u1'),
    ('SBLength', 'u1'),
)

SatVisibility_SatInfo = (
    ('SVID', 'u1'),
    ('FreqNr', 'u1'),
    ('Azimuth', 'u2'),
    ('Elevation', 'i2'),
    ('RiseSet', 'u1'),
    ('SatelliteInfo', 'u1'),
)

InputLink = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('N', 'u1'),
    ('SBLength', 'u1'),
)

InputLink_InputStats = (
    ('CD', 'u1'),
    ('Type', 'u1'),
    ('AgeOfLastMessage', 'u2'),
    ('NrBytesReceived', 'u4'),
    ('NrBytesAccepted', 'u4'),
    ('NrMsgReceived', 'u4'),
    ('NrMsgAccepted', 'u4'),
)

"""
OutputLink = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('N1', 'u1'),
    ('SB1Length', 'u1'),
    ('SB2Length', 'u1'),
    ('Reserved', 'u1[3]'),
)

OutputLink_OutputStats = (
    ('CD', 'u1'),
    ('N2', 'u1'),
    ('AllowedRate', 'u2'),
    ('NrBytesProduced', 'u4'),
    ('NrBytesSent', 'u4'),
    ('NrClients', 'u1'),
    ('Reserved', 'u1[3]'),
)

OutputLink_OutputType = (
    ('Type', 'u1'),
    ('Percentage', 'u1'),
)
"""

NTRIPClientStatus = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('N', 'u1'),
    ('SBLength', 'u1'),
)

NTRIPClientConnection = (
    ('CDIndex', 'u1'),
    ('Status', 'u1'),
    ('ErrorCode', 'u1'),
    ('Info', 'u1'),
)

NTRIPServerStatus = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('N', 'u1'),
    ('SBLength', 'u1'),
)

NTRIPServerConnection = (
    ('CDIndex', 'u1'),
    ('Status', 'u1'),
    ('ErrorCode', 'u1'),
    ('Info', 'u1'),
)

IPStatus = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('MACAddress', 'u1[6]'),
    ('IPAddress', 'u1[16]'),
    ('Gateway', 'u1[16]'),
    ('Netmask', 'u1'),
    ('Reserved', 'u1[3]'),
    ('HostName', 'c1[33]'),
)

DynDNSStatus = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('Status', 'u1'),
    ('ErrorCode', 'u1'),
    ('IPAddress', 'u1[16]'),
)

QualityInd = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('N', 'u1'),
    ('Reserved', 'u1'),
    ('Indicators', 'u2[N]'),
)

DiskStatus = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('N', 'u1'),
    ('SBLength', 'u1'),
    ('Reserved', 'u1[4]'),
)

DiskData = (
    ('DiskID', 'u1'),
    ('Status', 'u1'),
    ('DiskUsageMSB', 'u2'),
    ('DiskUsageLSB', 'u4'),
    ('DiskSize', 'u4'),
    ('CreateDeleteCount', 'u1'),
    ('Error', 'u1'),
)

RFStatus = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('N', 'u1'),
    ('SBLength', 'u1'),
    ('Flags', 'u1'),
    ('Reserved', 'u1[3]'),
)

RFBand = (
    ('Frequency', 'u4'),
    ('Bandwidth', 'u2'),
    ('Info', 'u1'),
)

P2PPStatus = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('N', 'u1'),
    ('SBLength', 'u1'),
)

P2PPSession = (
    ('SessionID', 'u1'),
    ('Port', 'u1'),
    ('Status', 'u1'),
    ('ErrorCode', 'u1'),
)

CosmosStatus = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('Status', 'u1'),
)

GALAuthStatus = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('OSNMAStatus', 'u2'),
    ('TrustedTimeDelta', 'f4'),
    ('GalActiveMask', 'u8'),
    ('GalAuthenticMask', 'u8'),
    ('GpsActiveMask', 'u8'),
    ('GpsAuthenticMask', 'u8'),
)

ReceiverSetup = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('Reserved', 'u1[2]'),
    ('MarkerName', 'c1[60]'),
    ('MarkerNumber', 'c1[20]'),
    ('Observer', 'c1[20]'),
    ('Agency', 'c1[40]'),
    ('RxSerialNumber', 'c1[20]'),
    ('RxName', 'c1[20]'),
    ('RxVersion', 'c1[20]'),
    ('AntSerialNbr', 'c1[20]'),
    ('AntType', 'c1[20]'),
    ('deltaH', 'f4'),
    ('deltaE', 'f4'),
    ('deltaN', 'f4'),
    ('MarkerType', 'c1[20]'),
    ('GNSSFWVersion', 'c1[40]'),
    ('ProductName', 'c1[40]'),
    ('Latitude', 'f8'),
    ('Longitude', 'f8'),
    ('Height', 'f4'),
    ('StationCode', 'c1[10]'),
    ('MonumentIdx', 'u1'),
    ('ReceiverIdx', 'u1'),
    ('CountryCode', 'c1[3]'),
)

RxMessage = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('Type', 'u1'),
    ('Severity', 'u1'),
    ('MessageID', 'u4'),
    ('StringLn', 'u2'),
    ('Reserved2', 'u1[2]'),
    ('Message', 'c1[StringLn]'),
)

# Need more info for this block
"""
Commands = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('Reserved', 'u1[2]'),
    ('CmdData', 'c1[2048]'),
)
"""

Comment = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('CommentLn', 'u2'),
    ('Comment', 'c1[CommentLn]'),
)

BBSamples = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('N', 'u2'),
    ('Info', 'u1'),
    ('Reserved', 'u1[3]'),
    ('SampleFreq', 'u4'),
    ('LOFreq', 'u4'),
    ('Samples', 'u2[N]'),
)

ASCIIIn = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('CD', 'u1'),
    ('Reserved1', 'u1[3]'),
    ('StringLn', 'u2'),
    ('SensorModel', 'c1[20]'),
    ('SensorType', 'c1[20]'),
    ('Reserved2', 'u1[20]'),
    ('ASCIIString', 'c1[StringLn]'),
)

EncapsulatedOutput = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('Mode', 'u1'),
    ('Reserved', 'u1'),
    ('N', 'u2'),
    ('ReservedId', 'u2'),
    ('Payload', 'u1*'),
)

ISMR = (
    ('TOW', 'u4'),
    ('WNc', 'u2'),
    ('N', 'u1'),
    ('SBLength', 'u1'),
    ('Reserved', 'u1[3]'),
    ('N_MSB', 'u1'),
)

ISMRChannel = (
    ('RXChannel', 'u1'),
    ('Type', 'u1'),
    ('SVID', 'u1'),
    ('Reserved', 'u1'),
    ('S4', 'u2'),
    ('SigmaPhi', 'u2'),
)