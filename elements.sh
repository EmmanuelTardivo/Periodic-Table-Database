#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# if there is no argument
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # if it's a number
  if [[ $1 =~ ^[0-9]*$ ]] 
  then
    GET_BY_RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = '$1'")
  else
    GET_BY_RESULT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1'")
  fi

  if [[ -z $GET_BY_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    IFS='|' read -r TYPE_ID ATOMIC_NUMBER SYMBOL NAME MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS TYPE <<< $(echo "$GET_BY_RESULT")
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius." 
  fi
fi
