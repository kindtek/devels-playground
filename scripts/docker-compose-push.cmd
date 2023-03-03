@REM TODO: build images with custom username/groupname then push
@REM docker build --build-arg username=!username! --build-arg groupname=!groupname! -f ../dockerfile.alpine.yaml -t devp_phat
@REM docker build --build-arg username=!username! --build-arg groupname=!groupname! -f ../dockerfile.ubuntu.yaml -t devp_phat
@REM docker image push kindtek/devp


@REM ubuntu
docker compose -f ../docker-compose.ubuntu.yaml push
@REM alpine
@REM docker compose -f ../docker-compose.alpine.yaml push

@REM both
@REM docker compose -f ../docker-compose.ubuntu.yaml -f ../docker-compose.alpine.yaml up -d

