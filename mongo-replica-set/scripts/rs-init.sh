#!/bin/bash

DELAY=25
DB_NAME=db

# Initialize mongo instances as replica set
# mongo1 is the primary node
mongosh <<EOF
let config = {
  "_id": "rs0",
  "members": [
    {
      "_id": 0,
      "host": "mongo1:27017",
      "priority": 1
    },
    {
      "_id": 1,
      "host": "mongo2:27017",
      "priority": 0.5
    },
    {
      "_id": 2,
      "host": "mongo3:27017",
      "priority": 0.5
    },
  ]
};
rs.initiate(config);
rs.status();
EOF

echo "****** Waiting for ${DELAY} seconds for replicaset configuration to be applied ******"

sleep $DELAY

echo "****** Setup user for database ${DB_NAME} ******"

mongosh <<EOF
db.createUser({
  user: "admin",
  pwd: "password",
  roles: [
    {
      role: "root",
      db: "admin",
    }
  ]
});

let dbSibling = db.getSiblingDB("${DB_NAME}");
dbSibling.createUser({
  user: "user",
  pwd: "pass",
  roles: [
    {
      role: "readWrite",
      db: "${DB_NAME}",
    }
  ]
});
EOF

echo "****** User was created in database ${DB_NAME} ******"
echo "****** Username: user | Password: pass ******"
