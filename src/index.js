var Elm = require("./elm/Main.elm");
require("./css/main.scss");
var mountNode = document.getElementById("app");
var app = Elm.Main.embed(mountNode);
