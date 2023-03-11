@REM TODO: build images with custom username/groupname then push
@REM docker build --build-arg username=!username! --build-arg groupname=!groupname! -f ../dockerfile.alpine.yaml -t dplay_
@REM docker build --build-arg username=!username! --build-arg groupname=!groupname! -f ../dockerfile.ubuntu.yaml -t dplay_msdot
@REM docker image push kindtek/dplay

@REM ubuntu
docker compose -f ../docker-compose.ubuntu.yaml up
@REM alpine
@REM docker compose -f ../docker-compose.alpine.yaml up
