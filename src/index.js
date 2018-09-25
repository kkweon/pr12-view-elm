import 'bootstrap';

var global = require('./elm/Main.elm');
require('./css/main.scss');
var mountNode = document.getElementById('app');
var app = global.Elm.Main.init({
  node: mountNode,
  flags: 0,
});
