# Use the official Nginx image as the base image
FROM nginx

# Install Node.js and npm
RUN apt-get update && \
    apt-get install -y nodejs npm

# Set the working directory in the container
WORKDIR /app

# Copy package.json and src folder to the working directory
COPY package.json .
# Install dependencies
RUN npm install

COPY *.config.js ./
COPY src ./src
COPY index.html .
COPY public/vite.svg .
# Run npm build (assuming your build script is defined in package.json)
RUN npm run build

# Copy the build results to the Nginx share directory (default is /usr/share/nginx/html)
RUN cp -r dist/* /usr/share/nginx/html
RUN cp vite.svg /usr/share/nginx/html/vite.svg

# Expose the default Nginx port
EXPOSE 80

# Command to start Nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]
