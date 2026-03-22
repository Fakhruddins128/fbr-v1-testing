# FBR SaaS - Project Flow

This document describes the key business processes and data flows within the FBR SaaS application.

## 1. Authentication Flow
The application uses JWT-based authentication to secure all API endpoints.

1. **User Login**: 
   - User enters credentials on the [Login.tsx](file:///d:/project/React/fbr-v1-testing/src/pages/Login.tsx) page.
   - Frontend sends a `POST /api/login` request to the backend.
   - Backend validates credentials against the database and generates a JWT.
   - JWT and user info (role, companyId) are returned and stored in `localStorage`.
2. **Authorized Requests**:
   - For every subsequent request, the `token` is retrieved from `localStorage` and added to the `Authorization` header.
   - The backend `authenticateToken` middleware in [server.js](file:///d:/project/React/fbr-v1-testing/backend/server.js) verifies the token before processing the request.

---

## 2. Sales Invoice Lifecycle
The core workflow for managing sales invoices and complying with FBR regulations.

### Phase A: Local Creation
1. **Data Entry**: User fills out the invoice form in [SalesInvoice.tsx](file:///d:/project/React/fbr-v1-testing/src/pages/SalesInvoice.tsx).
2. **Persistence**:
   - Frontend sends `POST /api/invoices` with invoice and item details.
   - Backend starts a SQL transaction to save data to `Invoices` and `InvoiceItems` tables.
   - The invoice is saved with a local `InvoiceNumber` (e.g., `INV-12345`).

### Phase B: FBR Submission
1. **Trigger**: User selects an unsent invoice and clicks "Submit to FBR".
2. **Token Retrieval**: 
   - Frontend calls `GET /api/companies/:id/fbr-token` to get the company's specific FBR API token.
3. **FBR API Call**:
   - Frontend (via [fbrApi.ts](file:///d:/project/React/fbr-v1-testing/src/api/fbrApi.ts)) formats the payload according to FBR requirements.
   - A direct request is made to the FBR Gateway (`postinvoicedata` or `postinvoicedata_sb`).
4. **Local Update**:
   - If FBR returns success, the frontend receives an `FBR Invoice Number`.
   - Frontend calls `POST /api/invoices/:id/fbr-status` to update the local database.
   - **Result**: The invoice is now "Locked". The delete and edit icons are disabled in the UI.

---

## 3. Data Flow Diagram (Conceptual)

```text
[Frontend: React] 
       |
       | (1) POST /api/invoices
       v
[Backend: Express] <------> [Database: MSSQL]
       |
       | (2) Success Response
       v
[Frontend: React]
       |
       | (3) POST (Direct to FBR API)
       v
[FBR Gateway]
       |
       | (4) FBR Invoice Number
       v
[Frontend: React]
       |
       | (5) POST /api/invoices/:id/fbr-status
       v
[Backend: Express] <------> [Database: MSSQL] (Updates Status)
```

---

## 4. Reporting & Dashboard
1. **Data Fetching**: The [Dashboard.tsx](file:///d:/project/React/fbr-v1-testing/src/pages/Dashboard.tsx) and [Reports.tsx](file:///d:/project/React/fbr-v1-testing/src/pages/Reports.tsx) pages fetch all invoices for the current company.
2. **Calculation**: Frontend logic calculates totals for:
   - Total Generated Invoices
   - FBR Submitted Invoices
   - Total Sales Tax & Further Tax
3. **Visualization**: Data is displayed using `Chart.js` and `Recharts` for trends and `Material UI` grids for summary cards.

---

## 5. Role-Based Access (RBAC)
- **Super Admin**: 
  - Can manage all companies and users.
  - Can create invoices for any company by overriding the `X-Company-ID` header.
- **Admin/User**:
  - Limited to data within their own `CompanyID`.
  - Backend middleware `requireCompanyAccess` ensures data isolation between tenants.
