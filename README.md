# kurento-docker-build

## build image

docker build --progress=plain -t akkk/kurento-custom:remb0224 .

## docker run

docker run -d \
    -v config/env.conf:/config/env.conf \
    -v config/modules:/etc/kurento/modules/kurento \
    -v config/kurento.conf.json:/etc/kurento/kurento.conf.json \
    -v logs:/logs \
    -p 8888:8888/tcp \
    -p 5000-5050:5000-5050/udp \
    -e KMS_MIN_PORT=5000 \
    -e KMS_MAX_PORT=5050 \
    akkk/kurento-custom:remb0224