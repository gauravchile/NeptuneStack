# Build lightweight Node image for API
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --only=production
COPY src ./src
ENV NODE_ENV=production PORT=8080
USER node
EXPOSE 8080
CMD ["node", "src/index.js"]
