
var MeineZahl=Math.floor(Math.random()*100);
trace("Psst, die Zahl ist ", MeineZahl);

var DeinName=prompt("Bitte gebe deinen Namen ein:","");
var DeineZahl=parseInt(prompt("Hallo "+DeinName+". Bitte gebe nun eine Zahl zwischen 0 und 100 ein:",""));
while(1){
  if((DeineZahl===undefined)||(DeineZahl<0)||(DeineZahl=="")){
    trace(DeineZahl);
    break;
  }else if(MeineZahl<DeineZahl){
    DeineZahl=parseInt(prompt("Meine Zahl ist kleiner!",""));
  }else if(MeineZahl>DeineZahl){
    DeineZahl=parseInt(prompt("Meine Zahl ist groesser!",""));
  }else{
    alert("Gut gemacht ",DeinName,", du hast richtig geraten! Meine Zahl war ",MeineZahl,".");
    break;
  }
}