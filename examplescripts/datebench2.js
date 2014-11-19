function bench(){
  "use strict"
  var i=0,k=0,d=0;
  for(var j=0;j<16;j++){
    for(i=0,d=+Date.now();(+Date.now())===d;i++);
    k=(k<i)?i:k;
  }
  return k;
}

trace("Equal dates created in loop: "+bench());
