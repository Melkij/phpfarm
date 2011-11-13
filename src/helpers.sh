#!/bin/bash
# provides helper functions for phpfarm

parse_version() {
    # Parses a version string and returns
    # its components.
    # Inputs:
    # $1: version string to parse.
    #     Eg. "5.4.0RC1-debug-unknown_token"
    #     Valid tokens: zts, debug, 32bits, gcov.
    #
    # Outputs:
    # $VMAJOR: major number (5)
    # $VMINOR: minor number (4)
    # $VPATCH: patch number (0RC1)
    # $DEBUG: set to 1 if asked for debugging support
    # $ZTS: set to 1 if asked for ZTS support
    # $ARCH32: set to 1 for a 32bits build on a 64bits machine
    # $GCOV: set to 1 if asked for GCOV support
    # $SHORT_VERSION: same as $VMAJOR.$VMINOR.$VPATCH
    # $VERSION: full version string, normalized.
    #           Eg. "5.4.0RC1-debug-zts-32bits-gcov"
    #           when all possible tokens are used.
    v=`echo "$1" | sed -e 's/[-.]/ /g'`

    # empty version string or contained only '.' or '-'.
    if [ -z `echo "$v" | sed -e 's/ //g'` ]; then
        return 1
    fi

    # basic information
    VMAJOR=`echo "$v" | cut -d ' ' -f 1`
    VMINOR=`echo "$v" | cut -d ' ' -f 2`
    VPATCH=`echo "$v" | cut -d ' ' -f 3`
    v=`echo "$v" | cut -d ' ' -f 4-`

    # extract tokens & set flags accordingly
    DEBUG=0
    ZTS=0
    ARCH32=0
    GCOV=0
    for p in $v; do
        if [ "$p" = "debug" ]; then
            DEBUG=1
        fi
        if [ "$p" = "zts" ]; then
            ZTS=1
        fi
        if [ "$p" = "32bits" ]; then
            ARCH32=1
        fi
        if [ "$p" = "gcov" ]; then
            GCOV=1
        fi
    done

    # normalize version string
    VERSION="$VMAJOR.$VMINOR.$VPATCH"
    SHORT_VERSION="$VERSION"
    if [ $DEBUG = 1 ]; then
        VERSION="$VERSION-debug"
    fi
    if [ $ZTS = 1 ]; then
        VERSION="$VERSION-zts"
    fi
    if [ $ARCH32 = 1 ]; then
        VERSION="$VERSION-32bits"
    fi
    if [ $GCOV = 1 ]; then
        VERSION="$VERSION-gcov"
    fi
    return 0
}

