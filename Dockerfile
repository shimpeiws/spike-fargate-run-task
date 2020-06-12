FROM node:12

WORKDIR /app

COPY ./src .

RUN npm install

CMD [ "node", "hello.js" ]
