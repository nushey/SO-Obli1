#!/bin/bash

# Script Name: parte1.bash
# Description: Brief description of what the script does
# Author: Your Name
# Date: YYYY-MM-DD


app=true
admin=false

login(){
    logged=false
    while [[ $logged == false ]] ; do
        result=false
        echo "Ingrese nombre usuario"
        read username
        echo "Ingrese contraseña"
        read password
        if [[ $username == "admin" && $password == "admin" ]] ; then
            echo "Bienvenido admin"
            admin=true
            logged=true
        else
            credentials=$(grep "$username:$password" users.txt)

            if [[ "$username:$password" == "$credentials" ]] ; then
                echo "Bienvenido user"
                logged=true
            else
                echo "Usuario o contraseña incorrectos"
            fi
        fi
    done 
}

optionUser(){
    askOption=false

    while [[ $askOption == false ]] ; do 
        echo "Opciones: "
        echo "1. Listar mascotas disponibles en adopción"
        echo "2. Adoptar mascota"
        echo "3. Salir"

        read option


    done
}

echo "Bienvenido al sistema, inicie seción"

while [[ $app == true ]] ; do
    login
    if [[ $admin == true ]] ; then 

    else 
        
        

    fi

    app=false
done