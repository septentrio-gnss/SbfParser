# type: ignore 
# Initial code by Jashandeep Sohi (2013, jashandeep.s.sohi@gmail.com)
# adapted by Marco Job (2019, marco.job@bluewin.ch)
# Update Meven Jeanne-Rose 2023
# Update Louis-Max Harter 2025
# Update Loïc Dubois 2025

from libc.stdint cimport uint8_t, uint16_t, uint32_t, uint64_t, int8_t, int16_t, int32_t, int64_t
from libc.stdlib cimport free, malloc

# Import all type definitions from the .pxd file
from .block_parsers cimport *

cdef dict BLOCKPARSERS = dict()

def unknown_toDict(c1 * data):
    block_dict = dict()
    block_dict['payload'] = data
    return block_dict
BLOCKPARSERS['Unknown'] = unknown_toDict

def MeasEpoch_toDict(c1 * data):
    cdef MeasEpoch * sb0 = <MeasEpoch *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'N1': sb0.N1,
        'SB1Length': sb0.SB1Length,
        'SB2Length': sb0.SB2Length,
        'CommonFlags': sb0.CommonFlags,
        'CumClkJumps': sb0.CumClkJumps,
        'Reserved': sb0.Reserved,
    }

    sub_block_list = []
    cdef MeasEpoch_Type_1 subblock
    cdef size_t i = sizeof(MeasEpoch)
    cdef MeasEpoch_Type_2 subsubblock
    for _ in xrange(sb0.N1):
        subblock = (<MeasEpoch_Type_1*>(data + i))[0]
        i += sb0.SB1Length

        sub_block_dict = {
            'RxChannel': subblock.RxChannel,
            'Type': subblock.Type,
            'SVID': subblock.SVID,
            'Misc': subblock.Misc,
            'CodeLSB': subblock.CodeLSB,
            'Doppler': subblock.Doppler,
            'CarrierLSB': subblock.CarrierLSB,
            'CarrierMSB': subblock.CarrierMSB,
            'CN0': subblock.CN0,
            'LockTime': subblock.LockTime,
            'ObsInfo': subblock.ObsInfo,
            'N2': subblock.N2,
        }
        sub_sub_block_list = []
        for _ in xrange(subblock.N2):
            subsubblock = (<MeasEpoch_Type_2*>(data + i))[0]
            i += sb0.SB2Length

            sub_sub_block_list.append({
                'Type': subsubblock.Type,
                'LockTime': subsubblock.LockTime,
                'CN0': subsubblock.CN0,
                'OffsetMSB': subsubblock.OffsetMSB,
                'CarrierMSB': subsubblock.CarrierMSB,
                'ObsInfo': subsubblock.ObsInfo,
                'CodeOffsetLSB': subsubblock.CodeOffsetLSB,
                'CarrierLSB': subsubblock.CarrierLSB,
                'DopplerOffsetLSB': subsubblock.DopplerOffsetLSB,
            })
        sub_block_dict['Type_2'] = sub_sub_block_list
        sub_block_list.append(sub_block_dict)
    block_dict['Type_1'] = sub_block_list

    return block_dict

BLOCKPARSERS['MeasEpoch'] = MeasEpoch_toDict

def MeasExtra_toDict(c1 * data):
    cdef MeasExtra * sb0 = <MeasExtra *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'N': sb0.N,
        'SBLength': sb0.SBLength,
        'DopplerVarFactor': sb0.DopplerVarFactor,
    }

    sub_block_list = []
    cdef MeasExtraChannelSub subblock
    cdef size_t i = sizeof(MeasExtra)
    for _ in xrange(sb0.N):
        subblock = (<MeasExtraChannelSub*>(data + i))[0]
        i += sb0.SBLength

        sub_block_dict = {
            'RxChannel': subblock.RxChannel,
            'Type': subblock.Type,
            'MPCorrection ': subblock.MPCorrection ,
            'SmoothingCorr': subblock.SmoothingCorr,
            'CodeVar': subblock.CodeVar,
            'CarrierVar': subblock.CarrierVar,
            'LockTime': subblock.LockTime,
            'CumLossCont': subblock.CumLossCont,
            'CarMPCorr': subblock.CarMPCorr,
            'Info': subblock.Info,
            'Misc': subblock.Misc,
        }
        sub_block_list.append(sub_block_dict)
    block_dict['MeasExtraChannel'] = sub_block_list

    return block_dict

BLOCKPARSERS['MeasExtra'] = MeasExtra_toDict

def EndOfMeas_toDict(c1 * data):
    cdef EndOfMeas * sb0 = <EndOfMeas *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
    }

    return block_dict

BLOCKPARSERS['EndOfMeas'] = EndOfMeas_toDict

def GPSRawCA_toDict(c1 * data):
    cdef GPSRawCA * sb0 = <GPSRawCA *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'CRCPassed': sb0.CRCPassed,
        'ViterbiCount': sb0.ViterbiCount,
        'Source': sb0.Source,
        'FreqNr': sb0.FreqNr,
        'RxChannel': sb0.RxChannel,
        'NAVBits': (<c1*>&sb0.NAVBits)[0:40],
    }

    return block_dict

BLOCKPARSERS['GPSRawCA'] = GPSRawCA_toDict

def GPSRawL2C_toDict(c1 * data):
    cdef GPSRawL2C * sb0 = <GPSRawL2C *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'CRCPassed': sb0.CRCPassed,
        'ViterbiCount': sb0.ViterbiCount,
        'Source': sb0.Source,
        'FreqNr': sb0.FreqNr,
        'RxChannel': sb0.RxChannel,
        'NAVBits': (<c1*>&sb0.NAVBits)[0:40],
    }

    return block_dict

BLOCKPARSERS['GPSRawL2C'] = GPSRawL2C_toDict

def GPSRawL5_toDict(c1 * data):
    cdef GPSRawL5 * sb0 = <GPSRawL5 *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'CRCPassed': sb0.CRCPassed,
        'ViterbiCount': sb0.ViterbiCount,
        'Source': sb0.Source,
        'FreqNr': sb0.FreqNr,
        'RxChannel': sb0.RxChannel,
        'NAVBits': (<c1*>&sb0.NAVBits)[0:40],
    }

    return block_dict

BLOCKPARSERS['GPSRawL5'] = GPSRawL5_toDict

def GLORawCA_toDict(c1 * data):
    cdef GLORawCA * sb0 = <GLORawCA *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'CRCPassed': sb0.CRCPassed,
        'ViterbiCount': sb0.ViterbiCount,
        'Source': sb0.Source,
        'FreqNr': sb0.FreqNr,
        'RxChannel': sb0.RxChannel,
        'NAVBits': (<c1*>&sb0.NAVBits)[0:12],
    }

    return block_dict

BLOCKPARSERS['GLORawCA'] = GLORawCA_toDict

def GALRawFNAV_toDict(c1 * data):
    cdef GALRawFNAV * sb0 = <GALRawFNAV *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'CRCPassed': sb0.CRCPassed,
        'ViterbiCount': sb0.ViterbiCount,
        'Source': sb0.Source,
        'FreqNr': sb0.FreqNr,
        'RxChannel': sb0.RxChannel,
        'NAVBits': (<c1*>&sb0.NAVBits)[0:32],
    }

    return block_dict

BLOCKPARSERS['GALRawFNAV'] = GALRawFNAV_toDict

def GALRawINAV_toDict(c1 * data):
    cdef GALRawINAV * sb0 = <GALRawINAV *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'CRCPassed': sb0.CRCPassed,
        'ViterbiCount': sb0.ViterbiCount,
        'Source': sb0.Source,
        'FreqNr': sb0.FreqNr,
        'RxChannel': sb0.RxChannel,
        'NAVBits': (<c1*>&sb0.NAVBits)[0:32],
    }

    return block_dict

BLOCKPARSERS['GALRawINAV'] = GALRawINAV_toDict

def GALRawCNAV_toDict(c1 * data):
    cdef GALRawCNAV * sb0 = <GALRawCNAV *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'CRCPassed': sb0.CRCPassed,
        'ViterbiCount': sb0.ViterbiCount,
        'Source': sb0.Source,
        'FreqNr': sb0.FreqNr,
        'RxChannel': sb0.RxChannel,
        'NAVBits': (<c1*>&sb0.NAVBits)[0:64],
    }

    return block_dict

BLOCKPARSERS['GALRawCNAV'] = GALRawCNAV_toDict

def GEORawL1_toDict(c1 * data):
    cdef GEORawL1 * sb0 = <GEORawL1 *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'CRCPassed': sb0.CRCPassed,
        'ViterbiCount': sb0.ViterbiCount,
        'Source': sb0.Source,
        'FreqNr': sb0.FreqNr,
        'RxChannel': sb0.RxChannel,
        'NAVBits': (<c1*>&sb0.NAVBits)[0:32],
    }

    return block_dict

BLOCKPARSERS['GEORawL1'] = GEORawL1_toDict

def GEORawL5_toDict(c1 * data):
    cdef GEORawL5 * sb0 = <GEORawL5 *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'CRCPassed': sb0.CRCPassed,
        'ViterbiCount': sb0.ViterbiCount,
        'Source': sb0.Source,
        'FreqNr': sb0.FreqNr,
        'RxChannel': sb0.RxChannel,
        'NAVBits': (<c1*>&sb0.NAVBits)[0:32],
    }

    return block_dict

BLOCKPARSERS['GEORawL5'] = GEORawL5_toDict

def BDSRaw_toDict(c1 * data):
    cdef BDSRaw * sb0 = <BDSRaw *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'CRCPassed': sb0.CRCPassed,
        'ViterbiCnt': sb0.ViterbiCnt,
        'Source': sb0.Source,
        'Reserved': sb0.Reserved,
        'RxChannel': sb0.RxChannel,
        'NAVBits': (<c1*>&sb0.NAVBits)[0:40],
    }

    return block_dict

BLOCKPARSERS['BDSRaw'] = BDSRaw_toDict

def BDSRawB1C_toDict(c1 * data):
    cdef BDSRawB1C * sb0 = <BDSRawB1C *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'CRCSF2': sb0.CRCSF2,
        'CRCSF3': sb0.CRCSF3,
        'Source': sb0.Source,
        'Reserved': sb0.Reserved,
        'RxChannel': sb0.RxChannel,
        'NAVBits': (<c1*>&sb0.NAVBits)[0:228],
    }

    return block_dict

