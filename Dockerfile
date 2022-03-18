FROM debian

ENV LOCAL_DIR=/local/datakit/ \
    SHARED_DIR=/shared/datakit/


#RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
#    && apk add bash

RUN sed -i "s@http://[^\.]*\.debian\.org@http://mirrors.aliyun.com@g" /etc/apt/sources.list \
    && apt-get update && apt-get install wget -y

COPY download-assets.sh /tmp/download-assets.sh

RUN bash /tmp/download-assets.sh

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
