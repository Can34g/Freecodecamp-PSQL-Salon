#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"


MAIN_MENU(){
   if [[ $1 ]]
  then
    echo -e "\n$1"
  fi
SERVICES_LIST=$($PSQL "SELECT * FROM services")
echo "$SERVICES_LIST " | while read SERVICE_ID BAR SERVICE
do
ID=$(echo $SERVICE_ID | sed 's/ //g')
NAME=$(echo $SERVICE | sed 's/ //g')

echo -e "$ID) $SERVICE"
done

echo "Please select a service\n"
read SERVICE_ID_SELECTED


case $SERVICE_ID_SELECTED in 
  [1-3]) REGISTER;;
  4) EXIT;;
  *) MAIN_MENU "Please enter a valid number!" ;;
 esac
}
REGISTER(){
  echo -e "\n Please enter your phone number"
  read CUSTOMER_PHONE
  CUSTOMER_PHONE_EXISTS=$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_PHONE_EXISTS ]]
  then 
  echo -e "\n Please enter your name for registration"
  read CUSTOMER_NAME
  CUSTOMER_REGISTER_RESULT=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  else
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
  fi
  echo -e "\n Please enter service time"
  read SERVICE_TIME
  APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED,'$SERVICE_TIME')")

  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE customer_id = $CUSTOMER_ID")
  if [[ $APPOINTMENT_RESULT == "INSERT 0 1" ]]
  then
            echo -e "\nI have put you down for a $(echo $SERVICE_NAME | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."

  fi
}


MAIN_MENU
