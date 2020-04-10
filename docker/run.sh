#!/bin/bash

PWD=${PWD}
DATA_DIR=${PWD}/data/
SPARK_VERSION='2.4.5'
ELASTIC_SEARCH_VERSION='7.3.2'

if [ "$2" != "" ]; then
  SPARK_VERSION="$2"
fi

if [ "$3" != "" ]; then
  ELASTIC_SEARCH_VERSION="$3"
fi

DOCKER_COMPOSE_FILE='docker-compose-all.yaml'
DOCKER_NETWORK_NAME='learnml'

function installSpark() {
    echo "using curl to download spark 2.4.5"
    #mkdir ${PWD}/install

    if test ! -d "${PWD}/spark-${SPARK_VERSION}"
    then 
      curl -XGET "http://mirror.cc.columbia.edu/pub/software/apache/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz" > "${PWD}/install/spark-2.4.5.tgz"
      cd "${PWD}/install" && tar -xvzf spark-2.4.5.tgz && rm spark-${SPARK_VERSION}.tgz
      mv spark-${SPARK_VERSION}-bin-hadoop2.7 ../spark-${SPARK_VERSION}
      cd ..
    else
      echo "Spark is already installed under ${PWD}/spark-${SPARK_VERSION}"
    fi
    echo "${PWD}"
}

function prepData() {
    cd "${DATA_DIR}" || exit 1
    # move data around, unzip files etc
    cd .. || exit 1
    echo "${PWD}"
}

function sparkConf() {
    cp "${PWD}/install/spark-defaults.conf" "${PWD}/spark-${SPARK_VERSION}/conf/"
}

function init() {
  echo "SPARK_VERSION=${SPARK_VERSION}"
  echo "ELASTIC_SEARCH_VERSION=${ELASTIC_SEARCH_VERSION}"
  installSpark
  prepData
  sparkConf
}

function cleanAndBuildDockerNetwork() {
    echo "cleaning up docker network if it was already created. Network Name : ${DOCKER_NETWORK_NAME}"
    docker network rm ${DOCKER_NETWORK_NAME}
    echo "building new docker network : ${DOCKER_NETWORK_NAME}"
    docker network create -d bridge ${DOCKER_NETWORK_NAME}
}

function cleanDocker() {
    docker rm -f `docker ps -aq` # deletes the old containers
}

function start() {
    #init
    export SPARK_HOME="${PWD}/spark-${SPARK_VERSION}"
    echo "Your Spark Home is set to ${SPARK_HOME}"
    cleanDocker
    cleanAndBuildDockerNetwork

    docker run -d --name elasticsearch --hostname elasticsearch --net ${DOCKER_NETWORK_NAME} -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" "elasticsearch:${ELASTIC_SEARCH_VERSION}"
    docker run -d --name kibana --net ${DOCKER_NETWORK_NAME} -p 5601:5601 "kibana:${ELASTIC_SEARCH_VERSION}"
    docker-compose -f ${DOCKER_COMPOSE_FILE} up -d --remove-orphans zeppelin

    echo "ElasticSearch is now running on port 9200 for the http API and port 9300 for transport api"
    echo "Kibana is now running on port 5601: http://localhost:5601. So you can create indices and dashboards there"
    echo "Apache Zeppelin is now running on port 8080 at http://localhost:8080/. Now you can harness the power of Notebooks to mess with ElasticSearch from Spark"
    echo "Let's get Started!"
}

function stop() {
    docker-compose -f ${DOCKER_COMPOSE_FILE} down
    docker stop elasticsearch
}

function info() {

    CONTAINER=$2
    echo "INSPECT THIS ${CONTAINER}"
    docker inspect ${CONTAINER}
}

case "$1" in
    install)
        init
    ;;
    prep)
        prepData
    ;;
    start)
        start
    ;;
    stop)
        stop
    ;;
    info)
        info
    ;;
    *)
        echo $"Usage: $0 {install [SPARK_VERSION] [ELASTIC_SEARCH_VERSION] | prep | start | stop | info [CONTAINER_NAME]"
    ;;
esac
