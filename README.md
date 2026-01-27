# Inception 🐳

This project involves broadening knowledge of system administration by using Docker to virtualize several Docker images, creating a small infrastructure in a personal virtual machine. The goal is to set up a specific infrastructure using `docker-compose` with NGINX, MariaDB, and WordPress, each running in its own container.

## 🏗 Architecture

The infrastructure consists of three separate containers connected via a custom Docker network:

### Mandatory Stack
* **NGINX:** The entry point. It handles HTTPS (TLSv1.2/1.3) and forwards PHP requests to the WordPress container.
* **WordPress:** The application container running PHP-FPM. It contains the WP-CLI scripts to auto-install the site.
* **MariaDB:** The database container. It stores the WordPress data and is isolated from the outside world (no public ports).

### Bonus Stack
* **Redis:** In-memory cache configured to speed up WordPress database queries.
* **FTP Server (vsftpd):** Provides direct file access to the WordPress volume.
* **Adminer:** A lightweight web-based database management tool (SQL GUI).
* **Portainer:** A visual dashboard to monitor and manage Docker containers.
* **Static Website:** A dedicated container serving a simple static HTML page.

All data for the database and WordPress files is persistent via Docker Volumes stored on the host machine.

## 📋 Prerequisites

* Docker Engine
* Docker Compose
* Make
* Root privileges (for `/etc/hosts` and volume creation)

## 🛠 Installation & Setup

### 1. Configure the Domain
To access the site via `cbopp.42.fr` instead of `localhost`, you must modify your hosts file.

# Open the hosts file
```bash
sudo vim /etc/hosts
```

# Add the following line
```
127.0.0.1   cbopp.42.fr
```

### 2. Clone the Repository
git clone <repository_url> inception
cd inception

### 3. Setup Environment Variables
Create a `.env` file in the `srcs/` directory.
```
touch srcs/.env
```

Copy the keys from the **Configuration** section below and fill in your secrets.

### 4. Build and Run
Use the Makefile to build the images and start the containers.
```
make
```

* First launch will take a few minutes to build the images and install WordPress.
* The WordPress installer waits for MariaDB to be ready before configuring the site.

### 5. Access the Services
Open your browser and navigate to:
| Service | URL/Access | Description |
| :--- | :--- | :---|
| Wordpress | https://cbopp.42.fr | Main website |
| Adminer | https://cbopp.42.fr/adminer | Database GUI (User: user, Server: mariadb) |
| Static site | https://cbopp.42.fr/static | Static HTML page |
| Portainer | https://cbopp.42.fr:9443/ | Docker Management Dashboard |
| FTP | IP: `cbopp.42.fr` Port: `21` | File Transfer |


## ⚙️ Configuration (.env)

Define the following keys in `srcs/.env`. **Do not commit your actual passwords to Git.**

```
DOMAIN_NAME=cbopp.42.fr

# --- MySQL / MariaDB Setup ---
SQL_HOST=mariadb:3306
SQL_DATABASE=wordpress
SQL_USER=

# --- WordPress Install Config ---
WP_URL=cbopp.42.fr
WP_TITLE=
WP_ADMIN_USER=
WP_ADMIN_EMAIL=

# --- WordPress Secondary User ---
WP_USER=
WP_EMAIL=
WP_PASSWORD=

# --- FTP User ---
FTP_USER=
```

## Secrets

Define the important passwords in the following files:
```bash
touch secrets/db_password.txt secrets/db_root_password.txt secrets/wp_admin_password.txt secrets/ftp_password.txt
```

## 🎮 Usage Commands

The project includes a `Makefile` to simplify management:

| Command | Description |
| :--- | :--- |
| `make` | Builds images, create volumes, and start the cluster in the background. |
| `make down` | Stops and removes the containers and networks. |
| `make clean` | Stops containers and removes docker images/networks (keeps data). |
| `make fclean` | **Nuclear Option:** Stops everything, removes images, **deletes all database/site data** on the host. |
| `make re` | Rebuilds everything from scratch (fclean + all). |
| `make nginx` | Rebuilds only the NGINX container. |
| `make wordpress` | Rebuilds only the WordPress container. |
| `make mariadb` | Rebuilds only the MariaDB container. |
| `make redis` | Rebuilds only the Redis container. |
| `make adminer` | Rebuilds only the Adminer container. |
| `make portainer` | Rebuilds only the Portainer container. |
| `make website` | Rebuilds only the static site container. |
| `make ftp` | Rebuilds only the FTP container. |

## 📁 Directory Structure

```
inception/
├── Makefile
└── srcs/
    ├── docker-compose.yml
    ├── .env                <-- You create this
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        ├── nginx/
        │   ├── Dockerfile
        │   └── conf/
        ├── wordpress/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/
        └── bonus/
            ├── adminer/
            ├── ftp/
            ├── portainer/
            ├── redis/
            └── website/
```