BLOCKPARSERS['BDSRawB1C'] = BDSRawB1C_toDict

def BDSRawB2a_toDict(c1 * data):
    cdef BDSRawB2a * sb0 = <BDSRawB2a *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'CRCPassed': sb0.CRCPassed,
        'ViterbiCnt': sb0.ViterbiCnt,
        'Source': sb0.Source,
        'Reserved': sb0.Reserved,
        'RxChannel': sb0.RxChannel,
        'NAVBits': (<c1*>&sb0.NAVBits)[0:72],
    }

    return block_dict

BLOCKPARSERS['BDSRawB2a'] = BDSRawB2a_toDict

def BDSRawB2b_toDict(c1 * data):
    cdef BDSRawB2b * sb0 = <BDSRawB2b *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'CRCPassed': sb0.CRCPassed,
        'Reserved1': sb0.Reserved1,
        'Source': sb0.Source,
        'Reserved2': sb0.Reserved2,
        'RxChannel': sb0.RxChannel,
        'NAVBits': (<c1*>&sb0.NAVBits)[0:124],
    }

    return block_dict

BLOCKPARSERS['BDSRawB2b'] = BDSRawB2b_toDict

def QZSRawL1CA_toDict(c1 * data):
    cdef QZSRawL1CA * sb0 = <QZSRawL1CA *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'CRCPassed': sb0.CRCPassed,
        'Reserved': sb0.Reserved,
        'Source': sb0.Source,
        'Reserved2': sb0.Reserved2,
        'RxChannel': sb0.RxChannel,
        'NAVBits': (<c1*>&sb0.NAVBits)[0:40],
    }

    return block_dict

BLOCKPARSERS['QZSRawL1CA'] = QZSRawL1CA_toDict

def QZSRawL2C_toDict(c1 * data):
    cdef QZSRawL2C * sb0 = <QZSRawL2C *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'CRCPassed': sb0.CRCPassed,
        'ViterbiCount': sb0.ViterbiCount,
        'Source': sb0.Source,
        'Reserved': sb0.Reserved,
        'RxChannel': sb0.RxChannel,
        'NAVBits': (<c1*>&sb0.NAVBits)[0:40],
    }

    return block_dict

BLOCKPARSERS['QZSRawL2C'] = QZSRawL2C_toDict

def QZSRawL5_toDict(c1 * data):
    cdef QZSRawL5 * sb0 = <QZSRawL5 *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'CRCPassed': sb0.CRCPassed,
        'ViterbiCount': sb0.ViterbiCount,
        'Source': sb0.Source,
        'Reserved': sb0.Reserved,
        'RxChannel': sb0.RxChannel,
        'NAVBits': (<c1*>&sb0.NAVBits)[0:40],
    }

    return block_dict

BLOCKPARSERS['QZSRawL5'] = QZSRawL5_toDict

def NAVICRaw_toDict(c1 * data):
    cdef NAVICRaw * sb0 = <NAVICRaw *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'CRCPassed': sb0.CRCPassed,
        'ViterbiCount': sb0.ViterbiCount,
        'Source': sb0.Source,
        'Reserved': sb0.Reserved,
        'RxChannel': sb0.RxChannel,
        'NAVBits': (<c1*>&sb0.NAVBits)[0:40],
    }

    return block_dict

BLOCKPARSERS['NAVICRaw'] = NAVICRaw_toDict

def GPSNav_toDict(c1 * data):
    cdef GPSNav * sb0 = <GPSNav *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
        'Reserved': sb0.Reserved,
        'WN': sb0.WN,
        'CAorPonL2': sb0.CAorPonL2,
        'URA': sb0.URA,
        'health': sb0.health,
        'L2DataFlag': sb0.L2DataFlag,
        'IODC': sb0.IODC,
        'IODE2': sb0.IODE2,
        'IODE3': sb0.IODE3,
        'FitIntFlg': sb0.FitIntFlg,
        'Reserved2': sb0.Reserved2,
        'T_gd': sb0.T_gd,
        't_oc': sb0.t_oc,
        'a_f2': sb0.a_f2,
        'a_f1': sb0.a_f1,
        'a_f0': sb0.a_f0,
        'C_rs': sb0.C_rs,
        'DEL_N': sb0.DEL_N,
        'M_0': sb0.M_0,
        'C_uc': sb0.C_uc,
        'e': sb0.e,
        'C_us': sb0.C_us,
        'SQRT_A': sb0.SQRT_A,
        't_oe': sb0.t_oe,
        'C_ic': sb0.C_ic,
        'OMEGA_0': sb0.OMEGA_0,
        'C_is': sb0.C_is,
        'i_0': sb0.i_0,
        'C_rc': sb0.C_rc,
        'omega': sb0.omega,
        'OMEGADOT': sb0.OMEGADOT,
        'IDOT': sb0.IDOT,
        'WNt_oc': sb0.WNt_oc,
        'WNt_oe': sb0.WNt_oe,
    }

    return block_dict

BLOCKPARSERS['GPSNav'] = GPSNav_toDict

def GPSAlm_toDict(c1 * data):
    cdef GPSAlm * sb0 = <GPSAlm *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
        'Reserved': sb0.Reserved,
        'e': sb0.e,
        't_oa': sb0.t_oa,
        'delta_i': sb0.delta_i,
        'OMEGADOT': sb0.OMEGADOT,
        'SQRT_A': sb0.SQRT_A,
        'OMEGA_0': sb0.OMEGA_0,
        'omega': sb0.omega,
        'M_0': sb0.M_0,
        'a_f1': sb0.a_f1,
        'a_f0': sb0.a_f0,
        'WN_a': sb0.WN_a,
        'config': sb0.config,
        'health8': sb0.health8,
        'health6': sb0.health6,
    }

    return block_dict

BLOCKPARSERS['GPSAlm'] = GPSAlm_toDict

def GPSIon_toDict(c1 * data):
    cdef GPSIon * sb0 = <GPSIon *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
        'Reserved': sb0.Reserved,
        'alpha_0': sb0.alpha_0,
        'alpha_1': sb0.alpha_1,
        'alpha_2': sb0.alpha_2,
        'alpha_3': sb0.alpha_3,
        'beta_0': sb0.beta_0,
        'beta_1': sb0.beta_1,
        'beta_2': sb0.beta_2,
        'beta_3': sb0.beta_3,
    }

    return block_dict

BLOCKPARSERS['GPSIon'] = GPSIon_toDict

def GPSUtc_toDict(c1 * data):
    cdef GPSUtc * sb0 = <GPSUtc *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
        'Reserved': sb0.Reserved,
        'A_1': sb0.A_1,
        'A_0': sb0.A_0,
        't_ot': sb0.t_ot,
        'WN_t': sb0.WN_t,
        'DEL_t_LS': sb0.DEL_t_LS,
        'WN_LSF': sb0.WN_LSF,
        'DN': sb0.DN,
        'DEL_t_LSF': sb0.DEL_t_LSF,
    }

    return block_dict

BLOCKPARSERS['GPSUtc'] = GPSUtc_toDict

def GPSCNav_toDict(c1 * data):
    cdef GPSCNav * sb0 = <GPSCNav *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
        'Flags': sb0.Flags,
        'WN': sb0.WN,
        'health': sb0.health,
        'URA_ED': sb0.URA_ED,
        't_op': sb0.t_op,
        't_oe': sb0.t_oe,
        'A': sb0.A,
        'A_DOT': sb0.A_DOT,
        'DELTA_N': sb0.DELTA_N,
        'DELTA_N_DOT': sb0.DELTA_N_DOT,
        'M_0': sb0.M_0,
        'e': sb0.e,
        'omega': sb0.omega,
        'OMEGA_0': sb0.OMEGA_0,
        'OMEGADOT': sb0.OMEGADOT,
        'i_0': sb0.i_0,
        'IDOT': sb0.IDOT,
        'C_is': sb0.C_is,
        'C_ic': sb0.C_ic,
        'C_rs': sb0.C_rs,
        'C_rc': sb0.C_rc,
        'C_us': sb0.C_us,
        'C_uc': sb0.C_uc,
        't_oc': sb0.t_oc,
        'URA_NED0': sb0.URA_NED0,
        'URA_NED1': sb0.URA_NED1,
        'URA_NED2': sb0.URA_NED2,
        'WN_op': sb0.WN_op,
        'a_f2': sb0.a_f2,
        'a_f1': sb0.a_f1,
        'a_f0': sb0.a_f0,
        'T_gd': sb0.T_gd,
        'ISC_L1CA': sb0.ISC_L1CA,
        'ISC_L2C': sb0.ISC_L2C,
        'ISC_L5I5': sb0.ISC_L5I5,
        'ISC_L5Q5': sb0.ISC_L5Q5,
    }

    return block_dict

BLOCKPARSERS['GPSCNav'] = GPSCNav_toDict

def GLONav_toDict(c1 * data):
    cdef GLONav * sb0 = <GLONav *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'FreqNr': sb0.FreqNr,
        'X': sb0.X,
        'Y': sb0.Y,
        'Z': sb0.Z,
        'Dx': sb0.Dx,
        'Dy': sb0.Dy,
        'Dz': sb0.Dz,
        'Ddx': sb0.Ddx,
        'Ddy': sb0.Ddy,
        'Ddz': sb0.Ddz,
        'gamma': sb0.gamma,
        'tau': sb0.tau,
        'dtau': sb0.dtau,
        't_oe': sb0.t_oe,
        'WN_toe': sb0.WN_toe,
        'P1': sb0.P1,
        'P2': sb0.P2,
        'E': sb0.E,
        'B': sb0.B,
        'tb': sb0.tb,
        'M': sb0.M,
        'P': sb0.P,
        'l': sb0.l,
        'P4': sb0.P4,
        'N_T': sb0.N_T,
        'F_T': sb0.F_T,
        'C': sb0.C,
    }

    return block_dict

BLOCKPARSERS['GLONav'] = GLONav_toDict

def GLOAlm_toDict(c1 * data):
    cdef GLOAlm * sb0 = <GLOAlm *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'FreqNr': sb0.FreqNr,
        'epsilon': sb0.epsilon,
        't_oa': sb0.t_oa,
        'Delta_i': sb0.Delta_i,
        'Lambda': sb0.Lambda,
        't_ln': sb0.t_ln,
        'omega': sb0.omega,
        'Delta_T': sb0.Delta_T,
        'dDelta_T': sb0.dDelta_T,
        'tau': sb0.tau,
        'WN_a': sb0.WN_a,
        'C': sb0.C,
        'N': sb0.N,
        'M': sb0.M,
        'N_4': sb0.N_4,
    }

    return block_dict

