apt-get install -y git
rm -rf dvlw || echo 'couldn't remove dvlw directory ..'
git clone https://github.com/kindtek/devels-workshop --single-branch --progress dvlw || (cd dvlw && git pull) 
cd dvlw
git submodule update --init --progress || git pull