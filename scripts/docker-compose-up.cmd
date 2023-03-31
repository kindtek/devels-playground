@REM TODO: build images with custom username/groupname then push
@REM docker build --build-arg username=!username! --build-arg groupname=!groupname! -f ../docker/alpine/docker-compose.yaml -t dvlp_
@REM docker build --build-arg username=!username! --build-arg groupname=!groupname! -f ../docker/ubuntu/docker-compose.yaml -t dvlp_msdot
@REM docker image push kindtek/devels-playground

@REM ubuntu
docker compose -f ../docker/ubuntu/docker-compose.yaml up
@REM alpine
@REM docker compose -f ../docker/alpine/docker-compose.yaml up
