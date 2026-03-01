# 💳 DigitalWallet — Flutter FinTech App

A production-grade **Digital Wallet** Flutter application built with Clean Architecture, BLoC state management, and fintech-level security practices.

---

## 🏗️ Architecture Overview

```
lib/
├── core/
│   ├── api/
│   │   ├── api_client.dart         # Dio client with interceptors
│   │   └── api_response.dart       # Unified response handler
│   ├── constants/
│   │   ├── app_constants.dart      # Timeouts, limits, keys
│   │   └── api_endpoints.dart      # All API endpoint constants
│   ├── error_handler/
│   │   └── failures.dart           # Failure + Exception types
│   ├── theme/
│   │   └── app_theme.dart          # FinTech design system
│   └── utils/
│       ├── usecase.dart            # Abstract UseCase base class
│       ├── formatters.dart         # Currency, date, validation
│       └── token_storage.dart      # FlutterSecureStorage wrapper
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/        # API calls
│   │   │   ├── models/             # JSON serialization
│   │   │   └── repositories/       # Repository impl
│   │   ├── domain/
│   │   │   ├── entities/           # Pure Dart entities
│   │   │   ├── repositories/       # Abstract contracts
│   │   │   └── usecases/           # Business logic
│   │   └── presentation/
│   │       ├── bloc/               # AuthBloc (event/state)
│   │       ├── pages/              # LoginPage
│   │       └── widgets/            # AuthTextField
│   │
│   ├── dashboard/                  # Balance, quick actions, recent txns
│   ├── send_money/                 # Transfer flow + success dialog
│   └── transactions/               # Paginated list, pull-to-refresh
│
└── injection/
    └── injection.dart              # GetIt dependency setup
```

---

## 🔐 FinTech Security Features

| Feature | Implementation |
|---|---|
| Secure Token Storage | `flutter_secure_storage` with AES encryption |
| Android Keystore | `encryptedSharedPreferences: true` |
| iOS Keychain | `KeychainAccessibility.first_unlock_this_device` |
| Token Refresh | Auto-refresh on 401, queue pending requests |
| Session Clearing | Full secure storage wipe on logout |
| Portrait Lock | Enforced for sensitive screens |
| SSL Indicator | UI shows encrypted connection notice |
| Balance Visibility Toggle | Hide/show balance for privacy |

---

## 🌐 API Client — Dio Setup

### Interceptors Stack
```
Request → [AuthInterceptor] → [RetryInterceptor] → API
Response → [ErrorInterceptor] → [PrettyLogger] → BLoC
```

### AuthInterceptor
- Attaches `Bearer` token to every request (except login/refresh)
- On **401**: auto-triggers token refresh
- Queues concurrent 401 requests → retries all after refresh
- Clears storage and redirects to login if refresh fails

### RetryInterceptor
- Retries on network timeouts (exponential backoff: 1s, 2s, 3s)
- Max 3 retry attempts
- Only retries `connectionTimeout`, `receiveTimeout`, `connectionError`

### Configuration
```dart
BaseOptions(
  baseUrl: 'https://api.digitalwallet.com/v1',
  connectTimeout: 30s,
  receiveTimeout: 30s,
  sendTimeout: 30s,
  headers: {
    'X-Platform': 'android' | 'ios',
    'X-App-Version': '1.0.0',
  }
)
```

---

## 📦 State Management — BLoC

### AuthBloc
```
LoginRequested  → AuthLoading → AuthAuthenticated | AuthError
LogoutRequested → AuthLoading → AuthUnauthenticated
```

### DashboardBloc
```
DashboardLoadRequested  → DashboardLoading → DashboardLoaded | DashboardError
DashboardBalanceUpdated → DashboardLoaded (updated balance)
```

### TransactionBloc
```
FetchTransactions    → TransactionLoading → TransactionLoaded | TransactionEmpty | TransactionError
RefreshTransactions  → (same, replaces list)
LoadMoreTransactions → TransactionLoaded (isPaginating: true) → TransactionLoaded (appended)
```

### SendMoneyBloc
```
SendMoneyRequested → SendMoneyLoading → SendMoneySuccess | SendMoneyError
SendMoneyReset     → SendMoneyInitial
```

---

## ✅ Validation Rules

| Field | Rules |
|---|---|
| Email | RFC-compliant regex |
| Password | ≥8 chars, 1 uppercase, 1 number |
| Account Number | ≥10 digits |
| Amount | 0 < amount ≤ 50,000 |
| Amount | Cannot exceed current balance |

Validation happens at **3 layers**:
1. **UI** — `TextFormField` validators (instant feedback)
2. **Domain (UseCase)** — business rule enforcement before API call
3. **API** — server-side 422 handled and surfaced to UI

---

## 🚀 Getting Started

```bash
# Install dependencies
flutter pub get

# Run code generation (if using injectable)
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### Environment Setup
Update `lib/core/constants/app_constants.dart`:
```dart
static const String baseUrl = 'https://YOUR_API_URL/v1';
```

---

## 📱 Features Checklist

### ✅ Login
- [x] Email + password validation
- [x] Secure token storage (access + refresh)
- [x] Loading indicator during API call
- [x] Error snackbar on failure
- [x] Auto-navigate to dashboard on success
- [x] Remember me checkbox
- [x] Password visibility toggle
- [x] SSL encrypted notice

### ✅ Dashboard
- [x] Balance card with gradient
- [x] Balance visibility toggle (privacy)
- [x] KYC verification badge
- [x] Quick action buttons (Send, Top Up, History, More)
- [x] Recent transactions (last 5)
- [x] Shimmer loading skeleton
- [x] Pull-to-refresh

### ✅ Send Money
- [x] Receiver account number input
- [x] Amount input with ৳ prefix
- [x] Quick amount selector (৳500, ৳1000, ৳2000, ৳5000)
- [x] Remaining balance preview
- [x] Optional note field (max 100 chars)
- [x] 0 < amount ≤ 50,000 validation
- [x] Cannot exceed balance
- [x] Loading state during transfer
- [x] Success dialog with reference number
- [x] Balance auto-updated after success

### ✅ Transaction List
- [x] Paginated list (20 per page)
- [x] Infinite scroll pagination
- [x] Pull-to-refresh
- [x] Empty state with illustration
- [x] Error state with retry
- [x] Pagination error with retry
- [x] Transaction type icons + colors
- [x] Status badges (Completed/Pending/Failed/Reversed)
- [x] Credit/Debit color coding

---

## 📚 Dependencies

```yaml
flutter_bloc: ^8.1.5     # State management
dio: ^5.4.3               # HTTP client
flutter_secure_storage    # Encrypted token storage
get_it: ^7.7.0            # Dependency injection
dartz: ^0.10.1            # Either type (functional error_handler handling)
equatable: ^2.0.5         # Value equality for BLoC states
intl: ^0.19.0             # Currency & date formatting
connectivity_plus          # Network connectivity check
shimmer: ^3.0.0           # Loading skeletons
```
