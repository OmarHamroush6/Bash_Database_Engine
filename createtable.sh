#!/usr/bin/bash

export LC_COLLATE=C
shopt -s extglob
read -p "what is database name " mydb

#function to check if primary key or not

datatypeis(){
    echo " what is the data type of the field ?"
    options=("if int press 1" "if string press 2")
    select opt in "${options[@]}"
    do
    case $opt in
        "if int press 1")
            echo "int"
            datatype="int"           
            echo -n $datatype":" >> ./databases/$mydb/$tableName-metadata
            break;
            ;;
        "if string press 2")
            echo "string"
            datatype="string"
            echo -n $datatype":" >> ./databases/$mydb/$tableName-metadata
            break;
            ;;
        *) echo "invalid option $REPLY please try again";;
    esac
    done

}


read -p "Enter table name you want to create : " tableName

#function to test table name regex
namingRegex(){
    while (true)
    do
        if [[ $tableName =~ ^[a-zA-Z]+[a-zA-Z0-9]*$ ]] ; then
            break;
        else
            echo -e "\n Please Enter A Vaild Name (only letters preferred) " 
            read -p "Enter table name you want to create : " tableName
        fi
    done
}

namingRegex

pkname(){
    read -p "enter name of primary key column ?" pk
    if [ $pk ];then 
        echo "pk:$pk" >> ./databases/$mydb/$tableName-metadata
        datatypeis
        echo -n $pk":" >> ./databases/$mydb/$tableName
    else
        pkname
    fi
}

if [ -f databases/$mydb/$tableName ] ;then
    echo "Table with name $tableName already exists" 
else 
    touch databases/$mydb/$tableName
    touch databases/$mydb/$tableName-metadata


#check num of column is exist and integer
    while true
    do
    read -p "Enter number of coloumns : " columnsNum
    if [[ $columnsNum ]] && [[ "$columnsNum" =~ ^[0-9]+$ ]];then
        break
    fi
    done

    pkname
    declare -i i=2
    while (( i < $columnsNum+1 ))
    do
        read -p "Enter column $i name : " columnName; 
        if [ $columnName ] ; then
        datatypeis
        echo -n $columnName":" >> ./databases/$mydb/$tableName
        i=($i+1)
        else
            continue
        fi
    done
fi
echo " "
bash ./TableMainMenu.sh