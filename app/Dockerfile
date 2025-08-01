FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY app.py .

EXPOSE 5000

CMD ["python", "app.py"]
# Dockerfile for the Flask application
# This Dockerfile sets up a Python environment, installs dependencies, and runs the Flask app.