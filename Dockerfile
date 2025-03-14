FROM node:18-alpine AS build

WORKDIR /usr/src/app

# First, copy the git submodule information files
COPY .gitmodules ./
COPY .git ./.git

# Initialize and update submodule
RUN apk add --no-cache git && \
    git submodule init && \
    git submodule update

# Now, copy main project package files and install dependencies
COPY package*.json ./
RUN npm install

# Install dependencies in the submodule
WORKDIR /usr/src/app/ITS122L
RUN npm install

# Build the Angular app
RUN npm run build -- --configuration production

# Second stage
FROM node:18-alpine

WORKDIR /usr/src/app

# Copy main project package files and install dependencies
COPY package*.json ./
RUN npm install --only=production

# Copy index.js
COPY index.js ./

# Copy the built application
COPY --from=build /usr/src/app/ITS122L/dist/brmo ./ITS122L/dist/brmo

EXPOSE 8080

CMD ["node", "index.js"]