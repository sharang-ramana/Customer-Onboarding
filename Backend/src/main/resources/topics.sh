#!/bin/bash

# Replace with your actual Confluent Cloud cluster URL and API key
TOPIC_CREATION_URL="https://<host>:<port>/kafka/v3/clusters/<cluster-id>/topics"
API_KEY="Provide Base64(username:password) here"

# Define an array of topic names
TOPICS=("signup" "events")

# Iterate over the array and create topics
for topic in "${TOPICS[@]}"; do
    curl -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Basic $API_KEY" \
        "$TOPIC_CREATION_URL" \
        -d "{\"topic_name\":\"$topic\"}"

    echo "Created topic: $topic"
done

