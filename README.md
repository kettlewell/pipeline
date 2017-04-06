# pipeline

I dream of being a real-time streaming pipeline demo when I grow up...


# GOALS

My goals are to use this project to create a real-time
streaming application inside Docker containers using the
following technologies and workflows:

1. Input data stream, starting with the output from something like vmstat, or similar
2. Kafka to buffer the messages
3. Spark Streaming to handle streaming data into Spark
4. Spark for distributed computations
5. Cassandra ( or other persistant storage ) to hold the output
6. Node.js Server needed for angular
7. Angular for enhanced web frameworks
8. D3.js to display realtime visualizations
9. Socket.IO for direct to d3.js real-time data.


# NOTES

## Angular2

npm install needs to be run *outside* of the Dockerfile first when using
persistant storage the way I am

I *think* I need to modify the file structure so that when `npm install` is run
from Dockerfile, it isn't getting overwritten by my bind mount to the host system

In any case, this is the history that seems to be working at this point:

``` shell
npm cache clean
npm install
docker build -t kettlewell:angular2 .
docker run -it -p 3000:3000 -p 3001:3001 \
       -v /Users/mkettlewell/git/pipeline/angular2/:/angular2/ \
       --name ng2 kettlewell:angular2
```
Next steps:
1. decouple `npm install` from the host system
2. get this working with docker-compose.yml
