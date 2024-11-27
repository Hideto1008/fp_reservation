#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f "$PWD/tmp/pids/server.pid"

# Use PORT environment variable or default to 3000
PORT=${PORT:-3000}

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec bundle exec rails server -b 0.0.0.0 -p $PORT
