#!/bin/bash

find ../sysroot/usr/lib/ -type l -ls | awk '
BEGIN {
    n=0
    root="/home/denis/projects/defigo/sysroot"
    abs=sprintf("%s/usr/lib/", root)
}
{
    if ( substr($13,1,1) == "/" && $13 ~ /\.so/ ) {
        trg[n] = $13
        lnk[n++] = substr($11, 20)
    }
}
END {
    for ( x = 0; x < n; x++)
        printf("ln -s -r -f %s%s %s%s\n", root, trg[x], abs, lnk[x])
    # system(sprintf("echo %s", out[x]))

}'