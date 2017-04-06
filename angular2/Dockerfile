FROM node:7.8

RUN apt-get update

WORKDIR /angular2
COPY . /angular2

#RUN watchman watch-del-all
RUN npm cache clean
RUN npm install

CMD ["npm","start"]
