#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n(~~~~~ MY SALON ~~~~~)\n"

MAIN_MENU(){

  echo  "Welcome to My Salon, how can I help you?"
  #  echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim\n"
  SERVICES_MENU
  
}

SERVICES_MENU(){
  #get available services
  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id  ")
  # echo "$AVAILABLE_SERVICES"

  #if no services available
if [[ -z $AVAILABLE_SERVICES ]]
then
    #send to main menu
    MAIN_MENU "Sorry, we don't have any services available right now."
    else
    #display available services 
    echo -e "\nHere are the services we have available:"
    echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
    do
        echo "$SERVICE_ID) $NAME"
    done

    #ask for services to do
    echo -e "\nWhich one would you like to do?"
    read SERVICE_ID_SELECTED

#if input is not a number 
if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
then
    #send to main menu
    MAIN_MENU "That is not a valid service number."
    else
    # get services availability
    SERVICES_AVAILABILITY=$($PSQL "SELECT name FROM services WHERE service_id = '$SERVICE_ID_SELECTED'")
    #if not availability
    if [[ -z $SERVICES_AVAILABILITY ]]
    then
    #send to main menu
    MAIN_MENU "\nI could not find that service. What would you like today?"
    else
    #git customer ingo
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE

    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    # if customer doesn't exit
    if [[ -z $CUSTOMER_NAME ]]
    then
        echo -e "\nWhat's your name?"
        read CUSTOMER_NAME

    # insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME','$PHONE_NUMBER')")
    fi

    fi




fi

fi

}

# RETURN_SERVICES_MENU(){

# }

# EXIT(){

# }

MAIN_MENU

#//////////////////////// ^ code_2 ^

#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n(~~~~~ MY SALON ~~~~~)\n"

MAIN_MENU(){

  echo -e "\nWelcome to My Salon, how can I help you?\n"
  #  echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim\n"
  SERVICES_MENU
  
}

#display service function
 DISPLAY_SERVICES(){
    echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME
    do
        echo "$SERVICE_ID) $NAME"
    done
   }


SERVICES_MENU(){
  #get available services
  AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")

   # call display services function 
    DISPLAY_SERVICES
   # enter service_id_selected  
    read SERVICE_ID_SELECTED

   #if service doesn't exist 
    if [[ ! $SERVICE_ID_SELECTED =~ ^[0-9]+$ ]]
    then  #shown the same list of services again
        echo -e "\nI could not find that service. What would you like today?\n" 
        DISPLAY_SERVICES 
      else #get customer info as phone number
          echo -e "\nWhat's your phone number?"
      #enter phone number
      read CUSTOMER_PHONE
      
      #show customer name when customer phone exit database
       CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

       #if cumstomer phone not exit database
       if [[ -z $CUSTOMER_NAME ]]
       then 
        # get new customer name
          echo -e "\nI don't have a record for that phone number, what's your name?"
          read CUSTOMER_NAME
         # insert new customer
          INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')") 
        fi   
      # read input service_time
       echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
       read SERVICE_TIME

       #get customer_id
       CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

       #get service_id
       SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id ='$SERVICE_ID_SELECTED'")

       #insert time, customer_id, service_id into appointments
       INSERT_APPOINTMENTS_RESULT=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME','$CUSTOMER_ID','$SERVICE_ID')")

        #get service_name 
       SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")

       # confirm order by this massage
       echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME.\n"

      
    fi 

}


MAIN_MENU