@REM TODO: build images with custom username/groupname then push
@REM docker build --build-arg username=!username! --build-arg groupname=!groupname! -f ../dockerfile.alpine.yaml -t d2w_phat
@REM docker build --build-arg username=!username! --build-arg groupname=!groupname! -f ../dockerfile.ubuntu.yaml -t d2w_phat
@REM docker image push kindtek/d2w

@REM ubuntu
docker compose -f /docker-compose.ubuntu.yaml up -d
@REM alpine
docker compose -f /docker-compose.alpine.yaml up -d

@REM ubuntu
docker compose -f /docker-compose.ubuntu.yaml push
@REM alpine
docker compose -f /docker-compose.alpine.yaml push

@REM both
@REM docker compose -f /docker-compose.ubuntu.yaml -f ../docker-compose.alpine.yaml up -d

