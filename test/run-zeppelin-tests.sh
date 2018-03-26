#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

declare -a ZEPPELIN_TESTS=(
"../zeppelin/test/ownership/Ownable.test.js"
"../zeppelin/test/token/ERC721/ERC721BasicToken.test.js"
"../zeppelin/test/token/ERC721/ERC721Token.test.js"
)

RESULT=0
for file in ${ZEPPELIN_TESTS[@]} ; do
	if [ ${RESULT} -eq 0 ]; then
		TEST_PATH=`pwd`/${file}
		printf "${GREEN}Testing: ${TEST_PATH}${NC}\n"

		./run-test.sh ${TEST_PATH}
		RESULT=$?
	fi
done

if [ ${RESULT} -eq 0 ]; then
  printf "${GREEN}\xE2\x9C\x94 "`pwd`"/run-zeppelin-tests.sh${NC}\n"
else
  printf "${RED}\xE2\x9D\x8C "`pwd`"/run-zeppelin-tests.sh${NC}\n"
fi

exit ${RESULT}
