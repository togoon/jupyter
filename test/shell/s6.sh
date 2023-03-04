#!/bin/bash
string="hello_shell_haha.xml"
array=(${string//_/ }) 
for var in ${array[@]}
do
  echo $var
done

echo  ${array[0]}
echo

a1=aa11
for var in a1 b2 c3 
do
  eval tmp=$(echo '$'"$var")
  echo $tmp
done






