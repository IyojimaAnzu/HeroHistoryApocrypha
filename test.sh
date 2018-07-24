#!/bin/bash
./test.test 
exit "$(./test.test |grep -c "not ok" )"
