#!/bin/bash

apt update -y
apt install -y python3-pip mysql-client

pip3 install flask pymysql

cat > /home/ubuntu/app.py <<EOF
from flask import Flask
import pymysql

app = Flask(__name__)

db_host = "${db_endpoint}"
db_user = "${db_username}"
db_password = "${db_password}"
db_name = "${db_name}"

@app.route("/")
def home():
    return "Flask App Connected to RDS MySQL"

@app.route("/health")
def health():
    try:
        conn = pymysql.connect(
            host=db_host,
            user=db_user,
            password=db_password,
            database=db_name
        )
        conn.close()
        return "Database connection successful"
    except Exception as e:
        return str(e)

@app.route("/db-info")
def dbinfo():
    return f"Connected to database: {db_name}"

app.run(host="0.0.0.0", port=80)
EOF

python3 /home/ubuntu/app.py &