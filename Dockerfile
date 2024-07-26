FROM ubuntu

WORKDIR /app

COPY . ./

RUN apt update -y && \
    apt install -y mysql-server python3 python3-pip python3-venv python3-dev default-libmysqlclient-dev build-essential pkg-config libmysqlclient-dev

RUN service mysql start && \
    cat 100-hbnb.sql | mysql -u root

RUN python3 -m venv ./myenv
RUN /bin/bash -c "source ./myenv/bin/activate && pip install -r requirements.txt"
ENV HBNB_MYSQL_USER=hbnb_dev \
    HBNB_MYSQL_PWD=hbnb_dev_pwd \
    HBNB_MYSQL_HOST=localhost \
    HBNB_MYSQL_DB=hbnb_dev_db \
    HBNB_TYPE_STORAGE=db

EXPOSE 5000 5001

CMD ["/bin/bash", "-c", "source ./myenv/bin/activate && service mysql start && gunicorn --daemon -b 0.0.0.0:5001 api.v1.app:app && gunicorn -b 0.0.0.0:5000 web_dynamic.100-hbnb:app"]
