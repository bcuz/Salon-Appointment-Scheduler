#! /bin/bash

# easier than expected
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
    echo -e "1) cut\n2) color\n3) perm"
  else
    # else makes it like the text file
    echo "Welcome to My Salon, how can I help you?" 
    echo -e "\n1) cut\n2) color\n3) perm"

  fi

  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) cut ;;
    2) color ;;
    3) perm ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}

cut() {
  # we'll know it's a certain id here
  # and suppose i could make it nondry at first
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  # try to pull by num
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

  if [[ -z $CUSTOMER_NAME ]]; then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
  fi

  echo -e "\nWhat time would you like your cut, $(echo $CUSTOMER_NAME | sed -r 's/ *$|^ *//g')?"
  read SERVICE_TIME

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  
  INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, 1, '$SERVICE_TIME')") 
  
  echo -e "\nI have put you down for a cut at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/ *$|^ *//g')."

}

MAIN_MENU

