# Inception 🐳

This project involves broadening knowledge of system administration by using Docker to virtualize several Docker images, creating a small infrastructure in a personal virtual machine. The goal is to set up a specific infrastructure using `docker-compose` with NGINX, MariaDB, and WordPress, each running in its own container.

## 🏗 Architecture

The infrastructure consists of three separate containers connected via a custom Docker network:

* **NGINX:** The entry point. It handles HTTPS (TLSv1.2/1.3) and forwards PHP requests to the WordPress container.
* **WordPress:** The application container running PHP-FPM. It contains the WP-CLI scripts to auto-install the site.
* **MariaDB:** The database container. It stores the WordPress data and is isolated from the outside world (no public ports).

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
sudo vim /etc/hosts

# Add the following line
127.0.0.1   cbopp.42.fr

### 2. Clone the Repository
git clone <repository_url> inception
cd inception

### 3. Setup Environment Variables
Create a `.env` file in the `srcs/` directory.
touch srcs/.env

Copy the keys from the **Configuration** section below and fill in your secrets.

### 4. Build and Run
Use the Makefile to build the images and start the containers.
make

* First launch will take a few minutes to build the images and install WordPress.
* The WordPress installer waits for MariaDB to be ready before configuring the site.

### 5. Access the Site
Open your browser and navigate to:
* **https://cbopp.42.fr** (Accept the self-signed certificate warning)

## ⚙️ Configuration (.env)

Define the following keys in `srcs/.env`. **Do not commit your actual passwords to Git.**

DOMAIN_NAME=

# --- MySQL / MariaDB Setup ---
SQL_HOST=
SQL_DATABASE=
SQL_USER=
MYSQL_USER=

# Secrets (REQUIRED for scripts to work)
SQL_PASSWORD=
SQL_ROOT_PASSWORD=

# --- WordPress Install Config ---
WP_URL=
WP_TITLE=
WP_ADMIN_USER=
WP_ADMIN_EMAIL=
WP_ADMIN_PASSWORD=

# --- WordPress Secondary User ---
WP_USER=
WP_EMAIL=
WP_PASSWORD=

## 🎮 Usage Commands

The project includes a `Makefile` to simplify management:

| Command | Description |
| :--- | :--- |
| `make` | Build images, create volumes, and start the cluster in the background. |
| `make down` | Stop and remove the containers and networks. |
| `make clean` | Stop containers and remove docker images/networks (keeps data). |
| `make fclean` | **Nuclear Option:** Stops everything, removes images, **deletes all database/site data** on the host. |
| `make re` | Rebuilds everything from scratch (fclean + all). |
| `make nginx` | Rebuilds only the NGINX container. |
| `make wordpress` | Rebuilds only the WordPress container. |
| `make mariadb` | Rebuilds only the MariaDB container. |

## 📁 Directory Structure

inception/
├── Makefile
└── srcs/
    ├── docker-compose.yml
    ├── .env                <-- You create this
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/
        │   └── tools/      <-- Initialization script
        ├── nginx/
        │   ├── Dockerfile
        │   └── conf/       <-- SSL & Config
        └── wordpress/
            ├── Dockerfile
            ├── conf/
            └── tools/      <-- WP-CLI Setup script
