FROM python:3.7.16-bullseye

RUN pip install singer-target-postgres
RUN pip install target-json

RUN apt-get update
RUN apt-get install jq -y
RUN apt-get install postgresql -y

COPY ./tap_calendly/ ./tap_calendly/
COPY ./setup.py ./
WORKDIR ./
RUN pip install -e .

WORKDIR /
COPY ./config.json ./
COPY ./target_postgres_config.json ./

CMD python ./tap_calendly/__main__.py --config config.json | target-postgres -c ./target_postgres_config.json
