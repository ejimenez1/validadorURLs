//Librerias externas que son utilizadas por el gestor de solicitudes
var express = require('express');
var bodyParser = require('body-parser');
const http = require('http');
var requestor = require('./gestor_urls.js');

//Inicializacion de servidor express
var app = express();
const port = 3000;

//Inicializacion del servicio de parseo de estructuras JSON
var jsonParser = bodyParser.json()


app.post('/gestor_solicitudes.js', jsonParser,function (req, res) {
// Se obtiene el body de la solicitud HTTP
  var payload = req.body;
//  console.log(payload);

  // Se consume el servicio de clasificacion
 requestor.sendRequest(payload,function(response){

//Se devuelve la respuesta a la extension de navegador
//console.log(response)
  res.send(response);
 });

});

//Permite al servicio mantenerse en "Escucha"
app.listen(port, function () {
  console.log('Servidor en ejecucion.....');

});