BLOCKPARSERS['GLOAlm'] = GLOAlm_toDict

def GLOTime_toDict(c1 * data):
    cdef GLOTime * sb0 = <GLOTime *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'FreqNr': sb0.FreqNr,
        'N_4': sb0.N_4,
        'KP': sb0.KP,
        'N': sb0.N,
        'tau_GPS': sb0.tau_GPS,
        'tau_c': sb0.tau_c,
        'B1': sb0.B1,
        'B2': sb0.B2,
    }

    return block_dict

BLOCKPARSERS['GLOTime'] = GLOTime_toDict

def GALNav_toDict(c1 * data):
    cdef GALNav * sb0 = <GALNav *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'Source': sb0.Source,
        'SQRT_A': sb0.SQRT_A,
        'M_0': sb0.M_0,
        'e': sb0.e,
        'i_0': sb0.i_0,
        'omega': sb0.omega,
        'OMEGA_0': sb0.OMEGA_0,
        'OMEGADOT': sb0.OMEGADOT,
        'IDOT': sb0.IDOT,
        'DEL_N': sb0.DEL_N,
        'C_uc': sb0.C_uc,
        'C_us': sb0.C_us,
        'C_rc': sb0.C_rc,
        'C_rs': sb0.C_rs,
        'C_ic': sb0.C_ic,
        'C_is': sb0.C_is,
        't_oe': sb0.t_oe,
        't_oc': sb0.t_oc,
        'a_f2': sb0.a_f2,
        'a_f1': sb0.a_f1,
        'a_f0': sb0.a_f0,
        'WNt_oe': sb0.WNt_oe,
        'WNt_oc': sb0.WNt_oc,
        'IODnav': sb0.IODnav,
        'Health_OSSOL': sb0.Health_OSSOL,
        'Health_PRS': sb0.Health_PRS,
        'SISA_L1E5a': sb0.SISA_L1E5a,
        'SISA_L1E5b': sb0.SISA_L1E5b,
        'SISA_L1AE6A': sb0.SISA_L1AE6A,
        'BGD_L1E5a': sb0.BGD_L1E5a,
        'BGD_L1E5b': sb0.BGD_L1E5b,
        'BGD_L1AE6A': sb0.BGD_L1AE6A,
        'CNAVenc': sb0.CNAVenc,
    }

    return block_dict

BLOCKPARSERS['GALNav'] = GALNav_toDict

def GALAlm_toDict(c1 * data):
    cdef GALAlm * sb0 = <GALAlm *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'Source': sb0.Source,
        'e': sb0.e,
        't_oa': sb0.t_oa,
        'delta_i': sb0.delta_i,
        'OMEGADOT': sb0.OMEGADOT,
        'SQRT_A': sb0.SQRT_A,
        'OMEGA_0': sb0.OMEGA_0,
        'omega': sb0.omega,
        'M_0': sb0.M_0,
        'a_f1': sb0.a_f1,
        'a_f0': sb0.a_f0,
        'WN_a': sb0.WN_a,
        'SVID_A': sb0.SVID_A,
        'health': sb0.health,
        'IODa': sb0.IODa,
    }

    return block_dict

BLOCKPARSERS['GALAlm'] = GALAlm_toDict

def GALIon_toDict(c1 * data):
    cdef GALIon * sb0 = <GALIon *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'Source': sb0.Source,
        'a_i0': sb0.a_i0,
        'a_i1': sb0.a_i1,
        'a_i2': sb0.a_i2,
        'StormFlags': sb0.StormFlags,
    }

    return block_dict

BLOCKPARSERS['GALIon'] = GALIon_toDict

def GALUtc_toDict(c1 * data):
    cdef GALUtc * sb0 = <GALUtc *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'Source': sb0.Source,
        'A_1': sb0.A_1,
        'A_0': sb0.A_0,
        't_ot': sb0.t_ot,
        'WN_ot': sb0.WN_ot,
        'DEL_t_LS': sb0.DEL_t_LS,
        'WN_LSF': sb0.WN_LSF,
        'DN': sb0.DN,
        'DEL_t_LSF': sb0.DEL_t_LSF,
    }

    return block_dict

BLOCKPARSERS['GALUtc'] = GALUtc_toDict

def GALGstGps_toDict(c1 * data):
    cdef GALGstGps * sb0 = <GALGstGps *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SVID': sb0.SVID,
        'Source': sb0.Source,
        'A_1G': sb0.A_1G,
        'A_0G': sb0.A_0G,
        't_oG': sb0.t_oG,
        'WN_oG': sb0.WN_oG,
    }

    return block_dict

BLOCKPARSERS['GALGstGps'] = GALGstGps_toDict

def BDSNav_toDict(c1 * data):
    cdef BDSNav * sb0 = <BDSNav *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
        'Reserved': sb0.Reserved,
        'WN': sb0.WN,
        'URA': sb0.URA,
        'SatH1': sb0.SatH1,
        'IODC': sb0.IODC,
        'IODE': sb0.IODE,
        'Reserved2': sb0.Reserved2,
        'T_GD1': sb0.T_GD1,
        'T_GD2': sb0.T_GD2,
        't_oc': sb0.t_oc,
        'a_f2': sb0.a_f2,
        'a_f1': sb0.a_f1,
        'a_f0': sb0.a_f0,
        'C_rs': sb0.C_rs,
        'DEL_N': sb0.DEL_N,
        'M_0': sb0.M_0,
        'C_uc': sb0.C_uc,
        'e': sb0.e,
        'C_us': sb0.C_us,
        'SQRT_A': sb0.SQRT_A,
        't_oe': sb0.t_oe,
        'C_ic': sb0.C_ic,
        'OMEGA_0': sb0.OMEGA_0,
        'C_is': sb0.C_is,
        'i_0': sb0.i_0,
        'C_rc': sb0.C_rc,
        'omega': sb0.omega,
        'OMEGADOT': sb0.OMEGADOT,
        'IDOT': sb0.IDOT,
        'WNt_oc': sb0.WNt_oc,
        'WNt_oe': sb0.WNt_oe,
    }

    return block_dict

BLOCKPARSERS['BDSNav'] = BDSNav_toDict

def BDSAlm_toDict(c1 * data):
    cdef BDSAlm * sb0 = <BDSAlm *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
        'WN_a': sb0.WN_a,
        't_oa': sb0.t_oa,
        'SQRT_A': sb0.SQRT_A,
        'e': sb0.e,
        'omega': sb0.omega,
        'M_0': sb0.M_0,
        'OMEGA_0': sb0.OMEGA_0,
        'OMEGADOT': sb0.OMEGADOT,
        'delta_i': sb0.delta_i,
        'a_f0': sb0.a_f0,
        'a_f1': sb0.a_f1,
        'Health': sb0.Health,
        'Reserved': (<c1*>&sb0.Reserved)[0:2],
    }

    return block_dict

BLOCKPARSERS['BDSAlm'] = BDSAlm_toDict

def BDSIon_toDict(c1 * data):
    cdef BDSIon * sb0 = <BDSIon *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
        'Reserved': sb0.Reserved,
        'alpha_0': sb0.alpha_0,
        'alpha_1': sb0.alpha_1,
        'alpha_2': sb0.alpha_2,
        'alpha_3': sb0.alpha_3,
        'beta_0': sb0.beta_0,
        'beta_1': sb0.beta_1,
        'beta_2': sb0.beta_2,
        'beta_3': sb0.beta_3,
    }

    return block_dict

BLOCKPARSERS['BDSIon'] = BDSIon_toDict

def BDSUtc_toDict(c1 * data):
    cdef BDSUtc * sb0 = <BDSUtc *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
        'Reserved': sb0.Reserved,
        'A_1': sb0.A_1,
        'A_0': sb0.A_0,
        'DEL_t_LS': sb0.DEL_t_LS,
        'WN_LSF': sb0.WN_LSF,
        'DN': sb0.DN,
        'DEL_t_LSF': sb0.DEL_t_LSF,
    }

    return block_dict

BLOCKPARSERS['BDSUtc'] = BDSUtc_toDict

def QZSNav_toDict(c1 * data):
    cdef QZSNav * sb0 = <QZSNav *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
        'Reserved': sb0.Reserved,
        'WN': sb0.WN,
        'CAorPonL2': sb0.CAorPonL2,
        'URA': sb0.URA,
        'health': sb0.health,
        'L2DataFlag': sb0.L2DataFlag,
        'IODC': sb0.IODC,
        'IODE2': sb0.IODE2,
        'IODE3': sb0.IODE3,
        'FitIntFlg': sb0.FitIntFlg,
        'Reserved2': sb0.Reserved2,
        'T_gd': sb0.T_gd,
        't_oc': sb0.t_oc,
        'a_f2': sb0.a_f2,
        'a_f1': sb0.a_f1,
        'a_f0': sb0.a_f0,
        'C_rs': sb0.C_rs,
        'DEL_N': sb0.DEL_N,
        'M_0': sb0.M_0,
        'C_uc': sb0.C_uc,
        'e': sb0.e,
        'C_us': sb0.C_us,
        'SQRT_A': sb0.SQRT_A,
        't_oe': sb0.t_oe,
        'C_ic': sb0.C_ic,
        'OMEGA_0': sb0.OMEGA_0,
        'C_is': sb0.C_is,
        'i_0': sb0.i_0,
        'C_rc': sb0.C_rc,
        'omega': sb0.omega,
        'OMEGADOT': sb0.OMEGADOT,
        'IDOT': sb0.IDOT,
        'WNt_oc': sb0.WNt_oc,
        'WNt_oe': sb0.WNt_oe,
    }

    return block_dict

BLOCKPARSERS['QZSNav'] = QZSNav_toDict

