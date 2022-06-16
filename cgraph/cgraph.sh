#!/bin/bash

function usage
{
    echo "$*"
    echo "usage: cgraph [-a <NUM>] [-d <NUM>] [-e <NUM>] [-r <NUM>] [-f <file1 file2...>] [-T <TYPE>] [-o <NAME>] [-m <MODE>] [-h]"
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
    echo "-f [filename] :"
    echo "           The files you want to produce call graph"
    echo "           (*) all .c file in the folder"
    echo "           use \"filename1 filename2\" to set multiple files as input files" 
    echo "-T [TYPE] :"
    echo "  (*)jpg   Output .jpg file"
    echo "     png   Output .png file"
    echo "     gif   Output .gif file"
    echo "     svg   Output .svg file"
    echo "-o [FILENAME] :"
    echo "           output file name"
    echo "           (*)a.out"
    echo "-m [MODE] :"
    echo "  (*)dot   Digraph (layering)"
    echo "     neato Based on spring-model"
    echo "     twopi Radial layout"
    echo "     circo Circle layout"
    echo "     fdp   Undigraph"
    echo "     patchwork Square tree"
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
graph="dot"
xdot_type="-Tjpg"
xdot_output="-o a.jpg"

while getopts ":a:d:e:r:T:o:m:fh" opt; do
    case $opt in
        a)
            if [ "$OPTARG" == 1 ]; then
                cflow_opt_A="-A"
            else
                if [[ "$OPTARG" == 2 ]]; then
                    cflow_opt_A="-A -A"
                else
                    echo "$0: invalid option argument $OPTARG";
                    usage;
                    exit 0;
                fi
            fi
        ;;
        d)
            cflow_opt_d="-d $OPTARG"
        ;;
        e)
            if [[ $OPTARG == 0 ]]; then
                tree_e=0
            else if [ $OPTARG != 1 ]; then
                    echo "$0: invalid option argument $OPTARG";
                    usage;
                    exit 0;
                fi
            fi
        ;;
        r)
            if [ $OPTARG == 0 ]; then
                tree_r=0
            else if [ $OPTARG != 1 ]; then
                    echo "$0: invalid option argument $OPTARG";
                    usage;
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
        m)
            if [[ $OPTARG == "dot" ]] || [[ $OPTARG == "neato" ]] || [[ $OPTARG == "twopi" ]] || [[ $OPTARG == "circo" ]] || [[ $OPTARG == "fdp" ]] || [[ $OPTARG == "sfdp" ]] || [[ $OPTARG == "patchwork" ]]; then
                graph="$OPTARG";
            else
                echo "$0: unknow output mode $OPTARG";
                usage;
                exit 1;
            fi
        ;;
        :)
            echo "$0: miss option argument: -$OPTARG";
            usage;
            exit 1;
        ;;
        h|\?)
            if [ $opt != "h" ]; then
                echo "$0: invalid option: -$OPTARG";
            fi
            usage ;
            exit 1;
        ;;
    esac
done

cflow_opt="-b $cflow_opt_A $cflow_opt_d $cflow_opt_file"

sudo cflow $cflow_opt| tree2dotx -e $tree_e -r $tree_r | awk '!a[$0]++' > out.dot
$graph $xdot_type out.dot $xdot_output

echo "build call graph success."