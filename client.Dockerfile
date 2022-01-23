FROM node:17

WORKDIR /usr/src/app
COPY package*.json ./

RUN npm install
COPY dist/client .

CMD [ "node", "index.js" ]
