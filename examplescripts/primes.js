function isPrime(n){
  if(isNaN(n))return(NaN);
  for(var i=(n%2)==0?2:3,j=Math.sqrt(n);i<=j;i+=2)if((n%i)==0)return(false);
  return(true);
}
function searchPrimes(from,to){
  for(var i=from;i<=to;i++)if(isPrime(i))trace(i);
}
searchPrimes(1,2048);