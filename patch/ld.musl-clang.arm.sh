#!/bin/sh
cc="clang"
libc_lib="/usr/lib"
ldso="/lib/ld-musl-aarch64.so.1"
cleared=
shared=
userlinkdir=
userlink=

for x ; do
    test "$cleared" || set -- ; cleared=1

    case "$x" in
        -L-user-start)
            userlinkdir=1
            ;;
        -L-user-end)
            userlinkdir=
            ;;
        -L*)
            test "$userlinkdir" && set -- "$@" "$x"
            ;;
        -l-user-start)
            userlink=1
            ;;
        -l-user-end)
            userlink=
            ;;
        crtbegin*.o|crtend*.o)
            set -- "$@" $($cc -print-file-name=$x)
            ;;
        -lgcc|-lgcc_eh)
            file=lib${x#-l}.a
            set -- "$@" $($cc -print-file-name=$file)
            ;;
        -l*)
            test "$userlink" && set -- "$@" "$x"
            ;;
        -shared)
            shared=1
            set -- "$@" -shared
            ;;
        -sysroot=*|--sysroot=*)
            ;;
        *)
            set -- "$@" "$x"
            ;;
    esac
done

exec $($cc -print-prog-name=ld) -nostdlib "$@" -lc -dynamic-linker "$ldso"
