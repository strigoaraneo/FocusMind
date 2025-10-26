# --------------------------------------------------------------
# Stage 0 – build the React app
# --------------------------------------------------------------
FROM node:20-alpine AS builder

# Set a deterministic working directory
WORKDIR /app

# 1️⃣  Copy only the files needed for npm install first.
#     This gives us a cache layer that only invalidates when the
#     dependency list changes.
COPY package*.json ./
# If you have a lock‑file (package‑lock.json or yarn.lock) it will be
# copied as well because of the glob above.
RUN npm ci --silent

# 2️⃣  Copy the rest of the source code and build it.
COPY . .
RUN npm run build

# --------------------------------------------------------------
# Stage 1 – runtime (tiny static‑file server)
# --------------------------------------------------------------
FROM node:20-alpine AS runtime

# System tools required for the tiny server (none really, but keep it lean)
RUN apk add --no-cache \
        # required by the `serve` binary (it uses `fs` only, no extra deps)
        && npm install -g serve@14

# Create a non‑root user (safer on Render)
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

WORKDIR /srv/app

# 3️⃣  Copy the compiled build folder from the builder stage.
COPY --from=builder /app/build ./

# --------------------------------------------------------------
# Runtime configuration
# --------------------------------------------------------------
# Render injects the environment variable $PORT (usually 10000). 
# The `serve` binary defaults to 3000, so we override it with $PORT.
ENV PORT=${PORT:-3000}

# Expose the port Render will probe.
EXPOSE 3000

# ENTRYPOINT runs the server; the `exec` form ensures the process becomes PID 1.
ENTRYPOINT ["serve", "-s", ".", "-l", "tcp://0.0.0.0:${PORT}"]