#!/bin/bash

read -e -p "How Many Namespaces you would like to create ? " namespaceCount

echo "A ClusterRoleBinding rule is being created with VIEW clusterrole for $selectedNamspace" 
