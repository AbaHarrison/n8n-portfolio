# Use the same n8n image from your compose file
FROM docker.n8n.io/n8nio/n8n:latest

# Set the working directory
WORKDIR /home/node

# Copy your telegram weather bot workflow files
COPY telegram-weather-bot/ /home/node/.n8n/

# Set environment variables to match your compose file
ENV N8N_HOST=0.0.0.0
ENV N8N_PORT=5678
ENV N8N_PROTOCOL=https
ENV N8N_BASIC_AUTH_ACTIVE=true
# Basic auth credentials will be set via Render environment variables
# N8N_BASIC_AUTH_USER and N8N_BASIC_AUTH_PASSWORD
ENV N8N_USER_MANAGEMENT_DISABLED=true
ENV N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true
ENV TZ=Africa/Accra

# Create necessary directories and set permissions
USER root
RUN mkdir -p /home/node/.n8n && \
    chown -R node:node /home/node/.n8n
USER node

# Expose the port that n8n runs on
EXPOSE 5678

# Health check to ensure n8n is running
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5678/healthz || exit 1

# Use the default entrypoint from the base image
# The n8n image already knows how to start itself