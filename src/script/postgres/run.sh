#!/bin/bash

su - postgres -c "export PGDATA=/var/lib/postgresql/data && postgres >> ~/log.log"
