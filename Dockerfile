# Use Node.js 22 LTS as the base image
FROM node:22-slim AS builder

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install all dependencies (including devDependencies for build)
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the frontend
RUN npm run build

# Use a smaller base image for production
FROM node:22-slim

WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/server.ts ./
COPY --from=builder /app/node_modules ./node_modules

# Set environment variable to production
ENV NODE_ENV=production

# Expose the port the app runs on
EXPOSE 3030

# Start the application using tsx (now in dependencies)
CMD ["npm", "run", "start"]
