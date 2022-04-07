FROM node:16.14.2 as base

COPY package.json ./package.json
COPY package-lock.json ./package-lock.json

# This will copy everything from the source path 
# --more of a convenience when testing locally.
COPY src ./src
COPY tsconfig.json ./tsconfig.json
RUN ls
RUN npm ci 
RUN npm i -g typescript
RUN tsc


FROM gcr.io/distroless/nodejs:16 AS final

# Create app directory
WORKDIR /app

# Copy node modules and build directory
COPY --from=base ./node_modules ./node_modules
COPY --from=base ./dist ./dist


#Copy config
COPY ./config ./config

# Copy static files
COPY ./static ./static

# Expose port 3000
EXPOSE 3000
CMD ["./dist/index.js"]