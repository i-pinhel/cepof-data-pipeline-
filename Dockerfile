FROM python:3.9-slim

WORKDIR /app

# Install dependencies (requires a requirements.txt file with 'pandas')
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . .

# Run the pipeline
CMD ["python", "pipeline.py"]
