\\ BKZ simulator.
\\ usage: simulate( dimension, blocksize, target hermite factor )
\\  simulates BKZ-blocksize on a unit volume lattice to which BKZ-20
\\  has been applied as preprocessing.
\\ returns ["success"/"failure", achieved hermite factor, # of rounds required ]

proj(u, v) = {
  (u~ * v)/(u~ * u) * u;
}

gs(M) = {
  my(M2);
  M2 = matconcat([M[,1], M[,2] - proj(M[,1], M[,2])]);
  for(j=3, #M, M2 = matconcat([M2, M[,j] - vecsum(vector(j-1, i, proj(M2[,i], M[,j])))]));
  M2;
}

\\ Disabling this because I haven't tested it recently.
\\
\\  randhkz(d) = { \\ Requires bash, fplll, fp2gp script
\\    my(B,Bgs,Bgn,vs);
\\    system(Strprintf("/bin/bash -c \"latticegen -randseed 'time' u %d 16 | fplll -a bkz -b %d | ./fp2gp > randhkz\"", d,d));
\\    B = read("./randhkz");
\\    Bgs = gs(B~);
\\    Bgn = vector(#Bgs, i, log(sqrt(norml2(Bgs[,i]))));
\\    vs = vecsum(Bgn)/#Bgs;
\\    Bgn = vector(#Bgs, i, Bgn[i] - vs);
\\  }
\\
\\ Here's the fp2gp script:
\\
\\ #!/bin/bash
\\ cat - | sed 's/\[\(.*\)\]/\1; /g' | sed 's/ /, /g' | sed 's/, ;,/;/g' | sed ':a;N;$!ba;s/\n/ /g' | sed 's/;\s*\]/]/g'
\\

simdata(really=0) = {
  my(V, count, d);
  d = 50; \\ Dimension of lattices to HKZ reduce
  count = 100; \\ Number of HKZ reduced GS norms to average over
  V = vector(d);
  if(really,
    printf("Feature disabled.\n"),
    \\ for(i=1,count,V+=randhkz(d));
    \\ V/count,
    \\ average log(gram schmidt norm) over 100 HKZ reduced bases of dim 50 lattices
    [0.4809337322749968, 0.4889068929146757, 0.4629910732303647, 0.4384921120061095, 0.4198271756529734,
    0.3940124751357192, 0.3793579556691379, 0.3552017168415738, 0.3375032857978846, 0.3229996676156046,
    0.3103169826524305, 0.2978627511364960, 0.2828082600293407, 0.2685092222965025, 0.2470246073218571,
    0.2345601366183950, 0.2236298423327614, 0.2026125221670087, 0.1833511717333619, 0.1635239915325074,
    0.1460909610754462, 0.1239402813211751, 0.1033442833745716, 0.08072183355489210, 0.05747352858422083,
    0.03615285314640355, 0.009734731674006085, -0.01314276679308946, -0.03859536413875225, -0.06166664730992491,
    -0.08732858253410711, -0.1159733213895935, -0.1395873057069733, -0.1685959449423031, -0.2009987452911466,
    -0.2272943479144534, -0.2548892487960738, -0.2845907037340676, -0.3130406180111631, -0.3439519155213564,
    -0.3729166620199606, -0.4037203497626708, -0.4279121623225402, -0.4591242077605871, -0.4851668230787535,
    -0.5069333755274962, -0.5312523582495852, -0.5480002333962808, -0.5470408985906416, -0.5201614648988958]);
}

lnGH(k) = {
  (1/k) * lngamma(k/2 + 1) - 1/2 * log(Pi);
}
addhelp(lnGH,\
"lnGH(k): ln of expected first minima of a "\
"unit determinant lattice of rank k under the "\
"gaussian heusritic.");

deltaGH(k) = {
  exp(lnGH(k)/(k-1));
}
addhelp(deltaGH,\
"deltaGH(k): root Hermite factor of BKZ-k using Gaussian Heuristic");

simulate(N, beta, target, abort=20) = {
  my(r,c,d,ll,vs,llp,R,phi,f,logV);
  if(beta < 50, return(0));
  r = simdata(0);
  c = vector(beta);
  for(d=51, #c, c[d] = lnGH(d));

  \\ Start with BKZ-20 preprocessing.
  ll = vector(N, i, (N-2*(i-1))*log(1.01263));
  vs = vecsum(ll)/N;
  for(i=1,N,ll[i] -= vs);
  llp = vector(N);

  R = 0;
  while(exp(ll[1]/N) > target && R < abort,
    phi = 1;
    for(k=1, N-50,
      d = min(beta,N-k+1);
      f = min(k+beta, N);
      logV = sum(i=1,f,ll[i]) - sum(i=1,k-1,llp[i]);
      if(phi,
          if(logV/d + c[d] < ll[k],
            llp[k] = logV/d + c[d];
            phi = 0),
          llp[k] = logV/d + c[d]);
      );
    logV = vecsum(ll) - vecsum(llp[1..(N-50)]);
    for(k=1, 50, llp[N-50+k] = logV/50 + r[k]);
    ll = llp;
    R += 1;
    if(phi, return(["failure", exp(ll[1]/N), R])));
  if(R >= abort, return(["failure", exp(ll[1]/N), R]));
  ["success", exp(ll[1]/N), R];
}



\\ HKZ-45 data
    \\[0.4433760414698716, 0.4495907808129495, 0.4391257536523596, 0.4213762001964290, 0.3989197304391247,
    \\ 0.3788181216378071, 0.3584955583666477, 0.3366383642705680, 0.3166197443547074, 0.3011340258551381,
    \\ 0.2836639652776060, 0.2627109646728308, 0.2454797744816443, 0.2255107944087964, 0.2025255542234799,
    \\ 0.1852757131117739, 0.1659804389646344, 0.1411536637448854, 0.1268493401408390, 0.1045106895608172,
    \\ 0.07831352839541140, 0.05840022654467995, 0.02827585971737392, 0.005793962810872525, -0.01542095618294966,
    \\-0.04260971363254789, -0.06879486130454147, -0.09881256624064685, -0.1215688487597410, -0.1487176430821304,
    \\-0.1742843841197708, -0.2057280999506363, -0.2353566135821266, -0.2658832485751396, -0.2964138959753004,
    \\-0.3197238571885748, -0.3444913818714006, -0.3791349066328286, -0.4046843406753401, -0.4336482556110438,
    \\-0.4564278173750421, -0.4861882523245693, -0.5031937364886837, -0.5016318772260507, -0.4558235403121828]);
