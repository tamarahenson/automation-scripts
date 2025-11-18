#!/bin/bash

drained_nodes=()
uncordoned_nodes=()

echo "Kubernetes Node Maintenance Script"
echo "---------------------------------"
echo "Select an action:"
echo "1) Cordon & Drain ALL worker nodes"
echo "2) Uncordon ALL drained worker nodes"
read -p "Enter choice (1 or 2): " choice

if [ "$choice" = "1" ]; then
  echo "⚠️ Draining ALL worker nodes (this may disrupt workloads)..."
  for node in $(kubectl get nodes --no-headers | awk '!/control-plane|master/ {print $1}'); do
    echo "Cordon and drain $node..."
    kubectl cordon "$node" && \
    kubectl drain "$node" --ignore-daemonsets --delete-emptydir-data --force
    if [ $? -eq 0 ]; then
      drained_nodes+=("$node")
    else
      echo "❌ Failed to drain $node"
    fi
  done

  echo
  echo "✅ Drain Summary:"
  echo "Drained nodes: ${drained_nodes[*]:-None}"

elif [ "$choice" = "2" ]; then
  echo "Uncordoning ALL drained worker nodes..."
  for node in $(kubectl get nodes --no-headers | awk '!/control-plane|master/ && /SchedulingDisabled/ {print $1}'); do
    echo "Uncordon $node..."
    kubectl uncordon "$node"
    if [ $? -eq 0 ]; then
      uncordoned_nodes+=("$node")
    else
      echo "❌ Failed to uncordon $node"
    fi
  done

  echo
  echo "✅ Uncordon Summary:"
  echo "Uncordoned nodes: ${uncordoned_nodes[*]:-None}"

else
  echo "Invalid choice. Exiting."
fi

