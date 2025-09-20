#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"
MAIN_MENU(){
  if [[ $1 ]]
  then
    echo -e "\n$1\n"
  fi
  echo -e "Welcome to My Salon, how can I help you?\n\n1) cut\n2) color\n3) perm\n"
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) APPOINT_MENU "cut" ;;
    2) APPOINT_MENU "color" ;;
    3) APPOINT_MENU "perm" ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
  esac
}
APPOINT_MENU(){
  echo -e "\nWhat's your phone number?\n"
  read CUSTOMER_PHONE
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_ID ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?\n"
    read CUSTOMER_NAME
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers (name,phone) VALUES ('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  fi
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id=$CUSTOMER_ID")
  echo -e "\nWhat time would you like your cut,$CUSTOMER_NAME?\n"
  read SERVICE_TIME
  INSERT_APPOINT=$($PSQL "INSERT INTO appointments (customer_id, service_id, time) VALUES ($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
  echo -e "\nI have put you down for a $1 at $SERVICE_TIME,$CUSTOMER_NAME.\n"
}
MAIN_MENU