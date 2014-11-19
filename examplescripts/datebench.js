function bench(){
  var i,k=0,d;
  for(var j=0;j<16;j++){
    for(i=0,d=+(new Date());(+(new Date()))===d;i++);
    k=Math.max(k,i);
  }
  return k;
}

trace("Equal dates created in loop: "+bench());
