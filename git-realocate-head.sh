# moving realocate head
git branch tmp
git checkout release
git merge tmp
git branch -d tmp
