#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

trf="node node_modules/.bin/truffle"

printf "${GREEN}Running testrpc instance${NC}\n"
bash ./testrpc.sh >/dev/null 2>&1 &

printf "${GREEN}Running truffle compile${NC}\n"
${trf} compile --network development --optimize $@

printf "${GREEN}Stopping the testrpc instance${NC}\n"
pgrep -f "node_modules/.bin/testrpc" | xargs kill -9
