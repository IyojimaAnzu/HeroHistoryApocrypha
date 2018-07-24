#!/bin/bash
./test.test 
return $(./test.test |grep -c "not ok" )
