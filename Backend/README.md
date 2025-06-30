# Versace E-Commerce Backend

A robust backend system built with Node.js and Express, implementing secure APIs and real-time features for the Versace e-commerce platform.

## Features

### Authentication & Security

- 🔐 **Secure Authentication**
  - Email-based OTP verification
  - JWT token management
  - Device ID-based session tracking
  - Multi-device session management
  - Password encryption and hashing
  - Rate limiting and request validation

### User Management

- 👤 **User Services**
  - Complete user CRUD operations
  - Email Verificatio by OTP
  - Profile management
  - Address management
  - Device management
  - Session tracking per device
  - Push notification management

### Product Management

- 📦 **Product Services**
  - Product CRUD operations
  - Category management
  - Inventory tracking
  - Price management
  - Stock alerts
  - Product search and filtering

### Order Management

- 🛍️ **Order Processing**
  - Order creation and tracking
  - Payment processing
  - Delivery status updates
  - Order cancellation
  - Wallet Configuration
  - Refund processing
  - Order history

### Payment Integration

- 💳 **Payment Services**
  - UPI integration
  - Stripe payment gateway
  - Wallet management
  - Refund processing
  - Transaction history
  - Payment status tracking

### Location Services

- 📍 **Location Management**
  - Geocoding services
  - Delivery area management
  - Location-based product recommendations
  - Store locator
  - Delivery time estimation

### Analytics & Monitoring

- 📊 **Analytics Services**
  - User behavior tracking
  - Sales analytics
  - Product performance metrics
  - Device usage statistics
  - Error tracking and logging

## Technical Implementation

### Architecture

- 🏗️ **Clean Architecture**
  - MVC pattern
  - Service layer implementation
  - Repository pattern
  - Middleware implementation
  - Error handling

### Database

- 💾 **Data Management**
  - MongoDB for main database
  - Redis for caching
  - Session storage
  - Device tracking
  - Real-time data updates

### API Design

- 🔌 **RESTful APIs**
  - RESTful endpoints
  - API versioning
  - Request validation
  - Response formatting
  - Error handling
  - API documentation

### Security

- 🔒 **Security Measures**
  - Input validation
  - SQL injection prevention
  - XSS protection
  - CORS configuration
  - Request sanitization
  - Device ID validation

### Real-time Features

- ⚡ **Real-time Services**
  - WebSocket implementation
  - Real-time notifications
  - Chat support
  - Live inventory updates

## Technical Stack

- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MongoDB
- **Cache**: Redis
- **Authentication**: JWT
- **Payment**: Stripe, UPI
- **Real-time**: Socket.io
- **Email**: Nodemailer
- **File Storage**: AWS S3
- **Monitoring**: Winston, Sentry

## API Documentation

### Authentication Endpoints

```http
POST /api/v1/auth/register
POST /api/v1/auth/login
POST /api/v1/auth/verify-otp
POST /api/v1/auth/refresh-token
POST /api/v1/auth/logout
```

### User Endpoints

```http
```

### Product Endpoints

```http
```

### Order Endpoints

```http
```

## Getting Started

1. Clone the repository
2. Install dependencies:

   ```bash
   npm install
   ```

3. Configure environment variables:

   ```bash
   cp .env.example .env
   ```

4. Start the server:

   ```bash
   npm run dev
   ```

## Environment Variables

```env
PORT=3000
MONGODB_URI=mongodb://localhost:27017/versace
REDIS_URL=redis://localhost:6379
JWT_SECRET=your_jwt_secret
STRIPE_SECRET_KEY=your_stripe_secret
AWS_ACCESS_KEY=your_aws_key
AWS_SECRET_KEY=your_aws_secret
```

## Error Handling

The API uses a standardized error response format:

```json
{
  "status": "error",
  "code": "ERROR_CODE",
  "message": "Error description",
  "details": {}
}
```

## Rate Limiting

- Authentication endpoints: 5 requests per minute
- API endpoints: 100 requests per minute
- Device-specific limits: 1000 requests per hour

## Security Headers

```javascript
{
  "X-Content-Type-Options": "nosniff",
  "X-Frame-Options": "DENY",
  "X-XSS-Protection": "1; mode=block",
  "Strict-Transport-Security": "max-age=31536000; includeSubDomains"
}
```

## Supabase Image Storage Setup

This application uses Supabase for storing images for categories, subcategories, and product variants. Follow these steps to set up Supabase for image storage:

1. Create a Supabase account at [https://supabase.com](https://supabase.com) and create a new project
2. Navigate to the Storage section in your Supabase dashboard
3. Create three buckets with the following names:
   - `categories`
   - `subcategories`
   - `products`
4. Set the privacy settings for each bucket to "Public" so that the images can be accessed without authentication
5. Add the following environment variables to your `.env.development` and `.env.production` files:

   ```bash
   SUPABASE_URL=your_supabase_url
   SUPABASE_KEY=your_supabase_anon_key
   ```

   You can find these values in the API section of your Supabase project dashboard.

### Image Storage Structure

The application stores images in the following structure:

- **Categories**: Each category has a single image
- **Subcategories**: Each subcategory has a single image
- **Products**: Each product variant combination (color/size/variant) can have up to 4 images:
  - Main image: The primary product image
  - Thumbnail: A smaller version for listings
  - Detail1: Additional detail image
  - Detail2: Additional detail image

When updating colors for a product, you need to upload new images for each color variant.
