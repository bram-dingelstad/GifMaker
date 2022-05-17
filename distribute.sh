#!/bin/bash 

cd distro || exit

for file in $(ls ../); do
    if [[ $(echo "$file" | grep -E "distr|\.gif$|README" | wc -l) -eq 0 ]]; then
        cp -R "../$file" .
    fi
done

rm -rf addons/GifMaker/godot-gdgifexporter/.git

git add .
git commit -m "Updated distribution"
git push
