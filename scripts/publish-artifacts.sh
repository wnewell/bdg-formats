#!/bin/bash

# get current sha1
sha1=$(git log -1 --pretty=format:%H)

# get avrotools jar
rm -f avro-tools-1.7.6.jar
wget http://psg.mtu.edu/pub/apache/avro/avro-1.7.6/java/avro-tools-1.7.6.jar

# clone repo
git clone git@github.com:bigdatagenomics/bigdatagenomics.github.io.git

# get maven artifact version
version=$(mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version | grep -v "\[" | grep -v "Download")

# clean and make new dir
bdgschemadir=${PWD}/bigdatagenomics.github.io/projects/bdg-formats/schemas/${version}
rm -rf ${bdgschemadir}
mkdir -p ${bdgschemadir}

# generate schemas
cp src/main/resources/avro/bdg.avdl ${bdgschemadir}
java -jar avro-tools-1.7.6.jar idl src/main/resources/avro/bdg.avdl > ${bdgschemadir}/bdg.avsc

# step into repo
cd bigdatagenomics.github.io

# mark for add and commit
git add projects/bdg-formats/schemas/${version}/*
git commit -m "Adding schemas for bdg-formats commit ${sha1}."
git push origin master

# clean up bdg repo
cd ..
rm -rf bigdatagenomics.github.io