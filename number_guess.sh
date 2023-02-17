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
  INSERT_PLAYER_RESULT=$($PSQL "INSERT INTO players(name) VALUES('$NAME')")
  # update player_id
  PLAYER_ID=$($PSQL "SELECT player_id FROM players WHERE name = '$NAME'")
else
  # get games number
  GAMES=$($PSQL "SELECT COUNT(player_id) FROM games WHERE player_id = '$PLAYER_ID'")
  # get guesses number
  BSET_GUERSSES=$($PSQL "SELECT MIN(guess_number) FROM games")
  echo -e "Welcome back, $NAME! You have playered $GAMES, and your best game took $BSET_GUERSSES guesses."
fi

SECRET_NUMBER=$(( $RANDOM % 1000 + 1 ))
echo "Guess the secret number between 1 and 1000:"
read PLAYER_NUMBER
COUNT=0

while [[ $SECRET_NUMBER -ne $PLAYER_NUMBER ]]
do
  if [[ $PLAYER_NUMBER -gt $SECRET_NUMBER ]]
  then
    echo "It's higher than that, guess again:"
  elif [[ $PLAYER_NUMBER -lt $SECRET_NUMBER ]]
  then
    echo "It's lower than that, guess again:"
  else
    echo "That is not an integer, guess again:"
  fi
  ((COUNT++))
  read PLAYER_NUMBER
done

((COUNT++))
echo "You guessed it in $COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"
# update games table
INSERT_GAMES_RESULT=$($PSQL "INSERT INTO games(player_id, guessing_number) VALUES($PLAYER_ID, $COUNT);")



