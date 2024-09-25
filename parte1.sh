#!/bin/bash

app=true
admin=false
logged=false

login() {
    while [[ $logged == false ]]; do
        result=false
        read -p "Ingrese usuario: " username
        read -p "Ingrese contraseña: " -s password
        credentials=$(grep "$username:$password" users.txt)
        if [[ $credentials != "" ]]; then
            type=$(echo $credentials | cut -d':' -f 4)
            logged=true
            hayLog=true
            echo $type
            if [[ $type == "admin" ]]; then
                admin=true
                echo -e "\nBienvenido administrador"
            else
                admin=false
                echo -e "\nBienvenido $username\n"
            fi
        else
            echo -e "\nUsuario o contraseña incorrectos\n"
        fi
    done
}

option() {
    if [[ $1 == true ]]; then
        echo -e "\nOpciones: "
        echo "1. Registrar usuario"
        echo "2. Registro de mascotas"
        echo "3. Estadisticas de adopcion"
        echo "4. Cerrar sesion"
        echo -e "5. Salir\n"
        read -p "Ingrese opcion: " option
        if [[ $option == 1 ]]; then
            registrarUsuario
        elif [[ $option == 2 ]]; then
            registroMascota
        elif [[ $option == 3 ]]; then
            estadisticas
        elif [[ $option == 4 ]]; then
            cerrarSesion
        elif [[ $option == 5 ]]; then
            salir
        else
            echo "Debe ingresar un valor valido"
        fi
    else
        echo "Opciones: "
        echo "1. Listar mascotas disponibles en adopción"
        echo "2. Adoptar mascota"
        echo "3. Cerrar sesion"
        echo -e "4. Salir\n"
        read -p "Ingrese opcion: " option

        if [[ $option == 1 ]]; then
            listarMascotas
        elif [[ $option == 2 ]]; then
            adoptarMascotas
        elif [[ $option == 3 ]]; then
            cerrarSesion
        elif [[ $option == 4 ]]; then
            salir
        else
            echo "Debe ingresar un valor valido"
        fi
    fi
}

listarMascotas() {
    # Se muestra la lista de mascotas disponibles
    # Formato: Nombre - Tipo - Edad - Descripcion
    # Formato del txt: ID:TIPO:NOMBRE:SEXO:EDAD:DESCRIPCION:FECHA_INGRESO
    echo "Mascotas disponibles: "

    # IFS = Internal Field Separator
    while IFS=: read -r id tipo nombre sexo edad descripcion fecha_ingreso; do
        echo "$nombre - $tipo - $edad - $descripcion"
    done <mascotas.txt
}

adoptarMascotas() {
    # Se muestra la lista de mascotas disponibles
    # Formato: ID - Nombre
    # Formato del txt: ID:TIPO:NOMBRE:SEXO:EDAD:DESCRIPCION:FECHA_INGRESO
    echo "Mascotas disponibles: "

    # IFS = Internal Field Separator
    while IFS=: read -r id tipo nombre sexo edad descripcion fecha_ingreso; do
        echo "$id - $nombre"
    done <mascotas.txt

    mascota=""
    while [[ $mascota == "" ]]; do
        read -p "Ingrese el ID de la mascota que desea adoptar: " id_mascota
        mascota=$(grep "^$id_mascota:" mascotas.txt)
        if [[ $mascota != "" ]]; then
            echo "Mascota adoptada"
            # Se elimina la mascota de la lista de mascotas
            sed -i "/^$id_mascota:/d" mascotas.txt #-i es para modificar el archivo y /d es para eliminar la linea

            # Formato: id:tipo:nombre:sexo:edad:descripcion:fecha_ingreso:fecha_adopcion
            # Seleccionar nombre e id de mascota
            # -d es para indicar el delimitador y -f es para indicar el campo
            nombre_mascota=$(echo $mascota | cut -d':' -f 3)
            tipo_mascota=$(echo $mascota | cut -d':' -f 2)
            id_mascota=$(echo $mascota | cut -d':' -f 1)
            sexo_mascota=$(echo $mascota | cut -d':' -f 4)
            edad_mascota=$(echo $mascota | cut -d':' -f 5)
            descripcion_mascota=$(echo $mascota | cut -d':' -f 6)
            fechaIngreso=$(echo $mascota | cut -d':' -f 7)
            fechaAdop=$(date +"%d/%m/%Y")

            # Se guarda la mascota en el archivo de adopciones
            echo "$id_mascota:$tipo_mascota:$nombre_mascota:$sexo_mascota:$edad_mascota:$descripcion_mascota:$fechaIngreso:$fechaAdop" >>adopciones.txt

        else
            echo "No se encontro la mascota"
        fi
    done

}
registrarUsuario() {
    prueba="no"
    echo -e "\nIngrese el nombre del nuevo usuario:"
    read newName
    echo -e "\nIngrese la cedula del nuevo usuario:"
    read newUser
    yaExiste=false
    while IFS=: read -r nombre cedula telefono fecha; do
        if [[ $newUser == $cedula ]]; then
            yaExiste=true
        fi
    done <users.txt
    if [[ $yaExiste == false ]]; then
        echo -e "\nIngrese el numero de telefono del nuevo usuario:"
        read newNum
        validDate=false
        while [[ $validDate == false ]]; do
            echo -e "\nIngrese la fecha de nacimiento del nuevo usuario:"
            read newDate
            #format "%d/%m/%Y"
            if [[ $newDate =~ ^([0-2][0-9]|3[0-1])/(0[1-9]|1[0-2])/[0-9]{4}$ ]]; then
                validDate=true
            else
                echo -e "\nIngrese una fecha valida en formato dd/mm/aaaa"
            fi
        done
        iguales=false
        while [[ $iguales == false ]]; do
            echo -e "\nIngrese la contraseña:"
            read -s newPass
            echo -e "\nIngrese nuevamente la contraseña:"
            read -s newPass2
            if [[ $newPass == $newPass2 ]]; then
                iguales=true
            else
                echo -e "\nLas contraseñas no coinciden"
            fi
        done
        validOption=false
        while [[ $validOption == false ]]; do
            echo -e "\n¿Desea que el nuevo usuario sea administrador?"
            echo "1. Si"
            echo -e "2. No\n"
            read -p "Ingrese opcion: " type
            if [[ $type == 1 || $type == 2 ]]; then
                if [[ $type == 1 ]]; then
                    type="admin"
                else
                    type="user"
                fi
                validOption=true
            else
                echo -e "\nIngrese una opcion valida"
            fi
        done
        echo "$newUser:$newName:$newPass:$type:$newNum:$newDate" >>users.txt
        echo -e "\nEl usuario fue registrado exitosamente"
    else
        echo -e "\nYa existe un usuario registrado con esa cedula"
    fi
}

