Date: 2011-01-14 11:00:31
Title: Jdep-grapher: make a dependency tree of your Java projects
Category: Articles

Oh, my first english post ... so amazing (_isn't it ?_). Well, I present a little (_and awful_) bash dependency graph generator for Java projects.

One goal of my job is to maintain the [Quercus](https://github.com/CleverCloud/Quercus) project. It is currently highly dependent of Resin, another Caucho's project, and a removal is needed. To know what I need to remove first, I wanted a graphical representation of all links between projects. We can consider that dependencies could be computed with 'import' Java keyword. Yes I know, it's not a perfect dependencies representation but it's currently the best way I found (_and faster_). Finally, we need a graph generation tool ... I found [GraphViz](http://www.graphviz.org/) which can be directly used in CLI and we use [DOT format file](http://www.graphviz.org/doc/info/lang.html) to make the graph specifications. One day after ... [Jdep-grapher](https://github.com/Kdecherf/jdep-grapher) is released.

**How does it work ?**  

It will first get the list of files to parse (with find) and extract all lines beginning with 'import' and 'package' (_we use temp files with `mktemp`_) :
``` bash
find $DIR -type f -name "*.java" > $FILES
grep -E "^package|^import" $(< $FILES) | awk -F':' '{print $2}' > $GREP
```

Next it creates links between packages and uses DOT format :
``` bash
while read type name
do
	name=`echo $name | tr -d ";"`
	pkg=`echo $name | tr -d "."`
	if [[ "$type" == "package" ]]; then
		echo "$pkg [label=\"$name\", style = filled, shape = box];"
		CPKG=$pkg
	else
		ALL=`echo $pkg | grep "\*" | wc -l`
		SUP=""
		LNK=""
		if [[ $ALL -eq 1 ]]; then
			pkg=`echo $pkg | sed s/"*"/"allpkg"/`
			SUP=", color=red, style = filled"
                        LNK=" [color=red]"
		fi
		echo "$pkg [label=\"$name\"$SUP];"
		echo "$CPKG -> $pkg $LNK;"
	fi
done < $GREP | sort -u > $COMPUTE
```

`sort -u` at the end of loop will automatically remove duplicates and send the result to a new temp file. All-inclusion packages (with \*) are filled in red.  
  

We can exclude useless links (eg. internal dependencies) with :
``` bash
grep -vE "$EXCLUDE" $COMPUTE > $TMPDOT
```

To reduce the weight of graph, it removes single nodes :
``` bash
CT=`grep -E "$rpkg( |;)" $TMPDOT | wc -l`
	if [[ $CT -gt 1 ]]; then
		echo $rpkg $rop $rchild >> $TMPDOT2
	fi
```

Finally, the script closes the DOT file and launches graphviz ...
``` bash
echo "digraph G {" > $DOT
cat $TMPDOT2 >> $DOT
echo "}" >> $DOT

fdp -Tpng < $DOT > $GRAPH
```

Enjoy

Example : Resin Dependency Graph of Quercus  

[![](/images/2011/01/36cd6dc7df67944c199c3464d395a4848a130b8e.jpg)](http://i.imgur.com/91AJN.jpg)

_Note : the script currently uses 'fdp' from graphviz which is not fully optimized for this kind of graph. Tell me if you have any other solution ;-)_

More information on [GitHub](https://github.com/Kdecherf/jdep-grapher).