def QZSAlm_toDict(c1 * data):
    cdef QZSAlm * sb0 = <QZSAlm *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
        'Reserved': sb0.Reserved,
        'e': sb0.e,
        't_oa': sb0.t_oa,
        'delta_i': sb0.delta_i,
        'OMEGADOT': sb0.OMEGADOT,
        'SQRT_A': sb0.SQRT_A,
        'OMEGA_0': sb0.OMEGA_0,
        'omega': sb0.omega,
        'M_0': sb0.M_0,
        'a_f1': sb0.a_f1,
        'a_f0': sb0.a_f0,
        'WN_a': sb0.WN_a,
        'Reserved2': sb0.Reserved2,
        'health8': sb0.health8,
        'health6': sb0.health6,
    }

    return block_dict

BLOCKPARSERS['QZSAlm'] = QZSAlm_toDict

def GEOMT00_toDict(c1 * data):
    cdef GEOMT00 * sb0 = <GEOMT00 *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
    }

    return block_dict

BLOCKPARSERS['GEOMT00'] = GEOMT00_toDict

def GEOPRNMask_toDict(c1 * data):
    cdef GEOPRNMask * sb0 = <GEOPRNMask *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
        'IODP': sb0.IODP,
        'NbrPRNs': sb0.NbrPRNs,
        'PRNMask': (<c1*>&sb0.PRNMask)[0:sb0.NbrPRNs],
    }

    return block_dict

BLOCKPARSERS['GEOPRNMask'] = GEOPRNMask_toDict

def GEOFastCorr_toDict(c1 * data):
    cdef GEOFastCorr * sb0 = <GEOFastCorr *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
        'MT': sb0.MT,
        'IODP': sb0.IODP,
        'IODF': sb0.IODF,
        'N': sb0.N,
        'SBLength': sb0.SBLength,
    }

    sub_block_list = []
    cdef GEOFastCorr_FastCorr subblock
    cdef size_t i = sizeof(GEOFastCorr)
    for _ in xrange(sb0.N):
        subblock = (<GEOFastCorr_FastCorr*>(data + i))[0]
        i += sb0.SBLength

        sub_block_dict = {
            'PRNMaskNo': subblock.PRNMaskNo,
            'UDREI': subblock.UDREI,
            'Reserved': (<c1*>&subblock.Reserved)[0:2],
            'PRC': subblock.PRC,
        }
        sub_block_list.append(sub_block_dict)
    block_dict['FastCorr'] = sub_block_list

    return block_dict

BLOCKPARSERS['GEOFastCorr'] = GEOFastCorr_toDict

def GEOIntegrity_toDict(c1 * data):
    cdef GEOIntegrity * sb0 = <GEOIntegrity *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
        'Reserved': sb0.Reserved,
        'IODF': (<c1*>&sb0.IODF)[0:4],
        'UDREI': (<c1*>&sb0.UDREI)[0:51],
    }

    return block_dict

BLOCKPARSERS['GEOIntegrity'] = GEOIntegrity_toDict

def GEOFastCorrDegr_toDict(c1 * data):
    cdef GEOFastCorrDegr * sb0 = <GEOFastCorrDegr *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
        'IODP': sb0.IODP,
        't_lat': sb0.t_lat,
        'AI': (<c1*>&sb0.AI)[0:51],
    }

    return block_dict

BLOCKPARSERS['GEOFastCorrDegr'] = GEOFastCorrDegr_toDict

def GEONav_toDict(c1 * data):
    cdef GEONav * sb0 = <GEONav *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
        'Reserved': sb0.Reserved,
        'IODN': sb0.IODN,
        'URA': sb0.URA,
        't0': sb0.t0,
        'Xg': sb0.Xg,
        'Yg': sb0.Yg,
        'Zg': sb0.Zg,
        'Xgd': sb0.Xgd,
        'Ygd': sb0.Ygd,
        'Zgd': sb0.Zgd,
        'Xgdd': sb0.Xgdd,
        'Ygdd': sb0.Ygdd,
        'Zgdd': sb0.Zgdd,
        'AGf0': sb0.AGf0,
        'AGf1': sb0.AGf1,
    }

    return block_dict

BLOCKPARSERS['GEONav'] = GEONav_toDict

def GEODegrFactors_toDict(c1 * data):
    cdef GEODegrFactors * sb0 = <GEODegrFactors *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
        'Reserved': sb0.Reserved,
        'Brrc': sb0.Brrc,
        'Cltc_lsb': sb0.Cltc_lsb,
        'Cltc_v1': sb0.Cltc_v1,
        'Iltc_v1': sb0.Iltc_v1,
        'Cltc_v0': sb0.Cltc_v0,
        'Iltc_v0': sb0.Iltc_v0,
        'Cgeo_lsb': sb0.Cgeo_lsb,
        'Cgeo_v': sb0.Cgeo_v,
        'Igeo': sb0.Igeo,
        'Cer': sb0.Cer,
        'Ciono_step': sb0.Ciono_step,
        'Iiono': sb0.Iiono,
        'Ciono_ramp': sb0.Ciono_ramp,
        'RSSudre': sb0.RSSudre,
        'RSSiono': sb0.RSSiono,
        'Reserved2': (<c1*>&sb0.Reserved2)[0:2],
        'Ccovariance': sb0.Ccovariance,
    }

    return block_dict

BLOCKPARSERS['GEODegrFactors'] = GEODegrFactors_toDict

def GEONetworkTime_toDict(c1 * data):
    cdef GEONetworkTime * sb0 = <GEONetworkTime *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
        'Reserved': sb0.Reserved,
        'A1': sb0.A1,
        'A0': sb0.A0,
        't_ot': sb0.t_ot,
        'WN_t': sb0.WN_t,
        'DEL_t_1S': sb0.DEL_t_1S,
        'WN_LSF': sb0.WN_LSF,
        'DN': sb0.DN,
        'DEL_t_LSF': sb0.DEL_t_LSF,
        'UTC_std': sb0.UTC_std,
        'GPS_WN': sb0.GPS_WN,
        'GPS_TOW': sb0.GPS_TOW,
        'GLONASSind': sb0.GLONASSind,
    }

    return block_dict

BLOCKPARSERS['GEONetworkTime'] = GEONetworkTime_toDict

def GEOAlm_toDict(c1 * data):
    cdef GEOAlm * sb0 = <GEOAlm *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
        'Reserved0': sb0.Reserved0,
        'DataID': sb0.DataID,
        'Reserved1': sb0.Reserved1,
        'Health': sb0.Health,
        't_oa': sb0.t_oa,
        'Xg': sb0.Xg,
        'Yg': sb0.Yg,
        'Zg': sb0.Zg,
        'Xgd': sb0.Xgd,
        'Ygd': sb0.Ygd,
        'Zgd': sb0.Zgd,
    }

    return block_dict

BLOCKPARSERS['GEOAlm'] = GEOAlm_toDict

def GEOIGPMask_toDict(c1 * data):
    cdef GEOIGPMask * sb0 = <GEOIGPMask *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
        'NbrBands': sb0.NbrBands,
        'BandNbr': sb0.BandNbr,
        'IODI': sb0.IODI,
        'NbrIGPs': sb0.NbrIGPs,
        'IGPMask': (<c1*>&sb0.IGPMask)[0:sb0.NbrIGPs],
    }

    return block_dict

BLOCKPARSERS['GEOIGPMask'] = GEOIGPMask_toDict

def GEOLongTermCorr_toDict(c1 * data):
    cdef GEOLongTermCorr * sb0 = <GEOLongTermCorr *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
        'N': sb0.N,
        'SBLength': sb0.SBLength,
        'Reserved': (<c1*>&sb0.Reserved)[0:3],
    }

    return block_dict

BLOCKPARSERS['GEOLongTermCorr'] = GEOLongTermCorr_toDict

def GEOIonoDelay_toDict(c1 * data):
    cdef GEOIonoDelay * sb0 = <GEOIonoDelay *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
        'BandNbr': sb0.BandNbr,
        'IODI': sb0.IODI,
        'N': sb0.N,
        'SBLength': sb0.SBLength,
        'Reserved': sb0.Reserved,
    }

    sub_block_list = []
    cdef GEOIonoDelay_IDC subblock
    cdef size_t i = sizeof(GEOIonoDelay)
    for _ in xrange(sb0.N):
        subblock = (<GEOIonoDelay_IDC*>(data + i))[0]
        i += sb0.SBLength

        sub_block_dict = {
            'IGPMaskNo': subblock.IGPMaskNo,
            'GIVEI': subblock.GIVEI,
            'Reserved': (<c1*>&subblock.Reserved)[0:2],
            'VerticalDelay': subblock.VerticalDelay,
        }
        sub_block_list.append(sub_block_dict)
    block_dict['IDC'] = sub_block_list

    return block_dict

BLOCKPARSERS['GEOIonoDelay'] = GEOIonoDelay_toDict

def GEOServiceLevel_toDict(c1 * data):
    cdef GEOServiceLevel * sb0 = <GEOServiceLevel *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
        'Reserved': sb0.Reserved,
        'IODS': sb0.IODS,
        'NrMessages': sb0.NrMessages,
        'MessageNr': sb0.MessageNr,
        'PriorityCode': sb0.PriorityCode,
        'dUDREI_In': sb0.dUDREI_In,
        'dUDREI_Out': sb0.dUDREI_Out,
        'N': sb0.N,
        'SBLength': sb0.SBLength,
    }

    sub_block_list = []
    cdef GEOServiceLevel_ServiceRegion subblock
    cdef size_t i = sizeof(GEOServiceLevel)
    for _ in xrange(sb0.N):
        subblock = (<GEOServiceLevel_ServiceRegion*>(data + i))[0]
        i += sb0.SBLength

        sub_block_dict = {
            'Latitude1': subblock.Latitude1,
            'Latitude2': subblock.Latitude2,
            'Longitude1': subblock.Longitude1,
            'Longitude2': subblock.Longitude2,
            'RegionShape': subblock.RegionShape,
            'Reserved': subblock.Reserved,
        }
        sub_block_list.append(sub_block_dict)
    block_dict['ServiceRegion'] = sub_block_list

    return block_dict

BLOCKPARSERS['GEOServiceLevel'] = GEOServiceLevel_toDict

