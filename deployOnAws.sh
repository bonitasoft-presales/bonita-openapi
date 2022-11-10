#!/usr/bin/env bash

set -e

STACK_ID="laurent-test-stackId"
INSTANCE_NAME="laurent-test"
#INSTANCE_NAME="open-api"
KEY_FILE="~/.ssh/presale-ci-eu-west-1.pem"
JAR_VERSION="1.3"
JAR_NAME="bonita-aws-${JAR_VERSION}-jar-with-dependencies.jar"

rm -rf target
mkdir -p target
cd target


#create
java -jar ../aws/${JAR_NAME} \
--command create \
--stack-id ${STACK_ID} \
--name ${INSTANCE_NAME} \
--ami-id ami-08ca3fed11864d6bb \
--key-file ${KEY_FILE}

java -jar ../aws/${JAR_NAME} \
--command status \
--stack-id ${STACK_ID} \
--key-file ${KEY_FILE}

cp ${STACK_ID}.yaml ../ansible/vars/aws_var.yaml
cd ../ansible

ansible-playbook ansible_scenario.yaml -i ../target/public-inventory-${STACK_ID}.yaml
