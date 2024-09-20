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

option(){
    askOption=false

    while [[ $askOption == false ]] ; do 
        if [[ $1 == true ]] ; then
            echo -e "\nOpciones: "
            echo "1. Registrar usuario"
            echo "2. Registro de mascotas"
            echo "3. Estadisticas de adopcion"
            echo "4. Salir"
            echo ""
            read -p "Ingrese opcion: " option
            if [[ $option == 1 ]] ; then
                prueba="no"
                while [[ $prueba == "no" ]] ; do
                    echo -e "\nIngrese el nombre del nuevo usuario:"
                    read newName
                    echo -e "\nIngrese la cedula del nuevo usuario:"
                    read newUser
                    prueba=$(grep ^$newUser users.txt)
                    if [[ $prueba == "" ]] ; then
                        echo -e "\nIngrese el numero de telefono del nuevo usuario:"
                        read newNum
                        validDate=false
                        while [[ $validDate == false ]] ; do
                            echo -e "\nIngrese la fecha de nacimiento del nuevo usuario:"
                            read newDate
                            if [[ $newDate =~ ^([0-2][0-9]|3[0-1])/(0[1-9]|1[0-2])/[0-9]{4}$ ]] ; then
                                validDate=true
                            else
                                echo -e "\nIngrese una fecha valida en formato dd/mm/aaaa"
                            fi
                        done
                        echo -e "\nEl usuario fue registrado exitosamente"
                    else
                        echo -e "\nEl usuario no fue registrado"
                    fi
                done
            elif [[ $option == 2 ]] ; then
                echo ""
            elif [[ $option == 3 ]] ; then
                askOption=true
            elif [[ $option == 4 ]] ; then
                askOption=true
            else
                echo "error"
            fi
        else
            echo "Menu user"
        fi

    done
}

echo "Bienvenido al sistema, inicie seción"

while [[ $app == true ]] ; do
    login
    option $admin
    app=false
done