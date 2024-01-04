FROM python:3.7-alpine as builder
RUN apk --update add bash nano g++
COPY . /vampi
WORKDIR /vampi
RUN pip install -r requirements.txt

# Build a fresh container, copying across files & compiled parts
FROM python:3.7-alpine
COPY . /vampi
WORKDIR /vampi
COPY --from=builder /usr/local/lib /usr/local/lib
COPY --from=builder /usr/local/bin /usr/local/bin
ENV vulnerable=1
ENV tokentimetolive=60

# added to include seeker agent
ENV SEEKER_SERVER_URL=https://xxx.xxx.xxx.com:443
ENV SEEKER_PROJECT_KEY=HVP_VAmPI
ENV SEEKER_AGENT_NAME=HVP_VAmPI
ENV SEEKER_AGENT_APP_OPENAPI_SPEC_FILE=/openapi.json
ENV SEEKER_AGENT_APP_OPENAPI_URL=http://127.0.0.1:5000
RUN pip install --trusted-host xxx.xxx.xxx.com:443 --extra-index-url "https://xxx.xxx.xxx.com/pypi-server/simple" seeker-agent

ENTRYPOINT ["python"]
CMD ["app.py"]
