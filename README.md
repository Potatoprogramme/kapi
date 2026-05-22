# KAPI — Coffee Collection Management System

A full-stack Ruby on Rails 8.1 application for managing a coffee business. It covers product costing, raw material tracking, order processing, and a JWT-authenticated API for mobile or external clients.

---

## Overview

KAPI is an internal management system for a coffee shop. It replaces spreadsheet-based workflows with application logic for products, ingredients, materials, product costing, and orders.

---

## Features

### Products & Costing
- Create and manage products with thumbnail images
- Add ingredients per product with quantity and cost per unit
- Automatic costing via product costing records, including direct cost, overhead percentage, overhead cost, total cost, profit margin percentage, profit margin amount, and selling price
- Product category management
- Product status management with active and deleted states

### Materials & Inventory
- Track raw materials with name, unit, cost, cost per unit, and quantity
- Search, sort, and paginate material listings
- Prevent deletion of materials that are already referenced by ingredients

### Orders
- Create orders with order items and payment method
- Supported payment methods: cash, GCash, Card, and Maya
- Order status flow: pending, completed, voided

### API
- JWT-authenticated REST API
- Endpoints for authentication, materials, product categories, orders, and products
- Access token and refresh token support
- JSON responses rendered with JBuilder

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Ruby on Rails 8.1 |
| Database | PostgreSQL |
| Background Jobs | Solid Queue |
| Authentication | Rails session authentication + BCrypt |
| API Auth | JWT |
| File Uploads | Active Storage |
| Frontend | Importmap, Turbo, Stimulus |
| JSON Views | JBuilder |
| Pagination | Kaminari |
| API Auth Helpers | Custom JWT concern |
| Testing | RSpec, Factory Bot, Faker |
| API Docs | Rswag gem is included |

---

## Architecture

KAPI uses a mixed Rails architecture with controllers, query objects, and interactor services.

- Web controllers handle the main UI flows.
- API controllers live under `app/controllers/api/kapi/v1`.
- Query objects handle list filtering, search, and pagination.
- Interactors handle some create/update business workflows.
- Models enforce validations, associations, and enums.
- JBuilder templates render API responses.

Key patterns used:
- Query object pattern for search and pagination
- Interactor pattern for product and order creation
- Active Record transactions for multi-model saves
- Eager loading and joins to reduce N+1 queries

---

## Getting Started

### Prerequisites
- Ruby 3.4+
- PostgreSQL

### Setup
```bash
bundle install
rails db:create db:migrate
rails db:seed
bin/dev
```

If your local setup needs environment variables, configure the PostgreSQL connection details and `SECRET_KEY_BASE` in your shell or environment file.

### Running Background Jobs
```bash
./bin/jobs
```

The app also mounts job monitoring at `/jobs`.

---

## API Endpoints

Base URL: `/api/kapi/v1`

All protected endpoints require:

```http
Authorization: Bearer <token>
```

| Method | Endpoint | Description | Auth |
|---|---|---|---|
| POST | `/auth/login` | Login and receive JWT tokens | No |
| POST | `/auth/refresh` | Refresh access token | No |
| POST | `/register/user` | Register a user | No |
| GET | `/materials` | List materials | No |
| GET | `/materials/:id` | Show material | No |
| POST | `/materials` | Create material | Yes |
| PATCH | `/materials/:id` | Update material | Yes |
| DELETE | `/materials/:id` | Delete material | Yes |
| GET | `/product_categories` | List product categories | No |
| GET | `/product_categories/:id` | Show product category | No |
| POST | `/product_categories` | Create product category | Yes |
| PATCH | `/product_categories/:id` | Update product category | Yes |
| DELETE | `/product_categories/:id` | Delete product category | Yes |
| GET | `/orders` | List orders, filtered by status | No |
| POST | `/orders` | Create order | Yes |
| DELETE | `/orders/:id/hard_delete` | Permanently delete order | Yes |
| PATCH | `/orders/:id/complete` | Mark order completed | Yes |
| PATCH | `/orders/:id/void` | Mark order voided | Yes |
| GET | `/products` | List active products | No |
| GET | `/products/:id` | Show product | No |
| POST | `/products` | Create product | Yes |
| PATCH | `/products/:id` | Update product | Yes |
| DELETE | `/products/:id` | Soft delete product | Yes |
| DELETE | `/products/:id/hard_delete` | Permanently delete product | Yes |

---

## Database Schema

```text
users
	id, email_address, password_digest, created_at, updated_at

sessions
	id, user_id, ip_address, user_agent, created_at, updated_at

product_categories
	id, user_id, name, description, created_at, updated_at

materials
	id, user_id, name, cost, cost_per_unit, quantity, unit, created_at, updated_at

products
	id, user_id, product_category_id, name, status, created_at, updated_at

product_costings
	id, product_id, direct_cost, overhead_percentage, overhead_cost,
	total_cost, profit_margin_percentage, profit_margin_amount, selling_price,
	created_at, updated_at

ingredients
	id, user_id, material_id, product_id, quantity, total_cost, created_at, updated_at

orders
	id, user_id, order_total, payment_method, status, created_at, updated_at

order_items
	id, order_id, product_id, cost_per_item, item_name, item_total_cost,
	quantity, created_at, updated_at
```

---

## Running Tests

```bash
bundle exec rspec
bundle exec rspec spec/requests/api/kapi/v1/materials_spec.rb
bundle exec rspec spec/requests/api/kapi/v1/products_spec.rb
bundle exec rspec spec/requests/api/kapi/v1/orders_spec.rb
```

---

## Notes

- The app uses Rails session authentication for the web UI and JWT for the API.
- The frontend uses importmap, not a Node-based bundler.
- The API docs gem is present, but I did not verify a mounted Swagger UI route in the app routes.

---

## License

MIT

---

Built during internship at NUECA, Naga City · 2026
