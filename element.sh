#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
if [ -z $1 ]
  then
  echo Please provide an element as an argument.
else
  if [ $(echo $1 | grep '^[0-9]*$') ]
    then
    ELEMENT="atomic_number"
  fi
  if [ $(echo $1 | grep -E '[A-Z][a-z]?$') ]
    then
    ELEMENT="symbol"
  fi
  if [ $(echo $1 | grep -E '[A-Z][a-z][a-z]+$') ]
    then
    ELEMENT="name"
  fi
  if [ -z $ELEMENT ]
    then
    echo "Provide a valid input"
  else
    IFS='|' read -r atomic_number symbol name <<< $($PSQL "SELECT * FROM elements WHERE $ELEMENT='$1'")
    if [[ -z $atomic_number || -z $symbol || -z $name ]]
      then
      echo I could not find that element in the database.
    else
      IFS='|' read -r type atomic_mass melting_point_celsius boiling_point_celsius <<< $($PSQL "SELECT (SELECT type FROM types WHERE type_id=properties.type_id), atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties WHERE atomic_number=$atomic_number")
      echo "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $atomic_mass amu. $name has a melting point of $melting_point_celsius celsius and a boiling point of $boiling_point_celsius celsius."
    fi
  fi
fi