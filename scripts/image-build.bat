@REM TODO: build images with custom username/groupname then push
@REM docker build --build-arg username=!username! --build-arg groupname=!groupname! -f ../dockerfile.alpine -t dbp_phat
@REM docker build --build-arg username=!username! --build-arg groupname=!groupname! -f ../dockerfile.ubuntu -t dbp_phat
@REM docker image push kindtek/dbp