def GEOClockEphCovMatrix_toDict(c1 * data):
    cdef GEOClockEphCovMatrix * sb0 = <GEOClockEphCovMatrix *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'PRN': sb0.PRN,
        'IODP': sb0.IODP,
        'N': sb0.N,
        'SBLength': sb0.SBLength,
        'Reserved': (<c1*>&sb0.Reserved)[0:2],
    }

    sub_block_list = []
    cdef GEOClockEphCovMatrix_CovMatrix subblock
    cdef size_t i = sizeof(GEOClockEphCovMatrix)
    for _ in xrange(sb0.N):
        subblock = (<GEOClockEphCovMatrix_CovMatrix*>(data + i))[0]
        i += sb0.SBLength

        sub_block_dict = {
            'PRNMaskNo': subblock.PRNMaskNo,
            'Reserved': (<c1*>&subblock.Reserved)[0:2],
            'ScaleExp': subblock.ScaleExp,
            'E11': subblock.E11,
            'E22': subblock.E22,
            'E33': subblock.E33,
            'E44': subblock.E44,
            'E12': subblock.E12,
            'E13': subblock.E13,
            'E14': subblock.E14,
            'E23': subblock.E23,
            'E24': subblock.E24,
            'E34': subblock.E34,
        }
        sub_block_list.append(sub_block_dict)
    block_dict['CovMatrix'] = sub_block_list

    return block_dict

BLOCKPARSERS['GEOClockEphCovMatrix'] = GEOClockEphCovMatrix_toDict

def PVTCartesian_toDict(c1 * data):
    cdef PVTCartesian * sb0 = <PVTCartesian *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'Mode': sb0.Mode,
        'Error': sb0.Error,
        'X': sb0.X,
        'Y': sb0.Y,
        'Z': sb0.Z,
        'Undulation': sb0.Undulation,
        'Vx': sb0.Vx,
        'Vy': sb0.Vy,
        'Vz': sb0.Vz,
        'COG': sb0.COG,
        'RxClkBias': sb0.RxClkBias,
        'RxClkDrift': sb0.RxClkDrift,
        'TimeSystem': sb0.TimeSystem,
        'Datum': sb0.Datum,
        'NrSV': sb0.NrSV,
        'WACorrInfo': sb0.WACorrInfo,
        'ReferenceID': sb0.ReferenceID,
        'MeanCorrAge': sb0.MeanCorrAge,
        'SignalInfo': sb0.SignalInfo,
        'AlertFlag': sb0.AlertFlag,
        'NrBases': sb0.NrBases,
        'PPPInfo': sb0.PPPInfo,
        'Latency': sb0.Latency,
        'HAccuracy': sb0.HAccuracy,
        'VAccuracy': sb0.VAccuracy,
        'Misc': sb0.Misc,
    }

    return block_dict

BLOCKPARSERS['PVTCartesian'] = PVTCartesian_toDict

def PVTGeodetic_toDict(c1 * data):
    cdef PVTGeodetic * sb0 = <PVTGeodetic *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'Mode': sb0.Mode,
        'Error': sb0.Error,
        'Latitude': sb0.Latitude,
        'Longitude': sb0.Longitude,
        'Height': sb0.Height,
        'Undulation': sb0.Undulation,
        'Vn': sb0.Vn,
        'Ve': sb0.Ve,
        'Vu': sb0.Vu,
        'COG': sb0.COG,
        'RxClkBias': sb0.RxClkBias,
        'RxClkDrift': sb0.RxClkDrift,
        'TimeSystem': sb0.TimeSystem,
        'Datum': sb0.Datum,
        'NrSV': sb0.NrSV,
        'WACorrInfo': sb0.WACorrInfo,
        'ReferenceID': sb0.ReferenceID,
        'MeanCorrAge': sb0.MeanCorrAge,
        'SignalInfo': sb0.SignalInfo,
        'AlertFlag': sb0.AlertFlag,
        'NrBases': sb0.NrBases,
        'PPPInfo': sb0.PPPInfo,
        'Latency': sb0.Latency,
        'HAccuracy': sb0.HAccuracy,
        'VAccuracy': sb0.VAccuracy,
        'Misc': sb0.Misc,
    }

    return block_dict

BLOCKPARSERS['PVTGeodetic'] = PVTGeodetic_toDict

def PosCovCartesian_toDict(c1 * data):
    cdef PosCovCartesian * sb0 = <PosCovCartesian *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'Mode': sb0.Mode,
        'Error': sb0.Error,
        'Cov_xx': sb0.Cov_xx,
        'Cov_yy': sb0.Cov_yy,
        'Cov_zz': sb0.Cov_zz,
        'Cov_bb': sb0.Cov_bb,
        'Cov_xy': sb0.Cov_xy,
        'Cov_xz': sb0.Cov_xz,
        'Cov_xb': sb0.Cov_xb,
        'Cov_yz': sb0.Cov_yz,
        'Cov_yb': sb0.Cov_yb,
        'Cov_zb': sb0.Cov_zb,
    }

    return block_dict

BLOCKPARSERS['PosCovCartesian'] = PosCovCartesian_toDict

def PosCovGeodetic_toDict(c1 * data):
    cdef PosCovGeodetic * sb0 = <PosCovGeodetic *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'Mode': sb0.Mode,
        'Error': sb0.Error,
        'Cov_latlat': sb0.Cov_latlat,
        'Cov_lonlon': sb0.Cov_lonlon,
        'Cov_hgthgt': sb0.Cov_hgthgt,
        'Cov_bb': sb0.Cov_bb,
        'Cov_latlon': sb0.Cov_latlon,
        'Cov_lathgt': sb0.Cov_lathgt,
        'Cov_latb': sb0.Cov_latb,
        'Cov_lonhgt': sb0.Cov_lonhgt,
        'Cov_lonb': sb0.Cov_lonb,
        'Cov_hb': sb0.Cov_hb,
    }

    return block_dict

BLOCKPARSERS['PosCovGeodetic'] = PosCovGeodetic_toDict

def VelCovCartesian_toDict(c1 * data):
    cdef VelCovCartesian * sb0 = <VelCovCartesian *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'Mode': sb0.Mode,
        'Error': sb0.Error,
        'Cov_VxVx': sb0.Cov_VxVx,
        'Cov_VyVy': sb0.Cov_VyVy,
        'Cov_VzVz': sb0.Cov_VzVz,
        'Cov_DtDt': sb0.Cov_DtDt,
        'Cov_VxVy': sb0.Cov_VxVy,
        'Cov_VxVz': sb0.Cov_VxVz,
        'Cov_VxDt': sb0.Cov_VxDt,
        'Cov_VyVz': sb0.Cov_VyVz,
        'Cov_VyDt': sb0.Cov_VyDt,
        'Cov_VzDt': sb0.Cov_VzDt,
    }

    return block_dict

BLOCKPARSERS['VelCovCartesian'] = VelCovCartesian_toDict

def VelCovGeodetic_toDict(c1 * data):
    cdef VelCovGeodetic * sb0 = <VelCovGeodetic *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'Mode': sb0.Mode,
        'Error': sb0.Error,
        'Cov_VnVn': sb0.Cov_VnVn,
        'Cov_VeVe': sb0.Cov_VeVe,
        'Cov_VuVu': sb0.Cov_VuVu,
        'Cov_DtDt': sb0.Cov_DtDt,
        'Cov_VnVe': sb0.Cov_VnVe,
        'Cov_VnVu': sb0.Cov_VnVu,
        'Cov_VnDt': sb0.Cov_VnDt,
        'Cov_VeVu': sb0.Cov_VeVu,
        'Cov_VeDt': sb0.Cov_VeDt,
        'Cov_VuDt': sb0.Cov_VuDt,
    }

    return block_dict

BLOCKPARSERS['VelCovGeodetic'] = VelCovGeodetic_toDict

def DOP_toDict(c1 * data):
    cdef DOP * sb0 = <DOP *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'NrSV': sb0.NrSV,
        'Reserved': sb0.Reserved,
        'PDOP': sb0.PDOP,
        'TDOP': sb0.TDOP,
        'HDOP': sb0.HDOP,
        'VDOP': sb0.VDOP,
        'HPL': sb0.HPL,
        'VPL': sb0.VPL,
    }

    return block_dict

BLOCKPARSERS['DOP'] = DOP_toDict

def PosCart_toDict(c1 * data):
    cdef PosCart * sb0 = <PosCart *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'Mode': sb0.Mode,
        'Error': sb0.Error,
        'X': sb0.X,
        'Y': sb0.Y,
        'Z': sb0.Z,
        'Base2RoverX': sb0.Base2RoverX,
        'Base2RoverY': sb0.Base2RoverY,
        'Base2RoverZ': sb0.Base2RoverZ,
        'Cov_xx': sb0.Cov_xx,
        'Cov_yy': sb0.Cov_yy,
        'Cov_zz': sb0.Cov_zz,
        'Cov_xy': sb0.Cov_xy,
        'Cov_xz': sb0.Cov_xz,
        'Cov_yz': sb0.Cov_yz,
        'PDOP': sb0.PDOP,
        'HDOP': sb0.HDOP,
        'VDOP': sb0.VDOP,
        'Misc': sb0.Misc,
        'Reserved': sb0.Reserved,
        'AlertFlag': sb0.AlertFlag,
        'Datum': sb0.Datum,
        'NrSV': sb0.NrSV,
        'WACorrInfo': sb0.WACorrInfo,
        'ReferenceId': sb0.ReferenceId,
        'MeanCorrAge': sb0.MeanCorrAge,
        'SignalInfo': sb0.SignalInfo,
    }

    return block_dict

BLOCKPARSERS['PosCart'] = PosCart_toDict

def PosLocal_toDict(c1 * data):
    cdef PosLocal * sb0 = <PosLocal *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'Mode': sb0.Mode,
        'Error': sb0.Error,
        'Lat': sb0.Lat,
        'Lon': sb0.Lon,
        'Alt': sb0.Alt,
        'Datum': sb0.Datum,
    }

    return block_dict

BLOCKPARSERS['PosLocal'] = PosLocal_toDict

def PosProjected_toDict(c1 * data):
    cdef PosProjected * sb0 = <PosProjected *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'Mode': sb0.Mode,
        'Error': sb0.Error,
        'Northing': sb0.Northing,
        'Easting': sb0.Easting,
        'Alt': sb0.Alt,
        'Datum': sb0.Datum,
    }

    return block_dict

BLOCKPARSERS['PosProjected'] = PosProjected_toDict

