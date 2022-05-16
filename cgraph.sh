#!/bin/bash

function usage
{
    echo ""
    echo "usage: cgraph [-a <NUM>] [-d <NUM>] [-e <NUM>] [-r <NUM>] [-f <file1 file2...>] [-T <TYPE>] [-o <NAME>] [-h]"
    echo ""
    echo "-a [NUM] :"
    echo "  (*)0     Produce graphs only for main function"
    echo "     1     Produce graphs for all global functions"
    echo "     2     Produce graphs for all functions"
    echo "-d [NUM] :"
    echo "           Set the depth at which the flow graph is cut of"
    echo "-e [NUM] :"
    echo "     0     Disable display file name where the function is located"
    echo "  (*)1     Enable display file name where the function is located"
    echo "-r [NUM] :"
    echo "     0     Disable output in the order in which the functions appear"
    echo "  (*)1     Enable output in the order in which the functions appear"
    echo "-f (filename1 filename 2...) :"
    echo "           The files you want to produce call graph"
    echo "           (*) all .c file in the folder"
    echo "-T [TYPE] :"
    echo "  (*)jpg   Output .jpg file"
    echo "     png   Output .png file"
    echo "     gif   Output .gif file"
    echo "     svg   Output .svg file"
    echo "-o [FILENAME] :"
    echo "           output file name"
    echo "           (*)a.out"
    echo "-h :"
    echo "     Get useage" 
    echo ""
}

cflow_opt_A=""
cflow_opt_d=""
cflow_opt_file="*.c"
cflow_opt=""
tree_e=1
tree_r=1
xdot_type="-Tjpg"
xdot_output="-o a.jpg"

while getopts "a:d:e:r:T:o:h" opt; do
    case $opt in
        a)
            if [ "$OPTARG" -eq 1 ]; then
                cflow_opt_A="-A"
            else
                if [ "$OPTARG" -eq 2 ]; then
                    cflow_opt_A="-A -A"
                else
                    echo "usage: -a 0 or -a 1 or -a 2";
                    exit 0;
                fi
            fi
        ;;
        d)
            cflow_opt_d="-d $OPTARG"
        ;;
        e)
            if [ $OPTARG -eq 0 ]; then
                tree_e=0
            else if [ $OPTARG -ne 1 ]; then
                    echo "useage -e 0 or -e 1";
                    exit 0;
                fi
            fi
        ;;
        r)
            if [ $OPTARG -eq 0 ]; then
                tree_r=0
            else if [ $OPTARG -ne 1 ]; then
                    echo "useage -r 0 or -r 1";
                    exit 0;
                fi
            fi
        ;;
        T)
            xdot_type="-T$OPTARG"
        ;;
        o)
            xdot_output="-o $OPTARG"
        ;;
        f)
            cflow_opt_file=$OPTARG
        ;;
        h|?)
            usage ;
            exit 1;
        ;;
    esac
done

cflow_opt="-b $cflow_opt_A $cflow_opt_d $cflow_opt_file"

sudo cflow $cflow_opt| tree2dotx -e $tree_e -r $tree_r | awk '!a[$0]++' > out.dot
dot $xdot_type out.dot $xdot_output