# registroMascota(){

# }

estadisticas() {
    declare -A noAdoptados
    declare -A adoptados

    # Contar los animales no adoptados
    while IFS=: read -r id tipo nombre sexo edad desc fecIngreso; do
        noAdoptados[$tipo]=$((noAdoptados[$tipo] + 1))
    done <mascotas.txt

    # Contar los animales adoptados
    while IFS=: read -r id tipo nombre sexo edad desc fecIngreso fecAdop; do
        found=$(grep "^$id:" adopciones.txt)
        if [[ $found != "" ]]; then
            adoptados[$tipo]=$((adoptados[$tipo] + 1))
        fi
    done <adopciones.txt

    echo "Porcentajes de adopciones: "
    for tipo in "${!noAdoptados[@]}"; do
        total=$((noAdoptados[$tipo] + adoptados[$tipo]))
        if [[ $total -gt 0 ]]; then
            porcentaje=$((adoptados[$tipo] * 100 / total))
            echo "$tipo: $porcentaje%"
        else
            echo "$tipo: 0%"
        fi
    done

    # Determinar en que mes se realizan mas adopciones
    meses=(Enero Febrero Marzo Abril Mayo Junio Julio Agosto Septiembre Octubre Noviembre Diciembre)
    adopcionesMes=(0 0 0 0 0 0 0 0 0 0 0 0)
    while IFS=: read -r id tipo nombre sexo edad desc fecIngreso fecAdopcion; do
        mes=$(echo $fecAdopcion | cut -d'/' -f 2)
        # Sacar 0 si el mes es menor a 10
        mes=$(echo $mes | sed 's/^0*//')
        adopcionesMes[$((mes - 1))]=$((${adopcionesMes[$((mes - 1))]} + 1))
    done <adopciones.txt

    max=0
    mes=""
    for i in {0..11}; do
        if [[ ${adopcionesMes[$i]} -gt $max ]]; then
            max=${adopcionesMes[$i]}
            mes=${meses[$i]}
        fi
    done

    if [[ $max -gt 0 ]]; then
        echo "El mes con mas adopciones es $mes"
    else
        echo "No hay adopciones"
    fi

    # Edad promedio de los animales adoptados
    totalEdad=0
    totalAnimales=0
    while IFS=: read -r id tipo nombre sexo edad desc fecIngreso fecAdopcion; do
        totalEdad=$((totalEdad + edad))
        totalAnimales=$((totalAnimales + 1))
    done <adopciones.txt

    if [[ $totalAnimales -gt 0 ]]; then
        edadPromedio=$((totalEdad / totalAnimales))
        echo "La edad promedio de los animales adoptados es $edadPromedio"
    else
        echo "No hay animales adoptados"
    fi

}

salir() {
    app=false
}

cerrarSesion() {
    admin=false
    logged=false
    echo -e "\nSesion cerrada"
}

##########################################
##########################################
##########################################
##########################################

echo "Bienvenido al sistema, inicie seción"

while [[ $app == true ]]; do
    while [[ $logged == false ]]; do
        login
    done
    option $admin
done
