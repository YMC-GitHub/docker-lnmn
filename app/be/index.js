var http = require("http");
var server = new http.Server();

server.on("request", function (req, res) {
  res.writeHead(200, {
    "content-type": "text/plain"
  });
  res.write("hello nodejs");
  res.end();
});
server.listen(3000);