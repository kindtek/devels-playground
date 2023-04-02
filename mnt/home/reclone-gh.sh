rm -rf dvlw
git clone https://github.com/kindtek/devels-workshop --filter=blob:limit=1024000 --depth=1 --single-branch --progress dvlw || (cd dvlw && git pull) 
cd dvlw
git submodule update --init --remote --depth=2 --progress || git pull