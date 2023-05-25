read("estimate.gp")

cbdMod3(k) = {
  my(p);
  p = floor(2^(2*k)/3);
  [p, p+1, p]/2^(2*k);
};

cbd(k) = { vector(2*k+1, i, binomial(2*k, i-1))/2^(2*k) };

cUnif(k) = { vector(k, i, 1/k) };

fixedWtTri(n,d) = { [d/n, 1-2*d/n, d/n]; }

tailcutDG(t, s) = {
  my(v);
  v = vector(2*t+1, i, j = (t-i+1); exp(-j^2/(2*s^2)));
  v /= vecsum(v);
}

fixedWtDG(n,t,s) = {
  my(v);
  v = tailcutDG(t,s);
  v = round(n*v);
  v[t+1] += n - vecsum(v); /* add zeros */
  v /= n;
}

min_q_hrss(n,p,wtf,wtg,wtr) = {
  \\ Min q for NTRU-HRSS. Weight parameters wtf,wtg, wtf set
  \\ percentage of non-zero coefficients in f, g, and r.
  \\ All coefficients are assumed to be of worst-case magnitude, floor(p/2).
  ngr = floor(p/2)^2 * (n-1) * sqrt(wtg*wtr);
  nfm = floor(p/2)^2 * (n-1) * sqrt(wtf*1);
  q = ceil(2*sqrt(2)*(p*ngr + nfm));
};

min_q_ntru(n,p,wtf,wtg,wtr,wtm) = {
  \\ Min q for NTRU with g(0) = 0 and m(0) = 0.
  \\ Each of f,g,r,m assumed to be of degree at most n-2.
  \\ f has 2-norm sqrt(wtf*(n-1)), etc.
  \\ NOTE: May be able to do better using l_1*l_inf bound
  \\ when p > 3 and good l_1 bound is known.
  ngr = floor(p/2)^2 * (n-1) * sqrt(wtg*wtr);
  nfm = floor(p/2)^2 * (n-1) * sqrt(wtf*wtm);
  q = ceil(2*(p*ngr + nfm));
};

/* Functions with terse output (for gen_param_data.gp) */

data_hrss_pow2q(n,costfn,hybrid=0) = {
  \\ NOTE: Assumes trinary distribution [5/16,6/16,5/16]
  my(q,coeffDist,cost,size);
  q = 2^ceil(log2(min_q_hrss(n,3,1,1,1)));
  size = 2*ceil((n-1)*log2(q)/8);
  coeffDist = cbdMod3(2);
  if(hybrid,
    cost = floor(RunHybrid(n-1, n-1, q, coeffDist, costfn)),
    cost = floor(RunPrimal(n-1, n-1, q, coeffDist, costfn, 1)));
  [n,q,1,cost,size];
};

data_hrss_primeq(n,costfn,hybrid=0) = {
  \\ NOTE: Assumes trinary distribution [5/16,6/16,5/16]
  my(q,coeffDist,cost,size);
  q = nextprime(min_q_hrss(n,3,1,1,1));
  while(!polisirreducible(Mod(polcyclo(n),q)), q = nextprime(q+1));
  coeffDist = cbdMod3(2);
  size = 2*ceil((n-1)*log2(q)/8);
  if(hybrid,
    cost = floor(RunHybrid(n-1, n-1, q, coeffDist, costfn)),
    cost = floor(RunPrimal(n-1, n-1, q, coeffDist, costfn, 1)));
  [n,q,1,cost,size];
};

data_hrss_pow2q_fixedwt(n,wt,costfn,hybrid=0) = {
  my(q,coeffDist,cost,size);
  q = 2^ceil(log2(min_q_hrss(n,3,wt,wt,wt)));
  coeffDist = fixedWtTri(n, floor(wt*(n-1)/2));
  size = 2*ceil((n-1)*log2(q)/8);
  if(hybrid,
    cost = floor(RunHybrid(n-1, n-1, q, coeffDist, costfn)),
    cost = floor(RunPrimal(n-1, n-1, q, coeffDist, costfn, 1)));
  [n,q,wt,cost,size];
};

data_hrss_primeq_fixedwt(n,wt,costfn,hybrid=0) = {
  my(q,coeffDist,cost,size);
  q = nextprime(min_q_hrss(n,3,wt,wt,wt));
  while(!polisirreducible(Mod(polcyclo(n),q)), q = nextprime(q+1));
  size = 2*ceil((n-1)*log2(q)/8);
  coeffDist = fixedWtTri(n, floor(wt*(n-1)/2));
  if(hybrid,
    cost = floor(RunHybrid(n-1, n-1, q, coeffDist, costfn)),
    cost = floor(RunPrimal(n-1, n-1, q, coeffDist, costfn, 1)));
  [n,q,wt,cost,size];
};

