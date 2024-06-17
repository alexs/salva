Welcome to SALVA
================

SALVA is web application to handle scientific curricula for the creation of Science 
and Technology databases at [National Autonomous University of Mexico](http://www.unam.mx/).

Getting Started
===============

1. Install rvm in your linux distribution 
2. Install ruby 2.1.2-p95
3. Install the gems with the ruby bundler
4. Install PostgresSQL 9.x, MemCached, Redis and ImageMagick
5. Create your database, run the seeds to populate your database
6. Copy the *yml.example files to *yml files in the config directory and
   adapt them to your configuration (The required are databases.yml, site.yml and mail.yml)
7. Install passenger with apache or ngnix
8. Start to web server


Running with docker
===============

Initial setup
---------------

Please ensure you are using Docker Compose V2.

Remember to rewrite the .example files with your data.

```
cp .env.example .env
cp config/database.yml.example config/database.yml
cp config/site.yml.example config/site.yml
cp config/mail.yml.example config/mail.yml
docker compose build
docker compose run --rm salva rake db:create
docker compose run --rm salva rake db:migrate
docker compose run --rm salva rake db:seed
```

When seed data, the admin user is created.

Running the Rails app
---------------

```
docker compose up
```

Running the Rails console
---------------
When the app is already running with `docker-compose` up, attach to the container:
```
docker compose exec salva script/rails c
```

When no container running yet, start up a new one:
```
docker compose run --rm salva script/rails c
```

Special routes
===============

For admin:
```
/admin
```
For library or similar:
```
/ibrarian/admin
```
For annuals and plans reports review:
```
/department
```
For researchers to approve reports from academic technicians:
```
/academic
```

Authors
=======

- Alejandro Juárez Robles <alex@fisica.unam.mx>
- Alejandro Aguilar Sierra <algsierra@gmail.com>
- Francisco López Ramírez <arxuna@gmail.com>
- Ramon Martínez Olvera <ramonmtzol@gmail.com>
- Gunnar Wolf <gwolf@gwolf.org>
- Eduardo Espinosa Avila <laloeag@gmail.com>

Contributors
============

- Fernando Magariños Mancha <mancha@gmail.com>
- Miguel E <mvazquez83@gmail.com>
- Alejandro Silva <alexs1010@gmail.com>
- Fernando Magariños Mancha <mancha@gmail.com>

License
=======
SALVA is released under the [GPL-2 License](http://opensource.org/licenses/GPL-2.0).

HELP
====
You can ask for help at the [SALVA-UNAM](https://groups.google.com/forum/#!forum/salva-unam) group.
