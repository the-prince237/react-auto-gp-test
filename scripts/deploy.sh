#!/usr/bin/env sh
# abort on errors
set -e

git add .

if git diff-index --quiet HEAD --; 
    then 
        echo WORK TREE VERY VERY CLEAN ":)"

        # push project
        git push -u origin HEAD

        # build
        yarn build

        # create and checkout to gh-pages branch
        git checkout --orphan gh-pages

        # navigate into the build output directory, add and commit changes
        git --work-tree build add --all
        git --work-tree build commit -m "Deploy"

        # push build 
        git push origin HEAD:gh-pages --force

        # remove build folder : dist and gh-pages branch
        rm -r build
        git checkout -f main
        git branch -D gh-pages

    else echo commiting changes ... 
        echo There are still not commited changes. Use \"git add\" and \"git commit\" or just \"yarn commit\" "for" quick commits
fi