data_hrss_primeq_unifp(n,p,costfn,hybrid=0) = {
  \\ NOTE: assumes uniform mod p
  my(q,coeffDist,cost,size);
  q = nextprime(min_q_hrss(n,p,1,1,1));
  while(!polisirreducible(Mod(polcyclo(n),q)), q = nextprime(q+1));
  coeffDist = cUnif(p);
  size = 2*ceil((n-1)*log2(q)/8);
  if(hybrid,
    cost = floor(RunHybrid(n-1, n-1, q, coeffDist, costfn)),
    cost = floor(RunPrimal(n-1, n-1, q, coeffDist, costfn, 1)));
  [n,q,1,cost,size];
};

data_ntru_pow2q(n,wt,costfn,hybrid=0) = {
  my(q,coeffDist,cost,size);
  q = 2^ceil(log2(min_q_ntru(n,3,wt,wt,wt,wt)));
  coeffDist = fixedWtTri(n, floor(wt*(n-1)/2));
  size = 2*ceil((n-1)*log2(q)/8);
  if(hybrid,
    cost = floor(RunHybrid(n-1, n-1, q, coeffDist, costfn)),
    cost = floor(RunPrimal(n-1, n-1, q, coeffDist, costfn, 1)));
  [n,q,wt,cost,size];
};

data_hps_fixedq_fatf(n,q,costfn,hybrid=0) = {
  my(wt,coeffDist,cost,size);
  wt = min(2/3, (q/12 - 2)/(n-1));
  coeffDist = fixedWtTri(n, floor(wt*(n-1)/2));
  size = 2*ceil((n-1)*log2(q)/8);
  if(hybrid,
    cost = floor(RunHybrid(n-1, n-1, q, coeffDist, costfn)),
    cost = floor(RunPrimal(n-1, n-1, q, coeffDist, costfn, 1)));
  [n,q,wt,cost,size];
};

data_hps_fixedq(n,q,costfn,hybrid=0) = {
  my(wt,coeffDist,cost,size);
  wt = min(2/3, (q/8 - 2)/(n-1));
  coeffDist = fixedWtTri(n, floor(wt*(n-1)/2));
  size = 2*ceil((n-1)*log2(q)/8);
  if(hybrid,
    cost = floor(RunHybrid(n-1, n-1, q, coeffDist, costfn)),
    cost = floor(RunPrimal(n-1, n-1, q, coeffDist, costfn, 1)));
  [n,q,wt,cost,size];
};

data_ntru_primeq(n,wt,costfn,hybrid=0) = {
  my(q,coeffDist,cost,size);
  q = nextprime(min_q_ntru(n,3,wt,wt,wt,wt));
  while(!polisirreducible(Mod(polcyclo(n),q)), q = nextprime(q+1));
  size = 2*ceil((n-1)*log2(q)/8);
  coeffDist = fixedWtTri(n, floor(wt*(n-1)/2));
  if(hybrid,
    cost = floor(RunHybrid(n-1, n-1, q, coeffDist, costfn)),
    cost = floor(RunPrimal(n-1, n-1, q, coeffDist, costfn, 1)));
  [n,q,wt,cost,size];
};

data_sntrup(n,q,t,costfn,hybrid=0) = {
  my(coeffDist,cost,size);
  coeffDist=fixedWtTri(n,t);
  size = ceil(n*log2(q)/8)+ceil(n*log2(q/3)/8);
  if(hybrid,
    cost = floor(RunHybrid(n, n, q, coeffDist, costfn)),
    cost = floor(RunPrimal(n, n, q, coeffDist, costfn, 1)));
  [n,q,2*t,cost,size];
};

data_ees(n,q,d,costfn,hybrid=0) = {
  my(coeffDist,cost,size);
  size = 2*ceil(n*log2(q)/8);
  coeffDist = fixedWtTri(n, d);
  if(hybrid,
    cost = floor(RunHybrid(n, n, q, coeffDist, costfn)),
    cost = floor(RunPrimal(n, n, q, coeffDist, costfn, 1)));
  [n,q,d,cost,size];
};

/* Functions with verbose output (for humans) */

NTRUHRSS(n) = {
  my(q,coeffDist);
  q = 2^ceil(3.5 + log2(n));
  coeffDist = cbdMod3(2);
  Run(n-1, n-1, q, coeffDist);
}

NTRUHPS(n,q) = {
  my(t,coeffDist);
  t = q/16 - 1;
  coeffDist = fixedWtTri(n, t);
  Run(n-1, n-1, q, coeffDist);
}

NTRUPLUS(n) = {
  my(q,coeffDist);
  q = 3457;
  coeffDist = cbdMod3(1);
  Run(n, n, q, coeffDist);
}

NTRUEES(n,q,t) = { Run(n, n, q, fixedWtTri(n,t), usvp=1); }
NTRUPrime(n,q,t) = { Run(n, n, q, fixedWtTri(n,t), usvp=1); }

run() = {
  print("==================NTRU+576===========================");  
  NTRUPLUS(576);
  print("\n");
  print("==================NTRU+768===========================");
  NTRUPLUS(768);
  print("\n");
  print("==================NTRU+864===========================");
  NTRUPLUS(864);
  print("\n");
  print("==================NTRU+1152===========================");
  NTRUPLUS(1152);
}

run();
quit();
