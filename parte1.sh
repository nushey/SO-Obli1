#!/bin/bash

# Script Name: parte1.bash
# Description: Brief description of what the script does
# Author: Your Name
# Date: YYYY-MM-DD


app=true

logged=false

admin=false

echo "Bienvenido al sistema, inicie seción"
while [[ $app == true ]] ; do
    while [[ $logged == false ]] ; do
        
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

    if [[ $admin == true ]] ; then 

    else 

    fi

    app=false
done