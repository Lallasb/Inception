# Developer Documentation

This document explains how to set up, build, and maintain the Inception project as a developer.

## 1. Setting up the environment from scratch

### Prerequisites
- Docker Engine and the Docker Compose plugin installed:
  ```bash
  docker --version
  docker compose version
  ```
- Your user added to the `docker` group, so Docker commands don't require `sudo`:
  ```bash
  sudo usermod -aG docker $USER
  ```
  (log out and back in for this to take effect)

### Repository layout
```
.
├── Makefile
└── srcs/
    ├── docker-compose.yml
    ├── .env
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        ├── nginx/
        │   ├── Dockerfile
        │   ├── conf/
        └── wordpress/
            ├── Dockerfile
            ├── conf/
            └── tools/
```

### Configuration files to create

**`srcs/.env`** — non-sensitive configuration:
```dotenv
DOMAIN_NAME=login.42.fr
SITE_TITLE=Inception

MARIADB_DATABASE=wordpress_db
MARIADB_USER=wordpress
MARIADB_HOST=mariadb

WP_ADMIN_USER=<admin username, must NOT contain admin/administrator>
WP_ADMIN_EMAIL=<admin email>

WP_USER=<secondary user login>
WP_USER_EMAIL=<secondary user email>
```

These are never committed to git — confirm they're listed in `.gitignore` alongside `.env`.

## 2. Building and launching the project

```bash
make          # equivalent to: docker compose  up --build
```

The Makefile drives everything through `docker-compose.yml` — it does not call `docker build`/`docker run` directly. Each service (`mariadb`, `nginx`, `wordpress`) has its own Dockerfile under `srcs/requirements/<service>/`, referenced by the `build:` key in `docker-compose.yml`.

Key build details:
- Base images: Debian or Alpine only — no `latest` tag, no pulling pre-built `nginx`/`wordpress`/`mariadb` images from Docker Hub.
- Each container's main process (`mysqld_safe`, `php-fpm`, `nginx -g daemon off`) runs as PID 1 — no `tail -f`, `sleep infinity`, or similar keep-alive hacks.
- Containers use `restart: always` to recover automatically from crashes.

## 3. Managing containers and volumes

| Command        | Effect                                                        |
|----------------|-----------------------------------------------------------------|
| `make`         | Build (if needed) and start all containers                     |
| `make down`    | Stop all containers, **preserve** volumes/data                 |
| `make re`      | `down` then `all` — data must survive this cycle                |
| `make clean`   | `down -v` — removes Docker's volume references                 |
| `make fclean`  | `clean` + wipes the actual host data directories (full reset)  |

Useful inspection commands during development:
```bash
docker ps -a                  # container status
docker logs <service> 
docker exec -it <service> bash
docker volume ls
docker network ls
```

## 4. Where project data is stored and how it persists

Two Docker **named volumes** are defined in `docker-compose.yml`:
```yaml
volumes:
  mariadb:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/login/data/mariadb
  wordpress:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /home/login/data/wordpress
```

Both are true Docker named volumes (they appear under `docker volume ls`), but each is backed by a bind mount to a specific host path, so the underlying files are directly visible and inspectable at:
```
/home/login/data/mariadb/      # MariaDB's data directory
/home/login/data/wordpress/    # WordPress site files (themes, plugins, uploads, core)
```

**Persistence behavior:**
- `docker compose down` (no `-v`) → containers stop, volumes and host data remain untouched.
- `docker compose down -v` → Docker's volume *references* are removed, but since the volumes are bind-backed, the actual files at `/home/login/data/` are **not** deleted (this is expected — Docker doesn't own bind-mounted data).
- To genuinely wipe the data, the host directories must be cleared manually:
  ```bash
  sudo rm -rf /home/login/data/mariadb/*
  sudo rm -rf /home/login/data/wordpress/*
  ```
  This is exactly what `make fclean` automates.

**On first boot**, each container's entrypoint script checks whether its data directory is already initialized before running setup steps (e.g. `mariadb.sh` checks for an existing `MARIADB_DATABASE` folder before creating tables; `wordpress.sh` should check `wp core is-installed` before running `wp core install`), so that restarting an already-provisioned stack does not attempt to re-run first-time setup.