# moving realocate head
if [ "$TRAVIS" ]
 then
    git branch tmp
    git checkout ${TRAVIS_BRANCH}
    git merge tmp
    git branch -d tmp
fi
