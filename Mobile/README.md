# Versace E-Commerce Mobile App

A fully-featured e-commerce mobile application built with Flutter, implementing clean architecture and modern design patterns.

## Features

### Core Features

- 🔐 **Authentication**
  - OTP-based email verification
  - Secure password management
  - Password change functionality
  - Session management
  - Device ID locking

### User Management

- 👤 **User Profile**
  - Complete user CRUD operations
  - Push Notification
  - Profile customization
  - Address management
  - Order history

### Shopping Experience

- 🏠 **Dynamic Home Screen**
  - Featured categories
  - Promotional banners
  - Location based services
  - Targeted advertisements
- ❤️ **Wishlist**
  - Add/remove products
  - Wishlist synchronization
  - Quick add to cart
- 🛒 **Shopping Cart**
  - Real-time price updates
  - Quantity management
  - Save for later
  - Cart synchronization

### Order Management

- 📦 **Order Processing**
  - Multiple payment methods
  - Order tracking
  - Delivery status updates
  - Order cancellation
- ⭐ **Rating & Reviews**
  - Product ratings
  - Detailed reviews
  - Photo reviews
  - Rating analytics

### Payment Integration

- 💳 **Multiple Payment Methods**
  - UPI integration
  - Stripe payment gateway
  - Wallet system
  - Refund processing
- 💰 **Wallet Management**
  - Balance tracking
  - Transaction history
  - Refund to wallet
  - Wallet top-up

## Technical Implementation

### Architecture

- 🏗️ **Clean Architecture**
  - Separation of concerns
  - Dependency injection
  - Repository pattern
  - Use case implementation

### UI/UX

- 🎨 **Custom Theme Implementation**
  - Material 3 design
  - Light/Dark mode support
  - Custom color schemes
  - Typography system
  - Component theming
  - Responsive layouts

### Animations

- ✨ **Custom Animations**
  - Auto-scrolling text components
  - Smooth transitions
  - Loading animations
  - Interactive elements

### Platform Integration

- 📱 **Native Features**
  - Device ID retrieval (iOS & Android)
  - Platform-specific optimizations
  - Method channel implementation
  - Native API integration

### Security

- 🔒 **Data Protection**
  - Secure storage
  - Encrypted communications
  - Token management

## Technical Stack

- **Framework**: Flutter
- **State Management**: Flutter Bloc
- **Architecture**: Clean Architecture
- **Dependency Injection**: get_it
- **Local Storage**: Shared Preferences
- **Payment Gateways**: Stripe, UPI
- **Analytics**: Firebase Analytics
- **Crash Reporting**: Firebase Crashlytics

## Getting Started

1. Clone the repository
2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Configure environment variables
4. Run the app:

   ```bash
   flutter run
   ```
