FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt
RUN apt-get update && apt-get install -y default-mysql-client && rm -rf /var/lib/apt/lists/*

COPY init.sql /docker-entrypoint-initdb.d/

COPY . /app

EXPOSE 5000
CMD ["python", "app.py"]