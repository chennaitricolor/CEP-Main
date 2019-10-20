FROM node:10

WORKDIR /opt/app

COPY package*.json ./
RUN npm install --production

COPY ./ ./

ENTRYPOINT node index.js
EXPOSE 80