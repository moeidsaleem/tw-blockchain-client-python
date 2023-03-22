FROM python:3.9-slim



ARG AWS_REGION
ENV AWS_REGION $AWS_REGION

WORKDIR /app

COPY ./app/requirements.txt /app
RUN pip install -r requirements.txt

COPY ./app /app

CMD ["python", "main.py"]
