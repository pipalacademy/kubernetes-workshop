FROM python:3.6
LABEL MAINTAINER Nabarun Pal <pal.nabarun95@gmail.com>

WORKDIR /app
ADD requirements.txt file.txt /app/

RUN pip install -r requirements.txt

ADD app.py .

EXPOSE 8080

CMD ["python", "app.py"]
