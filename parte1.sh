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
        credentials=$(grep "$username:$password:$type" users.txt)
        if [[ $credentials != "" ]] ; then
            logged=true
            hayLog=true
            if [[ $type == "admin" ]] ; then
                admin=true
                echo -e "\nBienvenido administrador\n"
            else
                admin=false
                echo -e "\nBienvenido $username\n"
            fi
        else
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
                salir
                askOption=true
            else
                echo "error"
            fi
        else 
            echo "Opciones: "
            echo "1. Listar mascotas disponibles en adopción"
            echo "2. Adoptar mascota"
            echo "3. Salir"
            read -p "Ingrese opcion: " option

            if [[ $option == 1 ]] ; then
                listarMascotas
                askOption=true
            elif [[ $option == 2 ]] ; then
                adoptarMascotas
                askOption=true
            elif [[ $option == 3 ]] ; then
                salir
                askOption=true
            else
                echo "Debe ingresar un valor valido"
            fi
        fi
    done
}

listarMascotas(){
    # Se muestra la lista de mascotas disponibles
    # Formato: Nombre - Tipo - Edad - Descripcion
    # Formato del txt: ID:TIPO:NOMBRE:SEXO:EDAD:DESCRIPCION:FECHA_INGRESO
    echo "Mascotas disponibles: "

    # IFS = Internal Field Separator
    while IFS=: read -r id tipo nombre sexo edad descripcion fecha_ingreso; do
        echo "$nombre - $tipo - $edad - $descripcion"
    done < mascotas.txt
}

adoptarMascotas(){
    # Se muestra la lista de mascotas disponibles
    # Formato: ID - Nombre
    # Formato del txt: ID:TIPO:NOMBRE:SEXO:EDAD:DESCRIPCION:FECHA_INGRESO
    echo "Mascotas disponibles: "

    # IFS = Internal Field Separator
    while IFS=: read -r id tipo nombre sexo edad descripcion fecha_ingreso; do
        echo "$id - $nombre"
    done < mascotas.txt


    mascota=""
    while [[ $mascota == "" ]] ; do
        read -p "Ingrese el ID de la mascota que desea adoptar: " id_mascota
        mascota=$(grep "^$id_mascota:" mascotas.txt)
        if [[ $mascota != "" ]] ; then
            echo "Mascota adoptada"
            # Se elimina la mascota de la lista de mascotas
            sed -i "/^$id_mascota:/d" mascotas.txt #-i es para modificar el archivo y /d es para eliminar la linea

            # Formato: NOMBRE_MASCOTA:ID_MASCOTA:FECHA(dd/mm/yyyy)
            # Seleccionar nombre e id de mascota
            # -d es para indicar el delimitador y -f es para indicar el campo
            nombre_mascota=$(echo $mascota | cut -d':' -f 3)
            id_mascota=$(echo $mascota | cut -d':' -f 1)
            fecha=$(date +"%d/%m/%Y")

            # Se guarda la mascota en el archivo de adopciones
            echo "$nombre_mascota:$id_mascota:$fecha" >> adopciones.txt

        else
            echo "No se encontro la mascota"
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
        echo "$newUser:$newName:$newPass:$isAdmin:$newNum:$newDate" >> users.txt
        echo -e "\nEl usuario fue registrado exitosamente"
    else
        echo -e "\nYa existe un usuario registrado con esa cedula"
    fi
}

# registroMascota(){
    
# }

salir(){
    app=false
}

##########################################
##########################################
##########################################
##########################################
echo "Bienvenido al sistema, inicie seción"
login

while [[ $app == true ]] ; do 
    option $admin
done