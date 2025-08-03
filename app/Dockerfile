# Use a slim Python 3.10 base image for a smaller container
FROM python:3.10-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements file and install dependencies
# Gunicorn must be in this file.
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your application code into the container
COPY . .

# Expose the port Gunicorn will listen on
EXPOSE 5000

# This is the key change. We use Gunicorn to run the application.
# The format is "gunicorn [options] app_module:app_instance"
# "app:app" refers to the 'app' variable in your 'app.py' file.
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]