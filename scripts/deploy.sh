#!/usr/bin/env sh
# abort on errors
set -e

git add .

if git diff-index --quiet HEAD --; 
    then 
        echo WORK TREE VERY VERY CLEAN ":)"

        # push project
        git push -u origin HEAD

        # create and switch to relai branch
        git checkout --orphan relai

        # build
        yarn build

        # remove all files and folders instead of build
        rm -r public
        rm -r src
        rm *.*

        # mount all files and folders in build directory to project root
        cd build
        mv * ..
        cd ..
        rm -r build

        # clean branch tree
        git add .
        git commit -m "preparing gh-pages root"

        # Switch to gh-pages branchj and merge relai
        git checkout gh-pages
        git merge relai --allow-unrelated-histories

        # push built version to online branch
        git add .
        git commit -m "updating built version"
        git push -u origin gh-pages --force

        # delete relai branch
        git branch -D relai

        # come back to main branch
        git checkout main

    else echo commiting changes ... 
        echo There are still not commited changes. Use \"git add\" and \"git commit\" or just \"yarn commit\" "for" quick commits
fi

