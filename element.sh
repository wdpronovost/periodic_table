#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

DISPLAY_ATOM_DETAILS() {
  A_NUMBER=$1
  A_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$A_NUMBER")
  A_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$A_NUMBER")
  A_TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING (type_id) WHERE atomic_number=$A_NUMBER")
  A_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$A_NUMBER")
  A_MELT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$A_NUMBER")
  A_BOIL=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$A_NUMBER")
  echo "The element with atomic number $(echo $A_NUMBER | sed -E 's/^ *| *$//g') is $(echo $A_NAME | sed -E 's/^ *| *$//g') ($(echo $A_SYMBOL | sed -E 's/^ *| *$//g')). It's a $(echo $A_TYPE | sed -E 's/^ *| *$//g'), with a mass of $(echo $A_MASS | sed -E 's/^ *| *$//g') amu. $(echo $A_NAME | sed -E 's/^ *| *$//g') has a melting point of $(echo $A_MELT | sed -E 's/^ *| *$//g') celsius and a boiling point of $(echo $A_BOIL | sed -E 's/^ *| *$//g') celsius."
}

if [[ ! $1 ]]
then
  echo Please provide an element as an argument.
else
  SEARCH_ELEMENT=$1
  if [[ $SEARCH_ELEMENT =~ ^[0-9]+$ ]]
  then
    SEARCH_RESULT=$($PSQL "SELECT * FROM elements WHERE atomic_number=$SEARCH_ELEMENT")
    if [[ -z $SEARCH_RESULT ]]
    then
      echo "I could not find that element in the database."
    else
      DISPLAY_ATOM_DETAILS $SEARCH_RESULT
    fi
  else
    SEARCH_RESULT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$SEARCH_ELEMENT' OR name='$SEARCH_ELEMENT'")
    if [[ -z $SEARCH_RESULT ]]
    then
      echo "I could not find that element in the database."
    else
      DISPLAY_ATOM_DETAILS $SEARCH_RESULT
    fi
  fi
fi