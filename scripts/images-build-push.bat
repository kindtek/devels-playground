@REM TODO: build images with custom username/groupname then push
@REM docker build --build-arg username=!username! --build-arg groupname=!groupname! -f ../dockerfile.alpine -t d2w_phat
@REM docker build --build-arg username=!username! --build-arg groupname=!groupname! -f ../dockerfile.ubuntu -t d2w_phat
@REM docker image push kindtek/d2w

@REM alpine
docker compose -f ../docker-compose.alpine build
@REM ubuntu
docker compose -f ../docker-compose.ubuntu build

@REM docker compose build
docker compose push
docker compose up -d