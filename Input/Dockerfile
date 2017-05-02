FROM node:7.8

RUN mkdir /socket.io
WORKDIR /socket.io

COPY socket.io/package.json /socket.io

RUN npm install

COPY ./socket.io /socket.io

#EXPOSE 3000
#EXPOSE 3001

CMD ["npm","start"]
