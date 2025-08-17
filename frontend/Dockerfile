# Use official Python image
FROM python:3.9-slim

# Set work directory
WORKDIR /app

# Prevent Python from writing pyc files + enable unbuffered logging
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY . .

# Expose Flask port
EXPOSE 5000

# Default command (use gunicorn for production)
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
