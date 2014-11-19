function searchPrimes(from,to){
  var sqrt=Math.sqrt,vfrom=+from,vto=+to,primes=0,n=0,i=0,j=0,isPrime=0;
  for(n=vfrom;n<=vto;++n,primes+=isPrime)for(i=+(((n%2)==0)?2:3),j=+sqrt(n),isPrime=1;i<=j;i+=2)if((n%i)==0){isPrime=0;break;}
  return primes;
}
function benchit(){ 
  var datenow=Date.now;
  var st=datenow();
  var count=searchPrimes(1,262144);
  var et=datenow();
  trace("Count of found primes between 1 and 262144: "+count);
  trace((et-st)+" ms");
}
benchit();
