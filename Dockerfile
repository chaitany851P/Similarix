# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    tesseract-ocr \
    libtesseract-dev \
    poppler-utils \
    libgl1-mesa-glx \
    libglib2.0-0 \
    gcc \
    python3-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Download NLTK data (Crucial for M2 logic)
RUN python -m nltk.downloader punkt punkt_tab stopwords

# Copy the rest of the application code
COPY . .

# Create a folder for uploads and set permissions
RUN mkdir -p static/uploads && chmod 777 static/uploads

# Expose the port Flask runs on
# Use 7860 for Hugging Face, or 5000 for standard deployment
EXPOSE 5000

# Command to run the application
CMD ["python", "app.py"]
``
