function tf(){
  trace('Benchmarking function code empty loop...');
  var st=(new Date()).valueOf();
  for(var i=0;i<400000;i++){
  }
  var et=(new Date()).valueOf();
  trace(et-st,' milliseconds');
  trace('');
}

trace('Benchmarking global code empty loop...');
var st=(new Date()).valueOf();
for(var i=0;i<400000;i++){
}
var et=(new Date()).valueOf();
trace(et-st,' milliseconds');
trace('');

tf();
