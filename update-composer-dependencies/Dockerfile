FROM composer
ADD entrypoint.sh /entrypoint.sh
RUN apk add --no-cache jq
ENTRYPOINT [ "/entrypoint.sh" ]