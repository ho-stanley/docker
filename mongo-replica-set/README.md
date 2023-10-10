# MongoDB replica set for Docker

## Description

Docker configuration to setup MongoDB with 3 replica sets. Useful if you use libraries or tools that requires it, e.g. [Prisma](https://www.prisma.io/).  
You can read more about why Prisma have this requirement in the following link [https://www.prisma.io/docs/concepts/database-connectors/mongodb#replica-set-configuration](https://www.prisma.io/docs/concepts/database-connectors/mongodb#replica-set-configuration)

## How to run

Start MongoDB docker with the following command in the command line:

`docker compose up -d`

After the container is up and running you will need to connect to the MongoDB instance:

`docker exec -it mongo1 bash`

Finally you will need to execute a script to configure the replica set:

`./scripts/rs-init.sh`

Everything is setup and you can connect to the database now. The default database name is `db`.

## Good to know

### Default user accounts and database

By default an admin account will be created with the following credentials:

```
username: admin
password: password
```

A user for the newly created database will also be created:

```
username: user
password: pass
```

### Change default configuration

If you want to change default users or the database name you can edit the values in the script `/scripts/rs-init.sh` before running the container.

### Connecting to the database

Only one of the database replica have its ports exposed to the user. Applications will only be able to connect to this single database replica and will fail trying to connect to others.

You will need to set parameter `directConnection` to `true` in the connection string like this:

`mongodb://user:pass@localhost:27017/db?directConnection=true`

Without `directConnection` parameter or if it's set to `false` the application may try to connect to other database replicas.
