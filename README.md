<p align="center"><a href="https://laravel.com" target="_blank"><img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="400" alt="Laravel Logo"></a></p>

<p align="center">
<a href="https://github.com/laravel/framework/actions"><img src="https://github.com/laravel/framework/workflows/tests/badge.svg" alt="Build Status"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/dt/laravel/framework" alt="Total Downloads"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/v/laravel/framework" alt="Latest Stable Version"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/l/laravel/framework" alt="License"></a>
</p>

## About Laravel

Laravel is a web application framework with expressive, elegant syntax. We believe development must be an enjoyable and creative experience to be truly fulfilling. Laravel takes the pain out of development by easing common tasks used in many web projects, such as:

- [Simple, fast routing engine](https://laravel.com/docs/routing).
- [Powerful dependency injection container](https://laravel.com/docs/container).
- Multiple back-ends for [session](https://laravel.com/docs/session) and [cache](https://laravel.com/docs/cache) storage.
- Expressive, intuitive [database ORM](https://laravel.com/docs/eloquent).
- Database agnostic [schema migrations](https://laravel.com/docs/migrations).
- [Robust background job processing](https://laravel.com/docs/queues).
- [Real-time event broadcasting](https://laravel.com/docs/broadcasting).

Laravel is accessible, powerful, and provides tools required for large, robust applications.

## Learning Laravel

Laravel has the most extensive and thorough [documentation](https://laravel.com/docs) and video tutorial library of all modern web application frameworks, making it a breeze to get started with the framework.

You may also try the [Laravel Bootcamp](https://bootcamp.laravel.com), where you will be guided through building a modern Laravel application from scratch.

If you don't feel like reading, [Laracasts](https://laracasts.com) can help. Laracasts contains thousands of video tutorials on a range of topics including Laravel, modern PHP, unit testing, and JavaScript. Boost your skills by digging into our comprehensive video library.

## Laravel Sponsors

We would like to extend our thanks to the following sponsors for funding Laravel development. If you are interested in becoming a sponsor, please visit the [Laravel Partners program](https://partners.laravel.com).

### Premium Partners

- **[Vehikl](https://vehikl.com/)**
- **[Tighten Co.](https://tighten.co)**
- **[WebReinvent](https://webreinvent.com/)**
- **[Kirschbaum Development Group](https://kirschbaumdevelopment.com)**
- **[64 Robots](https://64robots.com)**
- **[Curotec](https://www.curotec.com/services/technologies/laravel/)**
- **[Cyber-Duck](https://cyber-duck.co.uk)**
- **[DevSquad](https://devsquad.com/hire-laravel-developers)**
- **[Jump24](https://jump24.co.uk)**
- **[Redberry](https://redberry.international/laravel/)**
- **[Active Logic](https://activelogic.com)**
- **[byte5](https://byte5.de)**
- **[OP.GG](https://op.gg)**

## Contributing

Thank you for considering contributing to the Laravel framework! The contribution guide can be found in the [Laravel documentation](https://laravel.com/docs/contributions).

## Code of Conduct

In order to ensure that the Laravel community is welcoming to all, please review and abide by the [Code of Conduct](https://laravel.com/docs/contributions#code-of-conduct).

## Security Vulnerabilities

If you discover a security vulnerability within Laravel, please send an e-mail to Taylor Otwell via [taylor@laravel.com](mailto:taylor@laravel.com). All security vulnerabilities will be promptly addressed.

## License

The Laravel framework is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).

# GameService Project

This project is a Laravel application set up to run in a Dockerized environment. It's designed for testing faceted search in various scenarios, primarily using the `k-samuel/faceted-search` PHP library.

## Core Technology: Faceted Search

The faceted search capabilities of this project are planned to be built around the **`k-samuel/faceted-search`** PHP library.

*   **GitHub Repository:** [https://github.com/k-samuel/faceted-search](https://github.com/k-samuel/faceted-search)
*   **Purpose:** This library provides a simplified and fast way to implement faceted search functionality without relying on external search servers like Elasticsearch. It's designed to be performant for datasets up to around 500,000 items with multiple properties.

This project will serve as a testing ground and demonstration for integrating and utilizing this library within a Laravel application.

## Prerequisites

*   Docker Desktop (or Docker Engine + Docker Compose V2) installed and running.
*   Git installed.
*   A terminal or command prompt.
*   SSH client configured for GitHub access (if cloning via SSH).

## Project Setup

1.  **Clone the Repository:**
    ```bash
    git clone git@github.com:peresmishnyk/gameservice.git
    cd gameservice
    ```

2.  **Initialize the Project Environment:**
    This command will build Docker images, start containers, install Laravel, configure environment files, and set up necessary symlinks.
    ```bash
    make init
    ```
    During this process:
    *   A new Laravel project is installed.
    *   `.env.example` is configured for the Docker environment.
    *   `.env` is created from `.env.example` and `APP_KEY` is generated.
    *   The `env` symlink (pointing to `.env`) is added to `.gitignore`.
    *   Symlinks `env` (-> `.env`) and `env-example` (-> `.env.example`) are created in the project root.

3.  **Access the Application:**
    Once `make init` completes, the application should be accessible at [http://localhost:8000](http://localhost:8000).

## Makefile Commands

This project uses a `Makefile` to simplify common Docker and application tasks. Here are some of the main commands:

*   `make help`: Display a list of all available Makefile targets and their descriptions.
*   `make init`: (As described above) Initializes the entire project environment. **Run this first after cloning.**
*   `make up`: Start the Docker containers in detached mode.
*   `make down`: Stop and remove Docker containers, networks, and volumes.
*   `make stop`: Stop the Docker containers without removing them.
*   `make restart`: Restart the Docker containers.
*   `make build`: Build or rebuild the Docker images (e.g., after `Dockerfile` changes).
*   `make shell`: Access the `app` container's shell as the application user.
*   `make root-shell`: Access the `app` container's shell as `root`.
*   `make artisan ARGS="your-command"`: Run a Laravel Artisan command (e.g., `make artisan ARGS="migrate"`).
*   `make composer ARGS="your-command"`: Run a Composer command within the `app` container (e.g., `make composer ARGS="require new/package"`).
*   `make install`: A convenience command that runs `composer install` and then `npm install && npm run build` inside the `app` container.
*   `make fresh-db`: Runs `php artisan migrate:fresh` to drop all tables and re-run migrations.
*   `make seed`: Runs `php artisan db:seed` to populate the database with seed data.
*   `make logs`: Tail logs from the `app` container.
*   `make logs-nginx`: Tail logs from the `nginx` container.
*   `make logs-db`: Tail logs from the `db` container.
*   `make full-reset`: **(Destructive)** Stops and removes all Docker assets, stashes uncommitted Git changes, resets the Git repository to the last commit, removes all untracked files/directories, and deletes the `env` and `env-example` symlinks. Use with caution.

Refer to `make help` or the `Makefile` itself for the full list and details of all commands.

## Environment Configuration

*   The primary environment configuration is managed through the `.env` file in the project root.
*   The `make init` command automatically configures the `.env.example` and `.env` files with settings appropriate for the Docker environment (e.g., `DB_HOST=db`, `REDIS_HOST=redis`).
*   Nginx is configured to serve the application on port `8000` of your host machine.

## Contributing

Details for contributing to this project will be added later.
