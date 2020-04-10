## Workshop Material: Introduction to Apache Spark and ElasticSearch

### About the Speaker
Find me on Twitter: [@newfront](https://twitter.com/newfront)
Find me on Medium [@newfrontcreative](https://medium.com/@newfrontcreative)
About Twilio: [Twilio](https://twilio.com)

## Runtime Requirments
1. Docker (at least 2 CPU cores and 8gb RAM)
2. System Terminal (iTerm, Terminal, etc)
3. Working Web Browser (Chrome or Firefox)

### Docker
Install Docker Desktop (https://www.docker.com/products/docker-desktop)

Additional Docker Resources:
* https://docs.docker.com/get-started/
* https://hub.docker.com/

#### Docker Runtime Recommendations
1. 2 or more cpu cores.
2. 8gb/ram or higher.

## Installation
1. Install Docker (See Docker above)
2. Once Docker is installed. Open up your terminal application and `cd /learn-spark-elasticsearch/docker`
3. `./run.sh install`
4. `./run.sh start`

Note: `./run.sh install 2.4.5 7.3.2` will install Spark 2.4.5 and ElasticSearch/Kibana for ES 7.3.2

## Checking Zeppelin and Updating Zeppelin
1. The **Main Application** should now be running at http://localhost:8080/

### Update the Zeppelin Spark Interpreter Runtime
1. Go to http://localhost:8080/#/interpreter on your Web Browser
2. Search for `spark` in the `Search Interpreters` input field.
3. Click the `edit` button to initiate editing mode.

Updated the following key/values
1. **spark.cores.max** 2
2. **spark.executor.memory** 8g

#### Reference
Note: These links are here for reference only. You don't need to download anything manually, the `run.sh` script will do everything for you.

### These are the Technologies Used in this Workshop (run.sh will install everything)
1. [Apache Zeppelin](https://zeppelin.apache.org/docs/latest/interpreter/spark.html)
2. [Apache Spark](http://spark.apache.org/)
3. [ElasticSearch](https://www.elastic.co/elasticsearch/)

#### Spark 2.4.5
- http://mirror.cc.columbia.edu/pub/software/apache/spark/spark-2.4.5/spark-2.4.5-bin-hadoop2.7.tgz
- (222 MB)

#### ElasticSearch Docker Hub (v7.3.2)
https://hub.docker.com/_/elasticsearch
https://hub.docker.com/_/kibana

#### ElasticSearch Hadoop (v7.3.2)
https://www.elastic.co/guide/en/elasticsearch/hadoop/current/spark.html

### Datasets
* Netflix Movies and Shows: https://www.kaggle.com/shivamb/netflix-shows
* GoodReads Books: https://www.kaggle.com/jealousleopard/goodreadsbooks
