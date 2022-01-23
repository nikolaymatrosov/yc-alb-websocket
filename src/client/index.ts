import {io} from "socket.io-client";

const {URL} = process.env
const socket = io(URL, {
    transports: ["websocket"]
});

socket.on("connect", () => {
    console.log(`connect ${socket.id}`);
});

socket.on("disconnect", () => {
    console.log(`disconnect`);
});

socket.on("severInfo", (...args) => {
    console.log(`severInfo`, args);
});

function ping() {
    const start = Date.now();
    socket.emit("ping", () => {
        console.log(`pong (latency: ${Date.now() - start} ms)`);
    });
    setTimeout(ping, 2000 - Math.random() * 1000)
}

ping();