def BaseVectorCart_toDict(c1 * data):
    cdef BaseVectorCart * sb0 = <BaseVectorCart *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'N': sb0.N,
        'SBLength': sb0.SBLength,
    }

    sub_block_list = []
    cdef BaseVectorCart_VectorInfoCart subblock
    cdef size_t i = sizeof(BaseVectorCart)
    for _ in xrange(sb0.N):
        subblock = (<BaseVectorCart_VectorInfoCart*>(data + i))[0]
        i += sb0.SBLength

        sub_block_dict = {
            'NrSV': subblock.NrSV,
            'Error': subblock.Error,
            'Mode': subblock.Mode,
            'Misc': subblock.Misc,
            'DeltaX': subblock.DeltaX,
            'DeltaY': subblock.DeltaY,
            'DeltaZ': subblock.DeltaZ,
            'DeltaVx': subblock.DeltaVx,
            'DeltaVy': subblock.DeltaVy,
            'DeltaVz': subblock.DeltaVz,
            'Azimuth': subblock.Azimuth,
            'Elevation': subblock.Elevation,
            'ReferenceID': subblock.ReferenceID,
            'CorrAge': subblock.CorrAge,
            'SignalInfo': subblock.SignalInfo,
        }
        sub_block_list.append(sub_block_dict)
    block_dict['VectorInfoCart'] = sub_block_list

    return block_dict

BLOCKPARSERS['BaseVectorCart'] = BaseVectorCart_toDict

def BaseVectorGeod_toDict(c1 * data):
    cdef BaseVectorGeod * sb0 = <BaseVectorGeod *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'N': sb0.N,
        'SBLength': sb0.SBLength,
    }

    sub_block_list = []
    cdef BaseVectorGeod_VectorInfoGeod subblock
    cdef size_t i = sizeof(BaseVectorGeod)
    for _ in xrange(sb0.N):
        subblock = (<BaseVectorGeod_VectorInfoGeod*>(data + i))[0]
        i += sb0.SBLength

        sub_block_dict = {
            'NrSV': subblock.NrSV,
            'Error': subblock.Error,
            'Mode': subblock.Mode,
            'Misc': subblock.Misc,
            'DeltaEast': subblock.DeltaEast,
            'DeltaNorth': subblock.DeltaNorth,
            'DeltaUp': subblock.DeltaUp,
            'DeltaVe': subblock.DeltaVe,
            'DeltaVn': subblock.DeltaVn,
            'DeltaVu': subblock.DeltaVu,
            'Azimuth': subblock.Azimuth,
            'Elevation': subblock.Elevation,
            'ReferenceID': subblock.ReferenceID,
            'CorrAge': subblock.CorrAge,
            'SignalInfo': subblock.SignalInfo,
        }
        sub_block_list.append(sub_block_dict)
    block_dict['VectorInfoGeod'] = sub_block_list

    return block_dict

BLOCKPARSERS['BaseVectorGeod'] = BaseVectorGeod_toDict

def EndOfPVT_toDict(c1 * data):
    cdef EndOfPVT * sb0 = <EndOfPVT *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
    }

    return block_dict

BLOCKPARSERS['EndOfPVT'] = EndOfPVT_toDict

def AttEuler_toDict(c1 * data):
    cdef AttEuler * sb0 = <AttEuler *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'NrSV': sb0.NrSV,
        'Error': sb0.Error,
        'Mode': sb0.Mode,
        'Reserved': sb0.Reserved,
        'Heading': sb0.Heading,
        'Pitch': sb0.Pitch,
        'Roll': sb0.Roll,
        'PitchDot': sb0.PitchDot,
        'RollDot': sb0.RollDot,
        'HeadingDot': sb0.HeadingDot,
    }

    return block_dict

BLOCKPARSERS['AttEuler'] = AttEuler_toDict

def AttCovEuler_toDict(c1 * data):
    cdef AttCovEuler * sb0 = <AttCovEuler *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'Reserved': sb0.Reserved,
        'Error': sb0.Error,
        'Cov_HeadHead': sb0.Cov_HeadHead,
        'Cov_PitchPitch': sb0.Cov_PitchPitch,
        'Cov_RollRoll': sb0.Cov_RollRoll,
        'Cov_HeadPitch': sb0.Cov_HeadPitch,
        'Cov_HeadRoll': sb0.Cov_HeadRoll,
        'Cov_PitchRoll': sb0.Cov_PitchRoll,
    }

    return block_dict

BLOCKPARSERS['AttCovEuler'] = AttCovEuler_toDict

def EndOfAtt_toDict(c1 * data):
    cdef EndOfAtt * sb0 = <EndOfAtt *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
    }

    return block_dict

BLOCKPARSERS['EndOfAtt'] = EndOfAtt_toDict

def ReceiverTime_toDict(c1 * data):
    cdef ReceiverTime * sb0 = <ReceiverTime *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'UTCYear': sb0.UTCYear,
        'UTCMonth': sb0.UTCMonth,
        'UTCDay': sb0.UTCDay,
        'UTCHour': sb0.UTCHour,
        'UTCMin': sb0.UTCMin,
        'UTCSec': sb0.UTCSec,
        'DeltaLS': sb0.DeltaLS,
        'SyncLevel': sb0.SyncLevel,
    }

    return block_dict

BLOCKPARSERS['ReceiverTime'] = ReceiverTime_toDict

def xPPSOffset_toDict(c1 * data):
    cdef xPPSOffset * sb0 = <xPPSOffset *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SyncAge': sb0.SyncAge,
        'Timescale': sb0.Timescale,
        'Offset': sb0.Offset,
    }

    return block_dict

BLOCKPARSERS['xPPSOffset'] = xPPSOffset_toDict

def ExtEvent_toDict(c1 * data):
    cdef ExtEvent * sb0 = <ExtEvent *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'Source': sb0.Source,
        'Polarity': sb0.Polarity,
        'Offset': sb0.Offset,
        'RxClkBias': sb0.RxClkBias,
        'PVTAge': sb0.PVTAge,
    }

    return block_dict

BLOCKPARSERS['ExtEvent'] = ExtEvent_toDict

def ExtEventPVTCartesian_toDict(c1 * data):
    cdef ExtEventPVTCartesian * sb0 = <ExtEventPVTCartesian *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'Mode': sb0.Mode,
        'Error': sb0.Error,
        'X': sb0.X,
        'Y': sb0.Y,
        'Z': sb0.Z,
        'Undulation': sb0.Undulation,
        'Vx': sb0.Vx,
        'Vy': sb0.Vy,
        'Vz': sb0.Vz,
        'COG': sb0.COG,
        'RxClkBias': sb0.RxClkBias,
        'RxClkDrift': sb0.RxClkDrift,
        'TimeSystem': sb0.TimeSystem,
        'Datum': sb0.Datum,
        'NrSV': sb0.NrSV,
        'WACorrInfo': sb0.WACorrInfo,
        'ReferenceID': sb0.ReferenceID,
        'MeanCorrAge': sb0.MeanCorrAge,
        'SignalInfo': sb0.SignalInfo,
        'AlertFlag': sb0.AlertFlag,
        'NrBases': sb0.NrBases,
        'PPPInfo': sb0.PPPInfo,
        'Latency': sb0.Latency,
        'HAccuracy': sb0.HAccuracy,
        'VAccuracy': sb0.VAccuracy,
        'Misc': sb0.Misc,
    }

    return block_dict

BLOCKPARSERS['ExtEventPVTCartesian'] = ExtEventPVTCartesian_toDict

def ExtEventPVTGeodetic_toDict(c1 * data):
    cdef ExtEventPVTGeodetic * sb0 = <ExtEventPVTGeodetic *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'Mode': sb0.Mode,
        'Error': sb0.Error,
        'Latitude': sb0.Latitude,
        'Longitude': sb0.Longitude,
        'Height': sb0.Height,
        'Undulation': sb0.Undulation,
        'Vn': sb0.Vn,
        'Ve': sb0.Ve,
        'Vu': sb0.Vu,
        'COG': sb0.COG,
        'RxClkBias': sb0.RxClkBias,
        'RxClkDrift': sb0.RxClkDrift,
        'TimeSystem': sb0.TimeSystem,
        'Datum': sb0.Datum,
        'NrSV': sb0.NrSV,
        'WACorrInfo': sb0.WACorrInfo,
        'ReferenceID': sb0.ReferenceID,
        'MeanCorrAge': sb0.MeanCorrAge,
        'SignalInfo': sb0.SignalInfo,
        'AlertFlag': sb0.AlertFlag,
        'NrBases': sb0.NrBases,
        'PPPInfo': sb0.PPPInfo,
        'Latency': sb0.Latency,
        'HAccuracy': sb0.HAccuracy,
        'VAccuracy': sb0.VAccuracy,
        'Misc': sb0.Misc,
    }

    return block_dict

BLOCKPARSERS['ExtEventPVTGeodetic'] = ExtEventPVTGeodetic_toDict

def ExtEventBaseVectGeod_toDict(c1 * data):
    cdef ExtEventBaseVectGeod * sb0 = <ExtEventBaseVectGeod *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'N': sb0.N,
        'SBLength': sb0.SBLength,
    }

    return block_dict

BLOCKPARSERS['ExtEventBaseVectGeod'] = ExtEventBaseVectGeod_toDict

def ExtEventAttEuler_toDict(c1 * data):
    cdef ExtEventAttEuler * sb0 = <ExtEventAttEuler *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'NrSV': sb0.NrSV,
        'Error': sb0.Error,
        'Mode': sb0.Mode,
        'Reserved': sb0.Reserved,
        'Heading': sb0.Heading,
        'Pitch': sb0.Pitch,
        'Roll': sb0.Roll,
        'PitchDot': sb0.PitchDot,
        'RollDot': sb0.RollDot,
        'HeadingDot': sb0.HeadingDot,
    }

    return block_dict

BLOCKPARSERS['ExtEventAttEuler'] = ExtEventAttEuler_toDict

def DiffCorrIn_toDict(c1 * data):
    cdef DiffCorrIn * sb0 = <DiffCorrIn *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'Mode': sb0.Mode,
        'Source': sb0.Source,
        'MessageContent': sb0.MessageContent,
    }

    return block_dict

BLOCKPARSERS['DiffCorrIn'] = DiffCorrIn_toDict

def BaseStation_toDict(c1 * data):
    cdef BaseStation * sb0 = <BaseStation *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'BaseStationID': sb0.BaseStationID,
        'BaseType': sb0.BaseType,
        'Source': sb0.Source,
        'Datum': sb0.Datum,
        'Reserved': sb0.Reserved,
        'X': sb0.X,
        'Y': sb0.Y,
        'Z': sb0.Z,
    }

    return block_dict

