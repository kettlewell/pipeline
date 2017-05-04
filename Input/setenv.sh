#!/bin/bash
alias notebook="cd /notebooks; jupyter notebook --ip='*'"

export PATH=/anaconda2/bin:$PATH
export JAVA_HOME=/etc/alternatives/java_sdk

#export PATH=/home/guest/spark/bin:home/guest/spark/sbin:home/guest:/kafka/bin:
#export SPARK_HOME=/home/guest/spark
#export PYTHONPATH=$SPARK_HOME/python/:$PYTHONPATH
#export PYTHONPATH=$SPARK_HOME/python/lib/py4j-0.10.1-src.zip:$PYTHONPATH
#export PATH=$HOME/sbt/bin:$PATH
