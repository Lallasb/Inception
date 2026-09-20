*This project has been created as part of the 42 curriculum by lalla.*

# Inception

## Description

Inception is a system administration project whose goal is to deploy a small web infrastructure entirely with Docker, on a personal virtual machine. Every service — the webserver, the CMS, and the database — runs in its own dedicated container, built from a hand-written Dockerfile (no pre-made Docker Hub images are used, other than the base OS image).

The stack is composed of three containers:

- **NGINX** — the single entrypoint to the whole infrastructure, reachable only on port 443, using TLSv1.2 or TLSv1.3.
- **WordPress + php-fpm** — the CMS itself, running without any bundled webserver (no Apache), communicating with NGINX over php-fpm's FastCGI protocol.
- **MariaDB** — the database backing WordPress, with no webserver installed inside it.

All three containers are connected through a dedicated Docker network, and persistent data (the WordPress database and the WordPress site files) is stored in two Docker named volumes, backed by bind mounts pointing at `/home/login/data/` on the host.

### Design choices and comparisons

**Virtual Machines vs Docker**
A VM virtualizes an entire operating system — its own kernel, its own full filesystem, booted independently — which makes it heavier to run and slower to start, but gives very strong isolation. Docker containers instead share the host machine's kernel and only isolate the application layer (processes, filesystem view, network), making them far lighter and faster to start, at the cost of slightly weaker isolation than a full VM. This project deliberately uses one VM as the outer boundary (as required), and Docker containers inside it for the actual services — combining a strong isolation boundary at the VM level with fast, lightweight service separation at the container level.

**Secrets vs Environment Variables**
Environment variables (via `.env`) are simple and readable, but they're visible to any process that can inspect the container (e.g. `docker inspect`, `/proc/<pid>/environ`), and can leak into logs or crash dumps. Docker secrets are mounted as files inside the container's filesystem (typically under `/run/secrets/`) and are never exposed through the container's environment or `docker inspect` output, making them the more secure option for actual passwords. This project uses `.env` for non-sensitive configuration (domain name, usernames, site title) and Docker secrets for anything sensitive (database passwords, root password).

**Docker Network vs Host Network**
`network: host` makes a container share the host machine's network stack directly — no isolation, and every port the container opens is immediately exposed on the host. A custom Docker network (bridge driver) instead gives containers their own private network, where they can reach each other by service name, and only ports explicitly published are exposed to the host. This project uses a custom Docker network (`inception`) as required, keeping all inter-container traffic (MariaDB, WordPress, NGINX) isolated from the host's own network and from other Docker projects.

**Docker Volumes vs Bind Mounts**
A bind mount links a container path directly to an arbitrary host path, with Docker having no ownership over that data's lifecycle. A Docker named volume is managed by Docker itself (created, tracked, and normally stored under Docker's internal storage), while still being referenced by a simple name in the compose file. This project uses named volumes (as required) configured with the `local` driver's `device`/`o: bind` options, so that the volume is still a genuine Docker-managed named volume, while its underlying data physically lives at the required `/home/login/data/` path on the host.

## Instructions

### Prerequisites
- A Debian or Alpine-based virtual machine
- Docker and Docker Compose installed
- Your user added to the `docker` group (to run Docker without `sudo`)

### Setup
1. Clone the repository.
2. Create the required `.env` file at `srcs/.env` (see `DEV_DOC.md` for the full list of variables).
3. Create the required secret files under `secrets/` (see `DEV_DOC.md`).
4. Add your domain to `/etc/hosts`:
   ```
   127.0.0.1   login.42.fr
   ```

### Running
```bash
make          # builds and starts all containers
make down     # stops containers, keeps data
make re       # restarts everything, data persists
make clean    # removes containers/volumes references
make fclean   # full reset, wipes host data too
```

Once running, the site is available at:
```
https://login.42.fr
```

See `USER_DOC.md` for how to use the site day-to-day, and `DEV_DOC.md` for full setup/build details.

## Resources

- [Docker Compose documentation](https://docs.docker.com/compose/)
- [Docker Compose file reference — volumes](https://docs.docker.com/reference/compose-file/volumes/)
- [Docker secrets documentation](https://docs.docker.com/engine/swarm/secrets/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [WP-CLI documentation](https://wp-cli.org/)
- [MariaDB documentation](https://mariadb.com/kb/en/documentation/)
- [PHP-FPM documentation](https://www.php.net/manual/en/install.fpm.php)

### AI usage

AI was used as a learning aid throughout this project — clarifying Docker/Linux concepts I wasn't familiar with (volumes vs bind mounts, networking, permissions, configuration), helping me find relevant documentation and resources, and helping me understand errors I ran into while debugging the stack. All configuration, code, and fixes were written and tested by me.