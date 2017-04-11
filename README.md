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
1. decouple `npm install` from the host system -- DONE?
2. get this working with docker-compose.yml -- DONE
3. Create a script that can run all the tests
   + socket.io
   + real-time spark
   + regular spark
   Just a simple script
4. Pull in images for the following, and understand how each works / connects:
   + kafka
   + spark
   + cassandra
   + socket.io
5. Create dev/prod environments for how the code gets mounted
   IE. mount host system in dev, don't mount it in prod
       prod would be for end-users, dev would be for testing/building this pipeline
   EDIT: Just get a dev environment going for now...


To further refine the above:

1. First get socket.io -> angular2 working

2. After that get the kafka -> spark -> file -> angular2 working

3. Then get kafka -> spark -> cassandra -> angular2 working

4. Then get kafka -> streaming spark -> cassandra -> angular2 working

Also...

Might need to create a number pumper of random numbers to simulate RT data.

Alternatively, could use something like iostat, vmstat, sar or
something in /proc that creates new data every few seconds
