#!/bin/bash
#
# tree2dotx --- transfer a "tree"(such as the result of tree,calltree,cflow -b)
#                 to a picture discribed by DOT language(provided by Graphviz)
#
# Author: falcon <wuzhangjin@gmail.com>
# Update: 2007-11-14, 2015-3-19
# Usage:
#
#       tree -L 2 -d /path/to/a/directory | bash tree2dotx | dot -Tsvg -o tree.svg
#       cd /path/to/a/c/project/; calltree -gb -np -m *.c | bash tree2dotx | dot -Tsvg -o calltree.svg
#       cd /path/to/a/c/project/; cflow -b -m setup_rw_floppy kernel/blk_drv/floppy.c | bash tree2dotx | dot -Tsvg -o cflow.svg
#

# Set the picture size, direction(LR=Left2Right,TB=Top2Bottom) and shape(diamond, circle, box)
size="1920,1080"
direction="LR"
shape="box"

# color, X11 color name: http://en.wikipedia.org/wiki/X11_color_names
fontcolor="blue"
fillcolor="Wheat"

# fontsize
fontsize=16

# Specify the symbols you not concern with space as decollator here
filterstr="";

input=`cat`

# output: dot, flame
output="dot"

has_subgraph="0"
ordering="0"

# Usage

#grep -v ^$ | cat

function usage
{
        echo ""
        echo "  $0 "
        echo ""
        echo "     [ -f  \"filter1 filter2 ...\" ]"
        echo "     [ -s  size, ex: 1080,760; 1920,1080 ]"
        echo "     [ -d  direction, ex: LR; TB ]"
        echo "     -h  get help"
        echo ""
}

function subgraph() {
	echo "$input" \
	| grep -e " at " \
	| sed 's/).* at /)/g;s/:.*//g;s/ //g' \
	| sed -r 's/^(.*)\(\)(.*)$/\tsubgraph "cluster_\2" { label="\2";\1;}/' \
	| sort -u
}

while getopts "f:s:S:d:e:h:o:r:" opt;
do
        case $opt in
                f)
                        filterstr=$OPTARG
                ;;
                s)
                        size=$OPTARG
                ;;
                S)
                        shape=$OPTARG
                ;;
                d)
                        direction=$OPTARG
                ;;
                e)
                        has_subgraph=$OPTARG
		;;
		o)
                        output=$OPTARG
                ;;
 		r)
                        ordering=$OPTARG
                ;;
                h|?)
                        usage $0;
                        exit 1;
                ;;
        esac
done

# Transfer the tree result to a file described in DOT language

echo "$input" | \
grep -v ^$ | grep -v "^[0-9]* director" \
| sed -e "s/ <.*>.*//g" | tr -d '\(' | tr -d '\)' | tr '|' ' ' \
| sed -e "s/ \[.*\].*//g" \
| awk '{if(NR==1) system("basename "$0); else printf("%s\n", $0);}' \
| awk -v fstr="$filterstr" '# function for filter the symbols you not concern
        function need_filter(node) {
                for ( i in farr ) {
                    if (match(node,farr[i]" ") == 1 || match(node,"^"farr[i]"$") == 1) {
                            return 1;
                    }
                }
                return 0;
        }
        BEGIN{
                # Filternode array are used to record the symbols who have been filtered.
                oldnodedepth = -1; oldnode = ""; nodep[-1] = ""; filter[nodep[-1]] = 0;
                oldnodedepth_orig = -1; nodepre = 0; nodebase = 0; nodefirst = 0;
                output = "'$output'";

                #printf("output = %s\n", output);

                # Store the symbols to an array farr
                split(fstr,farr," ");

                # print some setting info
                if (output == "dot") {
                    printf("digraph G{\n");

		    if(ordering == "1") {
		    	printf("ordering=out;\n");
	    	    }
		    printf("ranksep = 1;\n");
                    
		    printf("\trankdir='$direction';\n");
                    printf("\tsize=\"'$size'\";\n");
                    printf("\tnode [fontsize='$fontsize',fontcolor='$fontcolor',style=filled,fillcolor='$fillcolor',shape='$shape'];\n");
                }
        }{
                # Get the node, and its depth(nodedepth)
                # nodedepth = match($0, "[^| `]");
                nodedepth = match($0, "[[:digit:]|[:alpha:]]|[[:alnum:]]");
                node = substr($0,nodedepth);

                # printf("%d %d %s \n", nodedepth, oldnodedepth_orig, node);
                if (nodefirst == 1 && oldnodedepth_orig > 0) {
                        nodefirst = 0;
                        nodebase = nodedepth-oldnodedepth_orig;
                }

                if (nodedepth == 0)
                        nodedepth=1;

                tmp = nodedepth;
                # printf("pre=%d base=%d np=%d oldnp=%d node=%s \n", nodepre, nodebase, tmp, oldnodedepth_orig, node);

                if (nodedepth != 0 && oldnodedepth_orig == -1) {
                        nodepre = nodedepth-1;
                        nodefirst = 1;
                        nodedepth = 0;
                } else if (nodebase != 0) {
                        nodedepth = int((nodedepth-nodepre)/nodebase);
                }

                # if whose depth is 1 less than him, who is his parent
                if (nodedepth-oldnodedepth == 1) {
                        nodep[nodedepth-1] = oldnode;
                }

                # for debugging
                # printf("%d %s\n", nodedepth, node);
                # printf("\t\"%s\";\n",node);
                # print the vectors

                if (oldnodedepth != -1) {
                        # if need filter or whose parent have been filter, not print it, and set the flat of filter to 1
                        if (need_filter(node) || filter[nodep[nodedepth-1]] == 1) {
                                filter[node] = 1;
                        #       printf("node = %s, filter[node] = %d\n", node, filter[node]);
			} else if (nodep[nodedepth-1] != "") {
                                if (output == "dot") {
                                    printf("\t\"%s\" -> \"%s\";\n", nodep[nodedepth-1], node, nodep[nodedepth-1], node);
                                } else {
                                    for (i = 0; i < nodedepth; i++)
                                        printf("%s;", nodep[i]);
                                    printf("%s 1\n", node);
                                }
                        #       printf("\t\"%s\" -> \"%s\"[label=\"%s>%s\"];\n", nodep[nodedepth-1], node, nodep[nodedepth-1], node);
                        }
                }

                # save the old depth and the old node
                oldnodedepth_orig = tmp;
                oldnodedepth = nodedepth;
                oldnode = node;
        } END {
#                if (output == "dot")
#			printf("}");
        }'

echo ""
if [ $has_subgraph == "1" ]
then
	subgraph
fi
echo "}"