BLOCKPARSERS['BaseStation'] = BaseStation_toDict

def RTCMDatum_toDict(c1 * data):
    cdef RTCMDatum * sb0 = <RTCMDatum *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'SourceCRS': (<c1*>&sb0.SourceCRS)[0:32],
        'TargetCRS': (<c1*>&sb0.TargetCRS)[0:32],
        'Datum': sb0.Datum,
        'HeightType': sb0.HeightType,
        'QualityInd': sb0.QualityInd,
    }

    return block_dict

BLOCKPARSERS['RTCMDatum'] = RTCMDatum_toDict

def LBandTrackerStatus_toDict(c1 * data):
    cdef LBandTrackerStatus * sb0 = <LBandTrackerStatus *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'N': sb0.N,
        'SBLength': sb0.SBLength,
    }

    sub_block_list = []
    cdef LBandTrackerStatus_TrackData subblock
    cdef size_t i = sizeof(LBandTrackerStatus)
    for _ in xrange(sb0.N):
        subblock = (<LBandTrackerStatus_TrackData*>(data + i))[0]
        i += sb0.SBLength

        sub_block_dict = {
            'Frequency': subblock.Frequency,
            'Baudrate': subblock.Baudrate,
            'ServiceID': subblock.ServiceID,
            'FreqOffset': subblock.FreqOffset,
            'CN0': subblock.CN0,
            'AvgPower': subblock.AvgPower,
            'AGCGain': subblock.AGCGain,
            'Mode': subblock.Mode,
            'Status': subblock.Status,
            'SVID': subblock.SVID,
            'LockTime': subblock.LockTime,
            'Source': subblock.Source,
        }
        sub_block_list.append(sub_block_dict)
    block_dict['TrackData'] = sub_block_list

    return block_dict

BLOCKPARSERS['LBandTrackerStatus'] = LBandTrackerStatus_toDict

def LBandBeams_toDict(c1 * data):
    cdef LBandBeams * sb0 = <LBandBeams *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'N': sb0.N,
        'SBLength': sb0.SBLength,
    }

    return block_dict

BLOCKPARSERS['LBandBeams'] = LBandBeams_toDict

def LBandRaw_toDict(c1 * data):
    cdef LBandRaw * sb0 = <LBandRaw *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'N': sb0.N,
        'Frequency': sb0.Frequency,
        'UserData': (<c1*>&sb0.UserData)[0:sb0.N],
        'Channel': sb0.Channel,
    }

    return block_dict

BLOCKPARSERS['LBandRaw'] = LBandRaw_toDict

def FugroStatus_toDict(c1 * data):
    cdef FugroStatus * sb0 = <FugroStatus *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'Reserved': (<c1*>&sb0.Reserved)[0:2],
        'Status': sb0.Status,
        'SubStartingTime': sb0.SubStartingTime,
        'SubExpirationTime': sb0.SubExpirationTime,
        'SubHourGlass': sb0.SubHourGlass,
        'SubscribedMode': sb0.SubscribedMode,
        'SubCurrentMode': sb0.SubCurrentMode,
        'SubLinkVector': sb0.SubLinkVector,
        'CRCGoodCount': sb0.CRCGoodCount,
        'CRCBadCount': sb0.CRCBadCount,
        'LbandTrackerStatusIdx': sb0.LbandTrackerStatusIdx,
    }

    return block_dict

BLOCKPARSERS['FugroStatus'] = FugroStatus_toDict

def ChannelStatus_toDict(c1 * data):
    cdef ChannelStatus * sb0 = <ChannelStatus *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'N': sb0.N,
        'SB1Length': sb0.SB1Length,
        'SB2Length': sb0.SB2Length,
        'Reserved': (<c1*>&sb0.Reserved)[0:3],
    }

    sub_block_list = []
    cdef ChannelStatus_ChannelSatInfo subblock
    cdef size_t i = sizeof(ChannelStatus)
    cdef ChannelStatus_ChannelStateInfo subsubblock
    for _ in xrange(sb0.N):
        subblock = (<ChannelStatus_ChannelSatInfo*>(data + i))[0]
        i += sb0.SB1Length

        sub_block_dict = {
            'SVID': subblock.SVID,
            'FreqNr': subblock.FreqNr,
            'Reserved': subblock.Reserved,
            'Azimuth_RiseSet': subblock.Azimuth_RiseSet,
            'HealthStatus': subblock.HealthStatus,
            'Elevation': subblock.Elevation,
            'N2': subblock.N2,
            'RxChannel': subblock.RxChannel,
            'Reserved2': subblock.Reserved2,
        }
        sub_sub_block_list = []
        for _ in xrange(subblock.N2):
            subsubblock = (<ChannelStatus_ChannelStateInfo*>(data + i))[0]
            i += sb0.SB2Length

            sub_sub_block_list.append({
                'Antenna': subsubblock.Antenna,
                'Reserved': subsubblock.Reserved,
                'TrackingStatus': subsubblock.TrackingStatus,
                'PVTStatus': subsubblock.PVTStatus,
                'PVTInfo': subsubblock.PVTInfo,
            })
        sub_block_dict['StateInfo'] = sub_sub_block_list
        sub_block_list.append(sub_block_dict)
    block_dict['SatInfo'] = sub_block_list

    return block_dict

BLOCKPARSERS['ChannelStatus'] = ChannelStatus_toDict

def ReceiverStatus_toDict(c1 * data):
    cdef ReceiverStatus * sb0 = <ReceiverStatus *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'CPULoad': sb0.CPULoad,
        'ExtError': sb0.ExtError,
        'UpTime': sb0.UpTime,
        'RxState': sb0.RxState,
        'RxError': sb0.RxError,
        'N': sb0.N,
        'SBLength': sb0.SBLength,
        'CmdCount': sb0.CmdCount,
        'Temperature': sb0.Temperature,
    }

    sub_block_list = []
    cdef ReceiverStatus_AGCState subblock
    cdef size_t i = sizeof(ReceiverStatus)
    for _ in xrange(sb0.N):
        subblock = (<ReceiverStatus_AGCState*>(data + i))[0]
        i += sb0.SBLength

        sub_block_dict = {
            'FrontendID': subblock.FrontendID,
            'Gain': subblock.Gain,
            'SampleVar': subblock.SampleVar,
            'BlankingStat': subblock.BlankingStat,
        }
        sub_block_list.append(sub_block_dict)
    block_dict['AGCState'] = sub_block_list

    return block_dict

BLOCKPARSERS['ReceiverStatus'] = ReceiverStatus_toDict

def SatVisibility_toDict(c1 * data):
    cdef SatVisibility * sb0 = <SatVisibility *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'N': sb0.N,
        'SBLength': sb0.SBLength,
    }

    sub_block_list = []
    cdef SatVisibility_SatInfo subblock
    cdef size_t i = sizeof(SatVisibility)
    for _ in xrange(sb0.N):
        subblock = (<SatVisibility_SatInfo*>(data + i))[0]
        i += sb0.SBLength

        sub_block_dict = {
            'SVID': subblock.SVID,
            'FreqNr': subblock.FreqNr,
            'Azimuth': subblock.Azimuth,
            'Elevation': subblock.Elevation,
            'RiseSet': subblock.RiseSet,
            'SatelliteInfo': subblock.SatelliteInfo,
        }
        sub_block_list.append(sub_block_dict)
    block_dict['SatInfo'] = sub_block_list

    return block_dict

BLOCKPARSERS['SatVisibility'] = SatVisibility_toDict

def InputLink_toDict(c1 * data):
    cdef InputLink * sb0 = <InputLink *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'N': sb0.N,
        'SBLength': sb0.SBLength,
    }

    sub_block_list = []
    cdef InputLink_InputStats subblock
    cdef size_t i = sizeof(InputLink)
    for _ in xrange(sb0.N):
        subblock = (<InputLink_InputStats*>(data + i))[0]
        i += sb0.SBLength

        sub_block_dict = {
            'CD': subblock.CD,
            'Type': subblock.Type,
            'AgeOfLastMessage': subblock.AgeOfLastMessage,
            'NrBytesReceived': subblock.NrBytesReceived,
            'NrBytesAccepted': subblock.NrBytesAccepted,
            'NrMsgReceived': subblock.NrMsgReceived,
            'NrMsgAccepted': subblock.NrMsgAccepted,
        }
        sub_block_list.append(sub_block_dict)
    block_dict['InputStats'] = sub_block_list

    return block_dict

BLOCKPARSERS['InputLink'] = InputLink_toDict

def NTRIPClientStatus_toDict(c1 * data):
    cdef NTRIPClientStatus * sb0 = <NTRIPClientStatus *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'N': sb0.N,
        'SBLength': sb0.SBLength,
    }

    sub_block_list = []
    cdef NTRIPClientConnection subblock
    cdef size_t i = sizeof(NTRIPClientStatus)
    for _ in xrange(sb0.N):
        subblock = (<NTRIPClientConnection*>(data + i))[0]
        i += sb0.SBLength

        sub_block_dict = {
            'CDIndex': subblock.CDIndex,
            'Status': subblock.Status,
            'ErrorCode': subblock.ErrorCode,
            'Info': subblock.Info,
        }
        sub_block_list.append(sub_block_dict)
    block_dict['NTRIPClientConnection'] = sub_block_list

    return block_dict

BLOCKPARSERS['NTRIPClientStatus'] = NTRIPClientStatus_toDict

def NTRIPServerStatus_toDict(c1 * data):
    cdef NTRIPServerStatus * sb0 = <NTRIPServerStatus *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'N': sb0.N,
        'SBLength': sb0.SBLength,
    }

    sub_block_list = []
    cdef NTRIPServerConnection subblock
    cdef size_t i = sizeof(NTRIPServerStatus)
    for _ in xrange(sb0.N):
        subblock = (<NTRIPServerConnection*>(data + i))[0]
        i += sb0.SBLength

        sub_block_dict = {
            'CDIndex': subblock.CDIndex,
            'Status': subblock.Status,
            'ErrorCode': subblock.ErrorCode,
            'Info': subblock.Info,
        }
        sub_block_list.append(sub_block_dict)
    block_dict['NTRIPServerConnection'] = sub_block_list

    return block_dict

