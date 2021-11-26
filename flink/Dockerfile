ARG FLINK_VERSION=1.12.5
ARG SCALA_VERSION=2.12
ARG JAVA_VERSION=8

FROM apache/flink:${FLINK_VERSION}-scala_${SCALA_VERSION}-java${JAVA_VERSION}


# Install Apache Hadoop
ENV HADOOP_VERSION=2.7.4
ENV HADOOP_HOME /opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/conf
ENV PATH $PATH:$HADOOP_HOME/bin
RUN curl -L \
  "https://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" \
    | tar xvfz - -C /opt/ \
  && rm -rf $HADOOP_HOME/share/doc \
  && chown -R root:root $HADOOP_HOME \
  && mkdir -p $HADOOP_HOME/logs \
  && mkdir -p $HADOOP_CONF_DIR \
  && chmod 777 $HADOOP_CONF_DIR \
  && chmod 777 $HADOOP_HOME/logs

# Install Flink
ARG FLINK_VERSION
ARG SCALA_VERSION
ENV FLINK_VERSION=${FLINK_VERSION}
ENV SCALA_VERSION=${SCALA_VERSION}

ARG MAVEN_URL=https://repo1.maven.org/maven2
ARG FLINK_MAVEN_URL=${MAVEN_URL}/org/apache/flink

ENV FLINK_LIB_DIR=/opt/flink/lib/
ARG FLINK_JARS="\
    flink-sql-connector-kafka \
    flink-connector-jdbc \
    flink-sql-connector-hive-2.3.6"
ARG EXTRA_JARS="\
    https://repo.maven.apache.org/maven2/mysql/mysql-connector-java/8.0.19/mysql-connector-java-8.0.19.jar \
    https://repo1.maven.org/maven2/com/alibaba/ververica/flink-sql-connector-mysql-cdc/1.3.0/flink-sql-connector-mysql-cdc-1.3.0.jar \
    https://jdbc.postgresql.org/download/postgresql-42.3.1.jar"

RUN for flink_jar in ${FLINK_JARS}; do \
        wget -P ${FLINK_LIB_DIR} ${FLINK_MAVEN_URL}/${flink_jar}_${SCALA_VERSION}/${FLINK_VERSION}/${flink_jar}_${SCALA_VERSION}-${FLINK_VERSION}.jar; \
    done && \
    for extra_jar in ${EXTRA_JARS}; do \
        wget -P ${FLINK_LIB_DIR} ${extra_jar}; \
    done

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]


