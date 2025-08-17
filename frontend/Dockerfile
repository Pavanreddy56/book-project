# Use Nginx for serving static frontend files
FROM nginx:alpine

# Remove default nginx static files
RUN rm -rf /usr/share/nginx/html/*

# Copy built frontend files (copied from Jenkins pipeline)
COPY frontend-dist/ /usr/share/nginx/html/

# Expose Nginx default port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
