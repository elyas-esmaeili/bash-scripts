#!/bin/bash
# task management bash script

COMMAND=$1
FILE="tasks.txt"

# function definition - start

# add new task
add() {
    TASK_TITLE=$1
    LTASK_TITLE=${TASK_TITLE,,}

    if [[ $LTASK_TITLE =~ .*\((very important)\)$ ]]; then
        PRIORITY="H"
    elif [[ $LTASK_TITLE =~ .*\((important)\)$ ]]; then
        PRIORITY="M"
    else
        PRIORITY="L"
    fi

    TASK_NUMBER=`cat ${FILE} | wc -l`
    echo "Added task `expr $TASK_NUMBER + 1` with priority $PRIORITY" 
    echo "$PRIORITY $TASK_TITLE" >> ${FILE}
}

# show tasks list
list () {
    TASK_NUMBER=`cat ${FILE} | wc -l`
    COUNTER=1
    if [ $TASK_NUMBER == "0" ]; then
        echo "No tasks found..."
    else
       while read -r TASK; do  
            if [[ $TASK =~ ^H.* ]]; then
                STARTS="*****"
            elif [[ $TASK =~ ^M.* ]]; then
                STARTS="***  "
            else
                STARTS="*    "
            fi

            TASK=`echo ${TASK} | cut -d' ' -f2-`
            echo "$COUNTER $STARTS $TASK"
            COUNTER=`expr $COUNTER + 1`
        done < ${FILE}
    fi
}

# remove a task by it's number
remove() {
    TASK_NUMBER=$1
    TASK_TITLE=`sed -n ${TASK_NUMBER}p ${FILE}`
    TASK_TITLE=`echo ${TASK_TITLE} | cut -d' ' -f2-`
    sed -i ${TASK_NUMBER}d ${FILE}
    echo "Completed task ${TASK_NUMBER}: ${TASK_TITLE}"

}
# function definition - end

# script - start
# check to see correct argument have passed
if [ "$COMMAND" == "add" ] || [ "$COMMAND" == "done" ]; then
    if [ "$#" -le "1" ]; then
       >&2 echo "[Error] This command needs an argument"
       exit 1
    fi
elif [ "$COMMAND" != "list" ]; then
    >&2 echo "[Error] Invalid command"
    exit 1
fi

# create task file if one does not exist
if [ ! -f "${FILE}" ]; then
    touch "${FILE}"
fi

if [ "$COMMAND" == "add" ]; then
    shift 1
    TASK_TITLE=$@
    add "$TASK_TITLE"
elif [ "$COMMAND" == "list" ]; then
    list
else 
    TASK_NUMBER=$2
    remove $TASK_NUMBER
fi
