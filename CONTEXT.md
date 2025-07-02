# AllSafeASM Web Application - Context

## Project Overview

AllSafeASM is a cloud-based, AI-enhanced Attack Surface Management platform. The web application is built with Ruby on Rails 8, Hotwire (Turbo & Stimulus), Tailwind CSS, and PostgreSQL (Supabase). It provides user authentication (including social login via Google and GitHub), project/asset management, vulnerability scans, and dashboards for security visualization.

## Core Features

- User registration, login, and password reset (native and social login)
- Email verification for new users
- Project and asset (domain/IP) management (CRUD)
- Initiating and visualizing vulnerability scans
- Real-time UI updates (via Action Cable)
- Security dashboards presenting the scan results.
- An integrated LLM that answers the user's inquiries about the scan results and vulnerabilities discovered, if any.

## Development

- **Account Page:** User profile management, password change, social account linking. A user is only represented by email if he did not link with (github/google). If he did link his social accounts, his image and name will be presented. Otherwise, a user can't upload an image or add his name. He only achieves this by social account linking.
- **Assets Page:** This is the root URL, It has a input bar where the user enters the domain to be added to his assets, also has a list of assets associated with the user. Also has CRUD for domains.
- **Scan Page:** When a user clicks on a specific asset (domain) in the Assets Page, it renders an overview of the specific asset, a button in initialize a scan, and a list of vulnerability/enumeration scans associated with the asset.
- **Results Visualization Page:** Clicking on a specific scan in the Scan Page renders a route that has details of the specific vulnerability/enumeration scan, and results visualization, with the integrated LLM chatbot.
- **Integration:** Connect with Go-based scanning microservice for automated scans.
- **Notifications:** Web push/email notifications for scan results and security alerts.

## Tech Stack

- Ruby on Rails 8
- Hotwire (Turbo, Stimulus)
- Tailwind CSS v4
- PostgreSQL (Supabase)
- OmniAuth (Google, GitHub)
- Action Mailer (email verification, password reset)

---
This file is used as context for LLMs to assist with code and feature development.
