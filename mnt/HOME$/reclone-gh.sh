#!/bin/bash
apt-get install -y git

echo "  WARNING!
    Any changes you made in $HOME/dvlw are about to be erased.

    continue or exit?"
read -r -p "
(continue)
" reclone
if [ "$reclone" = "" ]; then
    echo 'rm -rf dvlw/* || echo "could not remove dvlw directory .."'
    echo 'rm -rf dvlw/.* || echo "could not remove git server .."'
fi

repo_owner=kindtek && \
repo_name=devels-workshop && \
repo_url=https://github.com/${repo_owner}/${repo_name} && \
repo_path=dvlw && \
repo_branch=main && \
echo repo_owner: $repo_owner && \
echo repo_name: "$repo_name" && \
echo repo_url: "$repo_url" && \
echo repo_path: "$repo_path" && \
echo repo_branch: "$repo_branch" && \
git clone "$repo_url" --single-branch --branch "$repo_branch" --filter=blob:limit=13k --progress -- "$repo_path" 2>/dev/nullcd dvlw && \
cd dvlw && \
git submodule update --init --remote --filter=blob:limit=13k --progress -- dvlp dvl-adv powerhell 2>/dev/null && \
chmod -R 1770 dvlp/mnt/HOME$ && \
chmod -R 1770 dvlp/mnt/bak && \
cd dvlp && \
git submodule update --init --progress --filter=blob:limit=20m -- kernels 
