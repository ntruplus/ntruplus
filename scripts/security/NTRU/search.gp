/* Binary search on a non-decreasing function  */

MaxLT(f, target, low, high) = {
  my(mp);
  if(low >= high-1, return(low));
  mp = ceil((low+high)/2);
  if(f(mp) <= target,
    MaxLT(f, target, mp, high),
    MaxLT(f, target, low, mp));
}
addhelp(MaxLT,\
"MaxLT((x)->f(x), target, low, high): "\
"f(x) non-decreasing; finds maximum x such that f(x) <= target ");
