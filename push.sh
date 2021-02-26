git add ./

git commit -m "$(echo $(date) | awk '{print $7" "$2" "$3}')" --allow-empty
git push origin master
