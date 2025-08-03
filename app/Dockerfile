# Dockerfile (inside app/)
FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY app.py .           # already exists
COPY tests/ ./tests/    # ✅ add this line

EXPOSE 5000
CMD ["python", "app.py"]
