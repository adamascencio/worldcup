#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo "Clearing games and teams table..."
sleep 1

echo "$($PSQL "TRUNCATE TABLE games, teams;")"

# Iterate through games.csv

echo -e "\nInserting data..."
sleep 1


# Add each team to Teams table
while IFS=, read year round winner opponent winner_goals opponent_goals;
do
  if [[ $year = "year" || $round = "round" || $winner = winner || $opponent = "opponent" || $winner_goals = "winner_goals" || $opponent_goals = "opponent_goals" ]];
  then
    continue;
  fi
  # echo $year $round $winner $opponent $winner_goals $opponent_goals;
  echo "$($PSQL "INSERT INTO teams (name) VALUES ('$winner');")"
  echo "$($PSQL "INSERT INTO teams (name) VALUES ('$opponent');")"
done < games.csv

# Add game info to games table
while IFS=, read year round winner opponent winner_goals opponent_goals;
do
  if [[ $year = "year" || $round = "round" || $winner = winner || $opponent = "opponent" || $winner_goals = "winner_goals" || $opponent_goals = "opponent_goals" ]];
  then
    continue;
  fi
  WINNER_ID="$($PSQL "SELECT team_id FROM teams WHERE name = '$winner';")"
  OPPONENT_ID="$($PSQL "SELECT team_id FROM teams WHERE name='$opponent';")"
  echo "$($PSQL "INSERT INTO games (year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$year', '$round', '$WINNER_ID', '$OPPONENT_ID', '$winner_goals', '$opponent_goals');")"
done < games.csv