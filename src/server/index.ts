import * as express from "express";
import {createServer} from "http";

import * as os from "os";
import {Server} from "socket.io";

const PORT = parseInt(process.env.PORT, 10);
const app = express();
const httpServer = createServer(app);
const io = new Server(httpServer);

const clients = {}

io.on("connect", (socket) => {
    console.log(`connect ${socket.id}`);
    clients[socket.id] = 0;
    socket.on("ping", (cb) => {
        clients[socket.id] += 1
        console.log(`ping client ${socket.id}, msg number ${clients[socket.id]}`);
        cb();
    });

    // Что наглядно убедиться, что мы подключились к разным бэкендам пошлем после коннекта hostname.
    // Так как приложение будет бежать в контейнере, тут вы полчучите строку типа `9852d1c3d57c`.
    socket.emit("severInfo", os.hostname())

    socket.on("disconnect", () => {
        console.log(`disconnect ${socket.id}`);
    });
});

// Этот эндпоинт добавлен просто для того чтобы на него можно повесть health check балансера
app.get("/", (req, res) => {
    res.status(200).send({"ping": "OK"});
})

httpServer.listen(PORT)
