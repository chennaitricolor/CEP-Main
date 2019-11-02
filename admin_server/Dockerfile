FROM node:10-alpine

WORKDIR /opt/app

COPY package*.json ./
RUN npm install --production

COPY ./ ./

ENTRYPOINT node index.js
EXPOSE 80
