#!/bin/bash

echo "Enter your username:"
read NAME

PSQL="psql -X --username=freecodecamp --dbname=number_guess -t --no-align -c"

PLAYER_ID=$($PSQL "SELECT player_id FROM players WHERE name = '$NAME'")

# if username has not been used before
if [[ -z $PLAYER_ID ]]
then
  echo -e "Welcome, $NAME! It looks like this is your first time here."
  # update players table
  # INSERT_PLAYER_RESULT=$($PSQL "INSERT INTO players(name) VLAUES('$NAME')")
else
  # get games number
  GAMES=$($PSQL "SELECT COUNT(player_id) FROM games WHERE player_id = '$PLAYER_ID'")
  # get guesses number
  BSET_GUERSSES=$($PSQL "SELECT MIN(guess_number) FROM games")
  echo -e "Welcome back, $NAME! You have playered $GAMES, and your best game took $BSET_GUERSSES guesses."
