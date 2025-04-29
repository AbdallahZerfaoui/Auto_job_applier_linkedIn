FROM python:3.13-alpine
WORKDIR /app

# Install system dependencies
# x11-apps is required for X11 forwarding
# Install system dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    x11-apps \
    wget \
    gnupg \
    curl \
    unzip && \
    rm -rf /var/lib/apt/lists/*

# Add Google Chrome repository
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/googlechrome-linux-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/googlechrome-linux-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list

# Install Chrome and chromedriver
RUN apt-get update && apt-get install -y --no-install-recommends \
    google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Download matching chromedriver
RUN CHROME_VERSION=$(google-chrome --version | awk '{print $3}') && \
    CHROMEDRIVER_VERSION=$(curl -sS "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION") && \
    wget -O /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip" && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver && \
    rm /tmp/chromedriver.zip

# Copy project files
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .

# Set up X11
ENV DISPLAY=:0

# Run the script
CMD ["python", "runAiBot.py"]