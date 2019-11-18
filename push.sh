git add ./

git commit -m "$(echo $(date) | grep -E -o '[0-9]+月.+[0-9]+日')"
git push origin master
