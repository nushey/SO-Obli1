#!/bin/bash


app=true
admin=false

login(){
    logged=false
    while [[ $logged == false ]] ; do
        result=false
        read -p "Ingrese nombre usuario: " username
        read -p "Ingrese contraseña: " password
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
            echo ".."
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

salir(){
    app=false
    echo "Hasta luego..."
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