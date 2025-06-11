# AllSafeASM - Web Application

AllSafeASM is a cloud-based, AI-enhanced Attack Surface Management solution designed to provide organizations with a streamlined platform for proactive security. This repository contains the primary web application, which serves as the user-facing interface for the entire system.

This application is responsible for:

-   User account management and authentication.
-   Project and asset organization.
-   Initiating vulnerability scans.
-   Visualizing scan results and security dashboards.

This project is being developed as a graduation project for the Faculty of Engineering, Port Said University.

## Core Technologies

This web application is built with a modern, robust, and efficient technology stack, emphasizing developer productivity and a seamless user experience.

-   **Backend:** Ruby on Rails 8
-   **Frontend:** Hotwire (Turbo & Stimulus)
-   **Styling:** Tailwind CSS
-   **Database:** PostgreSQL (hosted on Supabase)
-   **Authentication:** Native Rails 8 authentication with OmniAuth for Google and Github Social Login

## Features

### Implemented

-   Complete User Authentication Flow:
    -   Secure user registration with email and password.
    -   Session management (login/logout).
    -   "Login with Google" via OmniAuth for seamless social login.
    -   Secure password hashing using bcrypt.

### Upcoming

-   CRUD functionality for managing security projects and assets (domains, IPs).
-   Integration with the Go-based scanning microservice.
-   Real-time UI updates for scan status (queued, scanning, completed) using Action Cable.
-   An interactive dashboard for visualizing vulnerability data and security posture.

## System Setup & Installation

Follow these steps to get a local development environment running.

### Prerequisites

-   Ruby (version 3.3.0 or later)
-   Rails 8
-   Bundler (`gem install bundler`)
-   PostgreSQL Client Library (`libpq`). Install it via:
    -   macOS (Homebrew): `brew install libpq`
    -   Ubuntu/Debian: `sudo apt install libpq-dev`
    -   Fedora/CentOS: `sudo dnf install libpq-devel`

### 1. Clone the Repository

```bash
git clone git@github.com:allsafeASM/webapp.git
cd webapp
```

### 2. Set Up Environment Variables

This project uses the `dotenv-rails` gem to manage environment variables. Copy the example file and fill in your credentials.

Add required credentials to `.env`

```env
# .env

# --- Supabase Database URLs ---
# These variables are used to construct the database connection string.
# Use the details from your Supabase Connection Pooler.
SUPABASE_HOST=YOUR_HOST
SUPABASE_PORT=YOUR_PORT
SUPABASE_USER=YOUR_USER
SUPABASE_DB_NAME=YOUR_DB_NAME
SUPABASE_PASSWORD=YOUR_SUPABASE_PASSWORD_HERE

# --- Social Login Credentials ---
GOOGLE_CLIENT_ID="YOUR_GOOGLE_CLIENT_ID_HERE"
GOOGLE_CLIENT_SECRET="YOUR_GOOGLE_CLIENT_SECRET_HERE"

GITHUB_CLIENT_ID="YOUR_GITHUB_CLIENT_ID_HERE"
GITHUB_CLIENT_SECRET="YOUR_GITHUB_CLIENT_SECRET_HERE"
```

**Important:** The `.env` file is listed in `.gitignore` and should never be committed to source control.

### 3. Install Dependencies

```bash
bundle install
```

### Running the Application

To start the web server, run the following command.

```bash
bin/rails s
```

Open your web browser and navigate to `http://localhost:3000`.

## Project Team

-   Abdelrahman Magdi - `abdomagdi300@gmail.com`
-   Omar Essam - `omar.e.gado@gmail.com`
-   Hazem Osama - `hazemosama681@gmail.com`