BLOCKPARSERS['NTRIPServerStatus'] = NTRIPServerStatus_toDict

def IPStatus_toDict(c1 * data):
    cdef IPStatus * sb0 = <IPStatus *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'MACAddress': (<c1*>&sb0.MACAddress)[0:6],
        'IPAddress': (<c1*>&sb0.IPAddress)[0:16],
        'Gateway': (<c1*>&sb0.Gateway)[0:16],
        'Netmask': sb0.Netmask,
        'Reserved': (<c1*>&sb0.Reserved)[0:3],
        'HostName': (<c1*>&sb0.HostName)[0:33],
    }

    return block_dict

BLOCKPARSERS['IPStatus'] = IPStatus_toDict

def DynDNSStatus_toDict(c1 * data):
    cdef DynDNSStatus * sb0 = <DynDNSStatus *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'Status': sb0.Status,
        'ErrorCode': sb0.ErrorCode,
        'IPAddress': (<c1*>&sb0.IPAddress)[0:16],
    }

    return block_dict

BLOCKPARSERS['DynDNSStatus'] = DynDNSStatus_toDict

def QualityInd_toDict(c1 * data):
    cdef QualityInd * sb0 = <QualityInd *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'N': sb0.N,
        'Reserved': sb0.Reserved,
        'Indicators': (<c1*>&sb0.Indicators)[0:sb0.N * 2],
    }

    return block_dict

BLOCKPARSERS['QualityInd'] = QualityInd_toDict

def DiskStatus_toDict(c1 * data):
    cdef DiskStatus * sb0 = <DiskStatus *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'N': sb0.N,
        'SBLength': sb0.SBLength,
        'Reserved': (<c1*>&sb0.Reserved)[0:4],
    }

    sub_block_list = []
    cdef DiskData subblock
    cdef size_t i = sizeof(DiskStatus)
    for _ in xrange(sb0.N):
        subblock = (<DiskData*>(data + i))[0]
        i += sb0.SBLength

        sub_block_dict = {
            'DiskID': subblock.DiskID,
            'Status': subblock.Status,
            'DiskUsageMSB': subblock.DiskUsageMSB,
            'DiskUsageLSB': subblock.DiskUsageLSB,
            'DiskSize': subblock.DiskSize,
            'CreateDeleteCount': subblock.CreateDeleteCount,
            'Error': subblock.Error,
        }
        sub_block_list.append(sub_block_dict)
    block_dict['DiskData'] = sub_block_list

    return block_dict

BLOCKPARSERS['DiskStatus'] = DiskStatus_toDict

def RFStatus_toDict(c1 * data):
    cdef RFStatus * sb0 = <RFStatus *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'N': sb0.N,
        'SBLength': sb0.SBLength,
        'Flags': sb0.Flags,
        'Reserved': (<c1*>&sb0.Reserved)[0:3],
    }

    sub_block_list = []
    cdef RFBand subblock
    cdef size_t i = sizeof(RFStatus)
    for _ in xrange(sb0.N):
        subblock = (<RFBand*>(data + i))[0]
        i += sb0.SBLength

        sub_block_dict = {
            'Frequency': subblock.Frequency,
            'Bandwidth': subblock.Bandwidth,
            'Info': subblock.Info,
        }
        sub_block_list.append(sub_block_dict)
    block_dict['RFBand'] = sub_block_list

    return block_dict

BLOCKPARSERS['RFStatus'] = RFStatus_toDict

def P2PPStatus_toDict(c1 * data):
    cdef P2PPStatus * sb0 = <P2PPStatus *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'N': sb0.N,
        'SBLength': sb0.SBLength,
    }

    sub_block_list = []
    cdef P2PPSession subblock
    cdef size_t i = sizeof(P2PPStatus)
    for _ in xrange(sb0.N):
        subblock = (<P2PPSession*>(data + i))[0]
        i += sb0.SBLength

        sub_block_dict = {
            'SessionID': subblock.SessionID,
            'Port': subblock.Port,
            'Status': subblock.Status,
            'ErrorCode': subblock.ErrorCode,
        }
        sub_block_list.append(sub_block_dict)
    block_dict['P2PPSession'] = sub_block_list

    return block_dict

BLOCKPARSERS['P2PPStatus'] = P2PPStatus_toDict

def CosmosStatus_toDict(c1 * data):
    cdef CosmosStatus * sb0 = <CosmosStatus *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'Status': sb0.Status,
    }

    return block_dict

BLOCKPARSERS['CosmosStatus'] = CosmosStatus_toDict

def GALAuthStatus_toDict(c1 * data):
    cdef GALAuthStatus * sb0 = <GALAuthStatus *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'OSNMAStatus': sb0.OSNMAStatus,
        'TrustedTimeDelta': sb0.TrustedTimeDelta,
        'GalActiveMask': sb0.GalActiveMask,
        'GalAuthenticMask': sb0.GalAuthenticMask,
        'GpsActiveMask': sb0.GpsActiveMask,
        'GpsAuthenticMask': sb0.GpsAuthenticMask,
    }

    return block_dict

BLOCKPARSERS['GALAuthStatus'] = GALAuthStatus_toDict

def ReceiverSetup_toDict(c1 * data):
    cdef ReceiverSetup * sb0 = <ReceiverSetup *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'Reserved': (<c1*>&sb0.Reserved)[0:2],
        'MarkerName': (<c1*>&sb0.MarkerName)[0:60],
        'MarkerNumber': (<c1*>&sb0.MarkerNumber)[0:20],
        'Observer': (<c1*>&sb0.Observer)[0:20],
        'Agency': (<c1*>&sb0.Agency)[0:40],
        'RxSerialNumber': (<c1*>&sb0.RxSerialNumber)[0:20],
        'RxName': (<c1*>&sb0.RxName)[0:20],
        'RxVersion': (<c1*>&sb0.RxVersion)[0:20],
        'AntSerialNbr': (<c1*>&sb0.AntSerialNbr)[0:20],
        'AntType': (<c1*>&sb0.AntType)[0:20],
        'deltaH': sb0.deltaH,
        'deltaE': sb0.deltaE,
        'deltaN': sb0.deltaN,
        'MarkerType': (<c1*>&sb0.MarkerType)[0:20],
        'GNSSFWVersion': (<c1*>&sb0.GNSSFWVersion)[0:40],
        'ProductName': (<c1*>&sb0.ProductName)[0:40],
        'Latitude': sb0.Latitude,
        'Longitude': sb0.Longitude,
        'Height': sb0.Height,
        'StationCode': (<c1*>&sb0.StationCode)[0:10],
        'MonumentIdx': sb0.MonumentIdx,
        'ReceiverIdx': sb0.ReceiverIdx,
        'CountryCode': (<c1*>&sb0.CountryCode)[0:3],
    }

    return block_dict

BLOCKPARSERS['ReceiverSetup'] = ReceiverSetup_toDict

def RxMessage_toDict(c1 * data):
    cdef RxMessage * sb0 = <RxMessage *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'Type': sb0.Type,
        'Severity': sb0.Severity,
        'MessageID': sb0.MessageID,
        'StringLn': sb0.StringLn,
        'Reserved2': (<c1*>&sb0.Reserved2)[0:2],
        'Message': (<c1*>&sb0.Message)[0:sb0.StringLn],
    }

    return block_dict

BLOCKPARSERS['RxMessage'] = RxMessage_toDict

def Comment_toDict(c1 * data):
    cdef Comment * sb0 = <Comment *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'CommentLn': sb0.CommentLn,
        'Comment': (<c1*>&sb0.Comment)[0:sb0.CommentLn],
    }

    return block_dict

BLOCKPARSERS['Comment'] = Comment_toDict

def BBSamples_toDict(c1 * data):
    cdef BBSamples * sb0 = <BBSamples *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'N': sb0.N,
        'Info': sb0.Info,
        'Reserved': (<c1*>&sb0.Reserved)[0:3],
        'SampleFreq': sb0.SampleFreq,
        'LOFreq': sb0.LOFreq,
        'Samples': (<c1*>&sb0.Samples)[0:sb0.N * 2],
    }

    return block_dict

BLOCKPARSERS['BBSamples'] = BBSamples_toDict

def ASCIIIn_toDict(c1 * data):
    cdef ASCIIIn * sb0 = <ASCIIIn *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'CD': sb0.CD,
        'Reserved1': (<c1*>&sb0.Reserved1)[0:3],
        'StringLn': sb0.StringLn,
        'SensorModel': (<c1*>&sb0.SensorModel)[0:20],
        'SensorType': (<c1*>&sb0.SensorType)[0:20],
        'Reserved2': (<c1*>&sb0.Reserved2)[0:20],
        'ASCIIString': (<c1*>&sb0.ASCIIString)[0:sb0.StringLn],
    }

    return block_dict

BLOCKPARSERS['ASCIIIn'] = ASCIIIn_toDict

def EncapsulatedOutput_toDict(c1 * data):
    cdef EncapsulatedOutput * sb0 = <EncapsulatedOutput *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'Mode': sb0.Mode,
        'Reserved': sb0.Reserved,
        'N': sb0.N,
        'ReservedId': sb0.ReservedId,
        'Payload': sb0.Payload,
    }

    return block_dict

BLOCKPARSERS['EncapsulatedOutput'] = EncapsulatedOutput_toDict

def ISMR_toDict(c1 * data):
    cdef ISMR * sb0 = <ISMR *>data

    block_dict = {
        'TOW': sb0.TOW,
        'WNc': sb0.WNc,
        'N': sb0.N,
        'SBLength': sb0.SBLength,
        'Reserved': sb0.Reserved,
        'N_MSB': sb0.N_MSB,
    }

    sub_block_list = []
    cdef ISMRChannel subblock
    cdef size_t i = sizeof(ISMR)
    for _ in xrange(sb0.N):
        subblock = (<ISMRChannel*>(data + i))[0]
        i += sb0.SBLength

        sub_block_dict = {
            'RXChannel': subblock.RXChannel,
            'Type': subblock.Type,
            'SVID': subblock.SVID,
            'Reserved': subblock.Reserved,
            'S4': subblock.S4,
            'SigmaPhi': subblock.SigmaPhi,
        }
        sub_block_list.append(sub_block_dict)
    block_dict['ISMRChannel'] = sub_block_list

    return block_dict

BLOCKPARSERS['ISMR'] = ISMR_toDict