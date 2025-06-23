# AllSafeASM Web Application - Context

## Project Overview

AllSafeASM is a cloud-based, AI-enhanced Attack Surface Management platform. The web application is built with Ruby on Rails 8, Hotwire (Turbo & Stimulus), Tailwind CSS, and PostgreSQL (Supabase). It provides user authentication (including social login via Google and GitHub), project/asset management, vulnerability scans, and dashboards for security visualization.

## Core Features

- User registration, login, and password reset (native and social login)
- Email verification for new users
- Project and asset (domain/IP) management (CRUD planned)
- Initiating and visualizing vulnerability scans
- Real-time UI updates (planned, via Action Cable)
- Security dashboards (planned)

## Upcoming Developments

- **Account Page:** User profile management, password change, social account linking.
- **Request Scan Page:** Has a input bar where the user enters the domain to scan, also has a list of scans associated with the user and their status.
- **Scan Dashboard Page:** Overview of scan status and results. List and details of vulnerability/enumeration scans, scan history, and results visualization.
- **Asset Management:** CRUD for domains, IPs, and projects.
- **Integration:** Connect with Go-based scanning microservice for automated scans.
- **Notifications:** Web push/email notifications for scan results and security alerts.
- **PWA Support:** Installable app with offline capabilities.

## Tech Stack

- Ruby on Rails 8
- Hotwire (Turbo, Stimulus)
- Tailwind CSS
- PostgreSQL (Supabase)
- OmniAuth (Google, GitHub)
- Action Mailer (email verification, password reset)

---
This file is used as context for LLMs to assist with code and feature development.
