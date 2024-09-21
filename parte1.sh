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
        read -s password
        hayLog=false
        while IFS=: read -r nombre cedula telefono fecha esAdmin pass; do
                    if [[ $username == $cedula ]] ; then
                        if [[ $password == $pass ]] ; then
                            hayLog=true
                            if [[ $esAdmin == 1 ]] ; then
                                echo -e "\nBienvenido admin"
                                admin=true
                                logged=true
                            else
                                echo -e "\nBienvenido user"
                                logged=true
                            fi
                        fi
                    fi
        done < users.txt
        if [[ $hayLog == false ]] ; then
            echo -e "\nUsuario o contraseña incorrectos\n"
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
            echo -e "4. Salir\n"
            read -p "Ingrese opcion: " option
            if [[ $option == 1 ]] ; then
                prueba="no"
                echo -e "\nIngrese el nombre del nuevo usuario:"
                read newName
                echo -e "\nIngrese la cedula del nuevo usuario:"
                read newUser
                yaExiste=false
                while IFS=: read -r nombre cedula telefono fecha; do
                    if [[ $newUser == $cedula ]] ; then
                        yaExiste=true
                    fi
                done < users.txt
                if [[ $yaExiste == false ]] ; then
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
                    iguales=false
                    while [[ $iguales == false ]] ; do
                        echo -e "\nIngrese la contraseña:"
                        read -s newPass
                        echo -e "\nIngrese nuevamente la contraseña:"
                        read -s newPass2
                        if [[ $newPass == $newPass2 ]] ; then
                            iguales=true
                        else
                            echo -e "\nLas contraseñas no coinciden"
                        fi
                    done
                    validOption=false
                    while [[ $validOption == false ]] ; do
                        echo -e "\n¿Desea que el nuevo usuario sea administrador?"
                        echo "1. Si"
                        echo -e "2. No\n"
                        read -p "Ingrese opcion: " isAdmin
                        if [[ $isAdmin == 1 || $isAdmin == 2 ]] ; then
                            validOption=true
                        else
                            echo -e "\nIngrese una opcion valida"
                        fi
                    done
                    echo "$newName:$newUser:$newNum:$newDate:$isAdmin:$newPass" >> users.txt
                    echo -e "\nEl usuario fue registrado exitosamente"
                else
                    echo -e "\nYa existe un usuario registrado con esa cedula"
                fi
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
            echo "admin: $admin"
            echo "logged: $logged"
            echo "hayLog: $hayLog"
            askOption=true
        fi

    done
}

echo "Bienvenido al sistema, inicie sesión"

while [[ $app == true ]] ; do
    login
    option $admin
    app=false
done