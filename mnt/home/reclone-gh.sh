apt-get install -y git
rm -rf dvlw
git clone https://github.com/kindtek/devels-workshop --single-branch --progress dvlw || (cd dvlw && git pull) 
cd dvlw
git submodule update --init --progress || git pull