# FBR SaaS - Project Documentation

This project is a SaaS application for managing sales, purchases, and invoices, with integrated support for submitting invoices to the **Federal Board of Revenue (FBR)** of Pakistan.

## Table of Contents
1. [Tech Stack](#tech-stack)
2. [Project Structure](#project-structure)
3. [Features](#features)
4. [Getting Started](#getting-started)
   - [Prerequisites](#prerequisites)
   - [Installation](#installation)
   - [Environment Variables](#environment-variables)
5. [Database Setup](#database-setup)
6. [FBR Integration](#fbr-integration)
7. [API Endpoints](#api-endpoints)

---

## Tech Stack

### Frontend
- **Framework:** React 19 (TypeScript)
- **State Management:** Redux Toolkit
- **UI Components:** Material UI (MUI)
- **Routing:** React Router DOM
- **Charts:** Chart.js, Recharts
- **PDF Generation:** jspdf
- **Utilities:** axios, date-fns, xlsx, qrcode.react

### Backend
- **Runtime:** Node.js
- **Framework:** Express
- **Database:** MSSQL (Microsoft SQL Server)
- **Authentication:** JWT (JSON Web Token), bcrypt
- **Middleware:** cors, body-parser, dotenv

---

## Project Structure

```text
fbr-v1-testing/
├── backend/                # Node.js Backend
│   ├── database/           # SQL migration and setup scripts
│   ├── migrations/         # Additional SQL migrations
│   ├── server.js           # Main Express server entry point
│   └── package.json        # Backend dependencies
├── public/                 # Static assets for React
├── src/                    # React Frontend Source
│   ├── api/                # API service layers
│   ├── components/         # Reusable React components
│   │   ├── common/         # Common UI elements
│   │   ├── layout/         # Layout components (Sidebar, Navbar)
│   │   ├── providers/      # React context providers
│   │   └── sales/          # Sales-specific components
│   ├── hooks/              # Custom React hooks
│   ├── pages/              # Main application pages/routes
│   ├── services/           # Service-layer logic
│   ├── store/              # Redux store and slices
│   ├── types/              # TypeScript interfaces/types
│   ├── utils/              # Helper functions and constants
│   ├── App.tsx             # Root React component
│   └── index.tsx           # React entry point
├── package.json            # Frontend dependencies
└── tsconfig.json           # TypeScript configuration
```

---

## Features

- **Dashboard:** Overview of sales, purchases, and FBR submission statistics.
- **Company Management:** CRUD operations for managing different companies in the SaaS platform.
- **User Management:** Role-based access control (RBAC) for managing platform users.
- **Invoice Management:** Complete workflow for creating, editing, and printing sales invoices.
- **FBR Integration:** Automated submission of sales invoices to FBR, handling errors and success responses.
- **Purchases & Items:** Tracking of purchase invoices and inventory items.
- **Customer & Vendor Management:** Directories for managing business contacts.
- **Reports:** Detailed reporting for sales, purchases, and tax calculations.
- **Scenario Management:** Mapping and validation for different FBR tax scenarios.

---

## Getting Started

### Prerequisites
- Node.js (LTS version recommended)
- MSSQL Server (local or remote)
- npm or yarn

### Installation

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd fbr-v1-testing
   ```

2. **Install Frontend dependencies:**
   ```bash
   npm install
   ```

3. **Install Backend dependencies:**
   ```bash
   cd backend
   npm install
   ```

### Environment Variables

Create a `.env` file in the `backend/` directory:

```env
PORT=5001
DB_USER=your_db_user
DB_PASSWORD=your_db_password
DB_HOST=localhost
DB_NAME=FBR_SaaS
DB_PORT=1433
JWT_SECRET=your_jwt_secret
```

---

## Database Setup

The database uses Microsoft SQL Server. Follow these steps to set up the schema:

1. Create a database named `FBR_SaaS`.
2. Run the main setup script: `backend/database/setup.sql`.
3. Run additional scripts in `backend/database/` to create specific tables (Items, Purchases, Scenarios, etc.).
4. Apply migrations from `backend/migrations/` to update the schema with the latest changes.

---

## FBR Integration

The application integrates with the FBR POS API. Key files:
- [fbrApi.ts](file:///d:/project/React/fbr-v1-testing/src/api/fbrApi.ts): Handles API calls to the backend for FBR submission.
- [FBRInvoiceSubmission.tsx](file:///d:/project/React/fbr-v1-testing/src/components/sales/FBRInvoiceSubmission.tsx): UI component for managing the FBR submission process.
- [fbrUtils.ts](file:///d:/project/React/fbr-v1-testing/src/utils/fbrUtils.ts): Utilities for formatting data for FBR compliance.

Invoices with an FBR Invoice Number are **locked** (cannot be edited or deleted) to ensure data integrity and compliance.

---

## API Endpoints

The backend provides several RESTful endpoints:
- `POST /api/login`: User authentication.
- `GET /api/invoices`: Retrieve invoices for the logged-in user's company.
- `POST /api/invoices`: Create a new invoice.
- `POST /api/fbr/submit`: Submit an invoice to FBR.
- `GET /api/companies`: Manage companies (Super Admin only).
- `GET /api/dashboard/stats`: Retrieve statistics for the dashboard.

*Detailed API documentation can be found by exploring the route handlers in `backend/server.js`.*
