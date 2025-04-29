FROM python:3.13-slim
WORKDIR /app

# Install system dependencies
# x11-apps is required for X11 forwarding
RUN apt-get update && apt-get install -y \
  x11-apps \
  google-chrome-stable \
  chromedriver

# Copy project files
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

# Set up X11
ENV DISPLAY=:0

# Run the script
CMD ["python", "runAiBot.py"]