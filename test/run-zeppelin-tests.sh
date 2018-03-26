#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

declare -a zeppelin_tests=(
"../zeppelin/test/ownership/Ownable.test.js"
)

RESULT=0
for file in ${zeppelin_tests[@]} ; do
	if [ ${RESULT} -eq 0 ]; then
		js=`pwd`/${file}
		printf "${GREEN}Testing: ${js}${NC}\n"

		./run-test.sh ${js}
		RESULT=$?
	fi
done

if [ ${RESULT} -eq 0 ]; then
  printf "${GREEN}\xE2\x9C\x94 "`pwd`"/run-zeppelin-tests.sh${NC}\n"
else
  printf "${RED}\xE2\x9D\x8C "`pwd`"/run-zeppelin-tests.sh${NC}\n"
fi

exit ${RESULT}
