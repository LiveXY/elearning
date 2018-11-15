process.stdin.resume()
process.stdin.setEncoding('utf8')

var cmd = {
    login: 10000,
    laba: 10001
}

process.stdin.on( 'data', function( data ) {
    var body = JSON.parse(data);
    switch(body.cmd) {
        case cmd.login:
            process.stdout.write(JSON.stringify({ cmd: cmd.login, data: { ret: 0 } }) + '\n')
            break;
    }
})


//websocketd --port=3000 node wsd-server-script.js
