FROM ballerina/jvm-runtime:1.0

RUN apk add --update --no-cache curl jq

RUN mkdir -p /home/ballerina

RUN cp resources/sameerag-tcp_listener_service-0.1.0.jar /home/ballerina/sameerag-tcp_listener_service-0.1.0.jar

RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid 10014 \
    "choreo"

WORKDIR /home/ballerina

EXPOSE  9090
USER 10014

CMD java -jar 'sameerag-tcp_listener_service-0.1.0.jar'