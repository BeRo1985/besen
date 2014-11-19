function bench(){
  var i=0,k=0,d=0,date=Date.now;
  for(var j=0;j<16;j++){
    for(i=0,d=+date();(+date())===d;i++);
    k=(k<i)?i:k;
  }
  return k;
}

trace("Equal dates created in loop: "+bench());
