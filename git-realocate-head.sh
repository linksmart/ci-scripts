# moving realocate head
git branch tmp
git checkout ${TRAVIS_BRANCH}
git merge tmp
git branch -d tmp
