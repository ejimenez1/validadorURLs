/**************

                                          GESTOR DE URLs

Este componente se encarga de recibir las solicitudes generadas por la extension de navegador recibidas
atraves del Gestor de Solicitudes y consumir los servicios deterministicos y probabilisticos para determinar
si cada una de las URLs recibidas son o no maliciosas
***************
*/


var queryBuilder = {};

// Definicion de funcion
queryBuilder.sendRequest = function(data,callback){

//  var request = require('sync-request');
var out = "none";
var google_data = "";
var data_results = "";
call_google_service(data ,out, function( res ) {
     google_data = res;
     data_results = updatePayload(data,google_data.matches,"Google Safe Browsing");

     return callback(data_results);
} );


}
function updatePayload(payload,results,src){

//  for(var i = 0; i < results.length;i++){
if(results != undefined){


      for(var i in results){
    //  console.log(results[i]);
        var url = results[i].threat.url;

        payload[url][1] = 'Bad';
        payload[url].push(src);
        payload[url].push(results[i].threatType);
    }
  }
  return payload;
}

function call_google_service(data,res,callback){
  var request = require('request');

  var keys = [];
  var obj;
  for(var k in data){
    obj = {"url": k}
    keys.push(obj);
  }

  /// Construccion del payload que se enviara al servicio de Google Safe Browsing
    var payload = {
        "client": {
          "clientId":      "Detector URLs Maliciosos",
          "clientVersion": "1.0"
        },
        "threatInfo": {
          "threatTypes":      ["MALWARE", "SOCIAL_ENGINEERING","UNWANTED_SOFTWARE","POTENTIALLY_HARMFUL_APPLICATION"],
          "platformTypes":    ["WINDOWS"],
          "threatEntryTypes": ["URL"],
          "threatEntries": keys
        /*  [
            {"url": "http://malware.testing.google.test/testing/malware/"},
            {"url": "http://4erta.ru"},
            {"url": "http://www.google.com/"}
          ]*/

        }
      };

      var headers = {
          'User-Agent':       'Super Agent/0.0.1',
          'Content-Type':     'application/json'
      }

      // Configure the request
      var options = {
          url: 'https://safebrowsing.googleapis.com/v4/threatMatches:find?key=AIzaSyBwX-IQT1ICiovQZ5Kq6lwr1weUPuv9eMw',
          method: 'POST',
          headers: headers,
          body: payload,
          json: true
      }

      // Se realiza la solicitud POST al servicio de Google Safe Browsing
    request(options, function (error, response, body) {

          if (!error && response.statusCode == 200) {

              console.log(body.matches);
              return  callback(body);
          }
          else{
            console.log(error + '\n' + response);
          }
      })
}

// Se publica el componente para que pueda ser utilizado externamente por el Gestor de Solicitudes
module.exports = queryBuilder;
