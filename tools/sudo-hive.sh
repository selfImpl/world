#!/bin/bash

#if [ "`whoami`" != "hadoop_hotel" ]; then
#    echo "only 'hadoop_hotel' can do this, execute 'su hadoop_hotel' first"
#    exit 1
#fi

if [ -e "$1" ]; then
    sudo -u hadoop_hotel JAVA_HOME=$JAVA_HOME HADOOP_HOME=$HADOOP_HOME $HIVE_HOME/bin/hive <<EOF
`cat $1`
exit;
EOF
else
    echo "Usage: ./sudo-hive.sh hive-sql-file"
fi
