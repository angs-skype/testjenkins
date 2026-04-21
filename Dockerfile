FROM nginx:latest

# Remove default nginx html
RUN rm -rf /usr/share/nginx/html/*

# Create custom index.html using echo
RUN echo "<h1>Hi parth How are you!!</h1>" > /usr/share/nginx/html/index.html

# Expose port
EXPOSE 80