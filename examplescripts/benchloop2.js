function tf(){
  trace('Benchmarking function code empty loop...');
  var st=(new Date()).valueOf();
  var i=0;
  while(i++<400000);
  var et=(new Date()).valueOf();
  trace(et-st,' milliseconds');
  trace('');
}

trace('Benchmarking global code empty loop...');
var st=(new Date()).valueOf();
var i=0;
while(i++<400000);
var et=(new Date()).valueOf();
trace(et-st,' milliseconds');
trace('');

tf();
