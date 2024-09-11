# Stage 1: Build the application
FROM node:20-alpine3.17 AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package.json package-lock.json ./

# Install only production dependencies using npm ci for consistency and speed
RUN npm ci

# Copy all files to the container
COPY . .

# Build the application
RUN npm run build

# Stage 2: Create the production image
FROM node:20-alpine3.17

# Set the working directory
WORKDIR /app

# Copy the built files from the previous stage
COPY --from=builder /app .

# Expose the necessary port
EXPOSE 5000

# Run the application
CMD ["npm", "start"]