FROM node:17

WORKDIR /usr/src/app
COPY package*.json ./

RUN npm install
COPY dist/server .

EXPOSE $PORT

CMD [ "node", "index.js" ]
