# User Documentation

This document explains how to use the Inception stack as an end user or administrator — no development knowledge required.

## 1. What services does this stack provide?

The stack is made up of three containers working together to serve a WordPress website:

| Service   | Role                                                      |
|-----------|-------------------------------------------------------------|
| NGINX     | The only entrypoint to the site. Handles HTTPS (port 443).  |
| WordPress | The CMS itself, running with php-fpm.                       |
| MariaDB   | The database storing all WordPress content and users.       |

All three run together, and all your website content (posts, pages, media, users) is stored persistently — restarting the containers does not erase your data.

## 2. Starting and stopping the project

From the project's root directory:

```bash
make          # builds (if needed) and starts all services
```

To stop everything (your data is preserved):
```bash
make down
```

To restart everything (your data is preserved):
```bash
make re
```

To completely reset the project, including all stored data (posts, users, database — irreversible):
```bash
make fclean
```

## 3. Accessing the website and the admin panel

**Public website:**
```
https://lasoubai.42.fr
```

**Admin panel (WordPress dashboard):**
```
https://lasoubai.42.fr/wp-admin
```
or directly:
```
https://lasoubai.42.fr/wp-login.php
```

Your browser will show a security warning the first time, because the site uses a self-signed TLS certificate (normal for a local/school project, not a real-world public certificate). Choose "Advanced" → "Proceed" to continue.

> **Note:** the domain `lasoubai.42.fr` must be pointed at `127.0.0.1` in your machine's `/etc/hosts` file for this to resolve. If the page doesn't load, check that this entry exists:
> ```
> 127.0.0.1   lasoubai.42.fr
> ```

## 4. Locating and managing credentials

Credentials are never hardcoded into the project's configuration files. They live in two places:

- **`srcs/.env`** — non-sensitive configuration (domain name, site title, usernames,database passwords, root password).

To find the WordPress admin username, check the `WP_ADMIN_USER` variable in `srcs/.env`. The corresponding password is stored in `srcs/.env`. 

If you need to change the admin password after the site is already running, use:
```bash
docker exec -it wordpress wp user update <admin_username> --user_pass=<newpassword> --allow-root
```

## 5. Checking that the services are running correctly

Check that all three containers are up:
```bash
docker ps
```
All three (`mariadb`, `wordpress`, `nginx`) should show status `Up`, not `Restarting` or `Exited`.

Check the site responds correctly:
```bash
curl -kv https://lasoubai.42.fr
```
A response (even a redirect) confirms NGINX is serving traffic.

Check the database is reachable:
```bash
docker exec -it mariadb mysqladmin -u root -p ping
```
(You'll be prompted for the root password stored in `srcs/.env`.) A reply of `mysqld is alive` confirms MariaDB is healthy.

If something looks wrong, check the logs of the specific container:
```bash
docker logs nginx
docker logs wordpress
docker logs mariadb
```