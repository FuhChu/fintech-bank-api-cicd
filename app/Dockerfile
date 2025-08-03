FROM python:3.10-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .  # copies app.py and test_app.py
CMD ["python", "app.py"]
