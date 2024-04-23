#!/bin/bash

NAMESPACE="sre"
DEPLOYMENT="swype-app"
MAX_RESTARTS=4

# Start an infinite monitoring loop
while true; do
  # Fetch the number of restarts for the first pod in the deployment
  RESTARTS=$(kubectl get pods -n ${NAMESPACE} -l app=${DEPLOYMENT} -o jsonpath="{.items[0].status.containerStatuses[0].restartCount}")

  # Output the current number of restarts
  echo "Current number of restarts: ${RESTARTS}"

  # Check if the restart count exceeds the maximum allowed restarts
  if (( RESTARTS > MAX_RESTARTS )); then
    echo "Maximum number of restarts exceeded. Scaling down the deployment..."
    # Scale down the deployment to zero replicas
    kubectl scale deployment/${DEPLOYMENT} --replicas=0 -n ${NAMESPACE}
    # Break the loop after scaling down the deployment
    break
  fi

  # Sleep for 60 seconds before checking again
  sleep 60
done