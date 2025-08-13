FROM python:3.9-slim
WORKDIR /app
COPY . /app
RUN pip install flask newrelic  # Add New Relic agent for APM
EXPOSE 5000
ENV NEW_RELIC_LICENSE_KEY=your-new-relic-license-key  # Replace with your key
ENV NEW_RELIC_APP_NAME=FlaskPoC
CMD ["newrelic-admin", "run-program", "python", "app.py"]
