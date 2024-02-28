#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n ~~~~~ MUTLU SALON ~~~~~"
echo -e "\nWelcome to Mutlu salon, how can I help you?"

MAIN_MENU() {
  SERVICES_SELECT_RESULT=$($PSQL "select * from services")
  if [[ -z $1 ]]
  then
    echo -e "\n$SERVICES_SELECT_RESULT\n" | sed 's/ |/)/'
  else
    echo "I could not find that service. What would you like today?"
    echo -e "\n$SERVICES_SELECT_RESULT\n" | sed 's/ |/)/'
  fi
  read SERVICE_ID_SELECTED
  SERVICE_NAME=$($PSQL "select name from services where service_id='$SERVICE_ID_SELECTED'")
  if [[ -z $SERVICE_NAME ]]
  then
    MAIN_MENU 1
  else
    echo -e "\nWhat'S your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      INSERT_CUSTOMER_RESULT=$($PSQL "insert into customers(phone,name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    fi
    echo -e "\nWhat time would you like your $SERVICE_NAME, $CUSTOMER_NAME?"
    read SERVICE_TIME
    CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
    APPOINTMENT_INSERT_RESULT=$($PSQL "insert into appointments(customer_id,service_id,time) 
    values('$CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")
    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}

MAIN_MENU
