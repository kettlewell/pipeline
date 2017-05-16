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

## Appended Notes:

So after doing some research and thinking about things,
it's clear to me that this project ( and most data pipelines really )
follow this path:

1. Input Source
2. Message Queue / Buffer
3. Processing
4. Output / Results Storage
5. Display

This suggests to me that I could have a container for each stage
in the processing pipeline, with each stage being capable of being
horizontally scalable to add additional compute / storage nodes,
but generally not needed for a prototyping system like this.

So thinking out loud...

I think that I can create a directory for each stage, and inside
each stage we can address the specifics of which component(s) are
to be built on each container.

So rough draft outline:

1. Input
   a. static files
   b. random number stream
   c. streaming system data
2. Queue
   a. Kafka
3. Processing
   a. Spark
   b. Spark Streaming
4. Output
   a. files
   b. Cassandra
5. Display
   a. node.js
   b. express server
   c. angular
   d. d3.js


To me, the idea to build this up, would be to start small
with the static/hard coded data first, roughly in this order:

1. Display framework
   Get an express server running that has the ability to work with routes
   and create some stub routes:
       a. /  ( list of all links available )
       b. /socket.io/monitoring
       c. /socket.io/random-numbers
       d. /spark/cassandra/census-data
       e. /spark/disk/census-data
       f. /spark-streaming/disk/random-numbers
       g. /spark-streaming/cassandra/random-numbers
       h. /spark-streaming/disk/monitoring
       i. /spark-streaming/cassandra/monitoring

    OK... I like this ... the 'file' keyword was changed to 'disk'
    and I changed the placeholder 'static-file' to 'census-data'
    so that it resembles a real data set, and .. voila!

    Those look like 8 good starting points to test enough scenarios to get
    a pretty good feel for how everything works together in a variety of fashions.

   Edit:  One last thought on this ... might be easier to just have
   /demo1, /demo2, etc, and an index page that lists out what each URL
   is accomplishing... probably the easiest and least complicated way.

2. So after the Display framework is started, work with the socket.io framework, to get the data
   flowing from Input to Display. The point of this excercise isn't really to process data, but
   to show that data can stream from once source to another and be displayed in real-time. I have
   some of the monitoring socket.io tested, so let's start with that and get it displaying through
   a d3.js framework. Don't worry about the fine points of the display yet. That will be very last.

3. Next we want to work on the Spark -> File -> Display
   We will need to create Spark and Storage docker containers, and make sure that Spark
   can read data from the Input container, and write data to the Output container.

   Need a way to submit jobs to spark. From the Input container? Or.. ???

   Need to select a data file ( census data would work ), and create a mock analysis
   ( mead, std dev would work to start ) just to get the concept running.

4. Update the Angular app to read the Spark data from the Output directory and display it in
   a d3.js chart.

5. Spark streaming will require a message buffer, so need to build the Queue container with
   Kafka in it. And get the pipeline going from Input -> Queue -> Spark Streaming -> File -> Display

## Notes on minimal images
After spending a few days ( week ) on working with a minimal image of centos, for this project
it's just not worth the effort because it was getting negated with the dependencies of all the
tools we're installing ( spark / kafka / R / cassandra / etc )

So for this project, I'll just use the base centos:centos7 image