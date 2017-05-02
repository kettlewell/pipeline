//client.js
var io = require('socket.io-client');
var socket = io.connect('http://localhost:3000', {reconnect: true});
const util = require('util')

var SAR = require('resmon');
var daemon = new SAR(1);

cpu_stat = {};

daemon.on('cpu', function(stat) {
    console.log(stat['%usr'][0]);
    cpu_stat = stat;
    socket.emit('CH01', 'CPU_USER', cpu_stat['%usr'][0]);
    //display CPU utilization percentage (at user level) for all CPUs
    //usually the first row contains aggregated (sum, avg, etc.) values
});

daemon.start();

// try an intervaltimer...
var interval = setInterval(function () {
        socket.emit('CH01', 'CPU_STAT', cpu_stat);
}, 1000);

// Add a connect listener
socket.on('connect', function (socket) {
    console.log('Connected!');

});

socket.on('s_ping', function (from,msg){
    console.log('You have a message from', from, 'that says: ', msg);
});

socket.on("disconnect", function () {
    clearInterval(interval);
});

socket.on('reconnect', function (socket) {
    console.log('reConnected!');

});

socket.on('reconnecting', function (socket) {
    console.log('reConnecting!');

});
