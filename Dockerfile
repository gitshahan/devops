# Base image from Azure Functions Python
FROM mcr.microsoft.com/azure-functions/python:4-python3.11

# Set the working directory to /home/site/wwwroot
WORKDIR /home/site/wwwroot


# Copy the requirements file and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the function app code
COPY . .

# Expose the default port for Azure Functions
EXPOSE 80

# Command to run the Azure Functions host
CMD [ "/azure-functions-host", "start" ]