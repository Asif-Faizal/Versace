# Versace E-Commerce Platform

A full-stack e-commerce solution comprising a Flutter mobile application and Node.js backend, implementing modern architecture patterns and robust security measures.

## Project Structure

```
versace/
├── Mobile/                 # Flutter mobile application
│   ├── lib/
│   │   ├── core/          # Core functionality
│   │   ├── features/      # Feature modules
│   │   └── main.dart      # Application entry point
│   └── README.md          # Mobile app documentation
│
└── Backend/               # Node.js backend server
    ├── src/
    │   ├── controllers/   # Request handlers
    │   ├── models/        # Data models
    │   ├── services/      # Business logic
    │   └── routes/        # API routes
    └── README.md          # Backend documentation
```

## Features

### Mobile Application

- 🔐 **Authentication**
  - Email-based OTP verification
  - Device ID-based session management
  - Secure password handling
  - Multi-device support

- 🛍️ **Shopping Experience**
  - Dynamic home screen
  - Location-based services
  - Wishlist management
  - Shopping cart
  - Real-time price updates

- 💳 **Payment & Orders**
  - Multiple payment methods (UPI, Stripe)
  - Order tracking
  - Delivery status
  - Wallet management
  - Refund processing

### Backend Services

- 🔌 **API Services**
  - RESTful endpoints
  - Real-time WebSocket
  - Push notifications
  - File storage (AWS S3)

- 📊 **Data Management**
  - MongoDB database
  - Redis caching
  - Session management
  - Device tracking

- 🔒 **Security**
  - JWT authentication
  - Rate limiting
  - Input validation
  - XSS protection

## Technical Stack

### Mobile

- **Framework**: Flutter
- **State Management**: Flutter Bloc
- **Architecture**: Clean Architecture
- **Dependency Injection**: get_it
- **Local Storage**: Shared Preferences
- **Payment**: Stripe, UPI
- **Analytics**: Firebase

### Backend

- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: MongoDB
- **Cache**: Redis
- **Authentication**: JWT
- **Real-time**: Socket.io
- **Storage**: AWS S3
- **Monitoring**: Winston, Sentry

## Getting Started

### Prerequisites

- Flutter SDK
- Node.js
- MongoDB
- Redis
- AWS Account (for S3)
- Stripe Account

### Mobile Setup

1. Navigate to Mobile directory:

   ```bash
   cd Mobile
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Configure environment:

   ```bash
   cp .env.example .env
   ```

4. Run the app:

   ```bash
   flutter run
   ```

### Backend Setup

1. Navigate to Backend directory:

   ```bash
   cd Backend
   ```

2. Install dependencies:

   ```bash
   npm install
   ```

3. Configure environment:

   ```bash
   cp .env.example .env
   ```

4. Start the server:

   ```bash
   npm run dev
   ```

## Environment Configuration

### Mobile (.env)

```env
API_BASE_URL=http://localhost:3000
STRIPE_PUBLISHABLE_KEY=your_stripe_key
```

### Backend (.env)

```env
PORT=3000
MONGODB_URI=mongodb://localhost:27017/versace
REDIS_URL=redis://localhost:6379
JWT_SECRET=your_jwt_secret
STRIPE_SECRET_KEY=your_stripe_secret
AWS_ACCESS_KEY=your_aws_key
AWS_SECRET_KEY=your_aws_secret
```

## Development Workflow

1. **Feature Development**
   - Create feature branch
   - Implement mobile and backend changes
   - Write tests
   - Create pull request

2. **Testing**
   - Unit tests
   - Integration tests
   - UI tests
   - API tests

3. **Deployment**
   - Mobile app deployment to stores
   - Backend deployment to cloud
   - Database migrations
   - Cache updates

## Security Measures

### Mobile

- Device ID validation
- Secure storage
- Encrypted communications
- Token management

### Backend

- Rate limiting
- Input validation
- SQL injection prevention
- XSS protection
- CORS configuration

## Monitoring & Analytics

### Mobile

- Firebase Analytics
- Crash reporting
- User behavior tracking
- Performance monitoring

### Backend

- Error tracking
- Request logging
- Performance metrics
- User analytics

## Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create pull request
