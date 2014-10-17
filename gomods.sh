#!/bin/bash

go() {
    GOBIN=$(/usr/bin/which go)
    GOMODS=`pwd`/go_modules

    if [ "$1" == "init" ]; then
        gomods_init
        return $?
    fi

    if [ -d "$GOMODS" ]; then
        gomods_exec "$@"
        return $?
    fi

    $GOBIN "$@"
}

gomods_exec() {
    GOPATH="$GOMODS" $GOBIN $@
}

gomods_init() {
    if [ -d "$GOMODS" ]; then
      echo "It looks like this project has already been initialized. Exiting..."
      return 1
    fi

    echo "Initializing project $(basename $(pwd))..."

    local missing_deps=()
    local copy_deps=()

    local deps
    deps=$(go list -f '{{ join .Deps "\n" }}' 2>&1)
    if [ $? != 0 ]; then
        local exit_code=$?
        gomods_mkdir
        echo "Done!"
        return $exit_code
    fi

    for dep in $deps; do
        local standard
        standard=$(go list -f '{{.Standard}}' "$dep" 2>&1)
        if [ $? != 0 ]; then
            missing_deps+=("$dep")
        else
            if [ "$standard" == "false" ]; then
                copy_deps+=("$dep")
            fi
        fi
    done

    gomods_mkdir

    for dep in "${copy_deps[@]}"; do
        echo "Copying existing dependency $dep..."
        local dep_root=${dep%/*}
        mkdir -p "$GOMODS/src/$dep_root"
        cp -r "$GOPATH/src/$dep" "$GOMODS/src/$dep_root/"
    done

    for dep in "${missing_deps[@]}"; do
        echo "Installing missing dependency $dep..."
        gomods_exec get -d "$dep"
    done

    echo "Done!"
    return 0
}

gomods_mkdir() {
    mkdir -p $GOMODS/src
    echo "/pkg" > "$GOMODS/.gitignore"
    echo "/bin" >> "$GOMODS/.gitignore"
}
