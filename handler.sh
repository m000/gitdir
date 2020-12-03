#!/usr/bin/env zsh

make_ts() {
    local Y m d j H M
    date '+%Y %m %d %j %H %M' | read Y m d j H M
    printf "%d%02d%02d.%04d" "$Y" "$m" "$d" "$(( $H*60 + $M ))"
}
repo=$(git rev-parse --show-toplevel)
ts=$(make_ts)

add_new_files() {
    local nf
    nf=$(git ls-files . --exclude-standard --others)
    git ls-files . --exclude-standard --others -z | xargs -0 git add
    git commit \
        -m "$(printf "Adding new files. Timestamp: %s" "$ts")" \
        -m "$(printf "Files:\n%q" "$nf")"
}

update_files() {
    if git check-ignore -q $1 > /dev/null; then
        printf "Ignoring %q.\n" $1
    else
        printf "Updating %q.\n" "$1"
        ##git add "$1"
        #git commit -m "$(printf "Updated %q. Timestamp: %s." "$1" "$ts")"
    fi
}


if [ -d $1 ]; then
    printf "Directory modification. ts=%s\n" "$ts"
    add_new_files
elif [ -f $1 ]; then
    printf "File update. ts=%s\n" "$ts"
    update_files $1
else
    printf "Unsupported file type for %q.\n" $1
fi

#realpath --relative-to="$file1" "$file2"
