from math import log
from Kyber_failure import p2_cyclotomic_error_probability
from MLWE_security import MLWE_summarize_attacks, MLWEParameterSet
from proba_util import build_mod_switching_error_law

class KyberParameterSet:
    def __init__(self, n, m, ks, ke,  q, rqk, rqc, rq2, ke_ct=None):
        if ke_ct is None:
            ke_ct = ke
        self.n = n
        self.m = m
        self.ks = ks     # binary distribution for the secret key
        self.ke = ke    # binary distribution for the ciphertext errors
        self.ke_ct = ke_ct    # binary distribution for the ciphertext errors
        self.q = q
        self.rqk = rqk  # 2^(bits in the public key)
        self.rqc = rqc  # 2^(bits in the first ciphertext)
        self.rq2 = rq2  # 2^(bits in the second ciphertext)


def Kyber_to_MLWE(kps):
    if kps.ks != kps.ke:
        raise "The security script does not handle different error parameter in secrets and errors (ks != ke) "

    # Check whether ciphertext error variance after rounding is larger than secret key error variance
    Rc = build_mod_switching_error_law(kps.q, kps.rqc)
    var_rounding = sum([i*i*Rc[i] for i in Rc.keys()])

    if kps.ke_ct/2. + var_rounding < kps.ke/2.:
        raise "The security of the ciphertext MLWE may not be stronger than the one of the public key MLWE"    

    return MLWEParameterSet(kps.n, kps.m, kps.m + 1, kps.ks, kps.q)


def communication_costs(ps):
    """ Compute the communication cost of a parameter set
    :param ps: Parameter set (ParameterSet)
    :returns: (cost_Alice, cost_Bob) (in Bytes)
    """
    A_space = 256 + ps.n * ps.m * log(ps.rqk)/log(2)
    B_space = ps.n * ps.m * log(ps.rqc)/log(2) + ps.n * log(ps.rq2)/log(2)
    return (int(round(A_space))/8., int(round(B_space))/8.)


def summarize(ps):
    print ("params: ", ps.__dict__)
    print ("com costs: ", communication_costs(ps))
    F, f = p2_cyclotomic_error_probability(ps)
    print ("failure: %.1f = 2^%.1f"%(f, log(f + 2.**(-300))/log(2)))


if __name__ == "__main__":

    #Analyses
    print("NTRUPLUS")
    print ("--------------------")
    print ("security:")
#    ps = MLWEParameterSet(512, 1, 1, 1, 3329, distr="binomial")
#    MLWE_summarize_attacks(ps)


    print(3457)
    ps = MLWEParameterSet(1024, 1, 1, 1, 3457, distr="binomial")
    MLWE_summarize_attacks(ps)



#    print(3889)
#    ps = MLWEParameterSet(864, 1, 1, 1, 3889, distr="binomial")
#    MLWE_summarize_attacks(ps)




#    ps = MLWEParameterSet(648, 1, 1, 1, 3329, distr="binomial")
#    MLWE_summarize_attacks(ps)

#    ps = MLWEParameterSet(768, 1, 1, 1, 3457, distr="binomial")
#    MLWE_summarize_attacks(ps)
    #summarize(ps)
#    print ()

