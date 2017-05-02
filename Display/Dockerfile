FROM node:7.8

RUN mkdir /angular2
WORKDIR /angular2

COPY angular2/package.json /angular2

RUN npm install

COPY ./angular2 /angular2

EXPOSE 3000
EXPOSE 3001

CMD ["npm","start"]


##############################
#FROM node:7.8

#RUN apt-get update

#WORKDIR /angular2
#COPY . /angular2

###RUN watchman watch-del-all
#RUN npm cache clean
#RUN npm install

#CMD ["npm","start"]
