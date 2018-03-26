#!/usr/bin/env bash


RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

PROJECT_TESTS=$(/bin/ls *.js | sort)

mv "../contracts/MockInclude.sol" "../contracts/MockInclude.sol_"

RESULT=0
for TEST_FILE in ${PROJECT_TESTS[@]} ; do
	if [ ${RESULT} -eq 0 ]; then
		TEST_PATH=`pwd`/${TEST_FILE}
		printf "${GREEN}Testing: ${TEST_PATH}${NC}\n"
		./run-test.sh ${TEST_PATH}
		RESULT=$?
	fi
done

mv "../contracts/MockInclude.sol_" "../contracts/MockInclude.sol"

if [ ${RESULT} -eq 0 ]; then
  printf "${GREEN}\xE2\x9C\x94 "`pwd`"/run-project-tests.sh${NC}\n"
else
  printf "${RED}\xE2\x9D\x8C "`pwd`"/run-project-tests.sh${NC}\n"
fi

exit ${RESULT}
