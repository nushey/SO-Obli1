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
        echo -e "\nIngrese nombre usuario"
        read username
        echo -e "\nIngrese contraseña"
        read -s password
        hayLog=false
        while IFS=: read -r nombre cedula telefono fecha esAdmin pass; do
            echo "HOLAAAA"
            if [[ $username == $cedula ]] ; then
                echo -e "\n\nUSUARIO ENCONTRADO\n\n"
                if [[ $password == $pass ]] ; then
                    echo -e "CONTRASENA CORRECTA\n\n"
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
                registrarUsuario
            elif [[ $option == 2 ]] ; then
                registroMascota
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

registrarUsuario(){
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
}

registroMascota(){
    esValido=false
    while [[ $esValido == false ]] ; do
        read -p "\n Ingrese numero identificador:" numId
        if [[ $numId =~ [0-9]+$ ]] ; then
            esValido=true
        else
            echo -e "\nEl identificador debe ser un numero natural"
        fi
    done
    yaExisteM=false
    while IFS=: read -r idM tipoM nombreM sexoM edadM descM fechaIng; do
        if [[ $numId == $idM ]] ; then
            yaExisteM=true
        fi
    done < mascotas.txt
    if [[ $yaExiste == false ]] ; then
        echo -e "\nIngrese el tipo de la mascota:"
        read tipoM
        echo -e "\nIngrese el nombre de la mascota:"
        read nombreM
        echo -e "\nIngrese el sexo de la mascota:"
        read sexoM
        valid=false
        while [[ $valid == false ]] ; do
            echo -e "\nIngrese la edad de la mascota:"
            read edadM
            if [[ $edadM =~ [0-9]+$ ]] ; then
                if [[ $edad > 0 ]] ; then
                    valid=true
                fi
            fi    
            if [[ $valid == false ]] ; then
                echo -e "\nIngrese una edad valida mayor a 0"
            fi
        done
        echo -e "\nIngrese una descripcion de la mascota:"
        read descM
        validDate=false
        while [[ $validDate == false ]] ; do
            echo -e "\nIngrese la fecha de ingreso de la mascota:"
            read newDate
            if [[ $newDate =~ ^([0-2][0-9]|3[0-1])/(0[1-9]|1[0-2])/[0-9]{4}$ ]] ; then
                validDate=true
            else
                echo -e "\nIngrese una fecha valida en formato dd/mm/aaaa"
            fi
        done
    else
        echo -e "\nYa existe una mascota registrada con ese identificador"
    fi
}

echo "Bienvenido al sistema, inicie sesión"

while [[ $app == true ]] ; do
    login
    option $admin
    app=false
done