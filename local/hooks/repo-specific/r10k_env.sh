#!/bin/bash
#
# https://github.com/sciurus/r10k-git-hook
echo "$@"

umask 0022
while read oldrev newrev refname; do
    echo "oldrev:$oldrev newrev:$newrev refname:$refname"
    if [[ $refname =~ 'refs/heads/' ]]; then
        branch=$(git rev-parse --symbolic --abbrev-ref $refname)
        files=$(git diff-tree -r --name-only --no-commit-id ${oldrev}..${newrev})
        if [[ $files =~ 'Puppetfile' ]]; then
            echo "r10k updating $branch environment and modules"
            echo "/usr/local/bin/r10k deploy environment $branch -p"
            /usr/bin/sudo /usr/local/bin/r10k deploy environment $branch -p
        else
            echo "r10k updating $branch environment"
            echo "/usr/local/bin/r10k deploy environment $branch"
            /usr/bin/sudo /usr/local/bin/r10k deploy environment $branch
        fi
    else
        echo "r10k skipping $refname"
    fi
done
touch /tmp/fiskening2
