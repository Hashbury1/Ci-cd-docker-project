# syntax=docker/dockerfile:1
FROM python:3.9-slim

WORKDIR /app

# We mount the secret only for the specific command that needs it
RUN --mount=type=secret,id=DB_PASSWORD \
    export DB_PASSWORD=$(cat /run/secrets/DB_PASSWORD) && \
    echo "Connecting to DB to run migrations..." && \
    # In a real app, you'd run: python manage.py migrate
    echo "Migrations complete for password starting with: ${DB_PASSWORD:0:2}***"

COPY . .

# IMPORTANT: Do not use the secret in the CMD or ENTRYPOINT 
# unless you are passing it as a runtime env var via your orchestrator (ECS/K8s)
CMD ["python", "app.py"]