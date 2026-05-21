# finMate - Smart Expense Tracking App

A professional Flutter application for tracking expenses with AI-powered insights and beautiful UI/UX.

## Features

✨ **Features**
- 💰 Easy expense tracking
- 📊 Beautiful analytics & charts
- 🤖 AI-powered insights
- 💳 Multiple expense categories
- 📱 Responsive design
- 🌙 Dark mode support

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   ├── theme/
│   └── widgets/
│       ├── base/
│       ├── buttons/
│       ├── inputs/
│       ├── loaders/
│       ├── navigation/
│       ├── snackbars/
│       └── states/
├── presentation/
│   ├── pages/
│   └── widgets/
└── main.dart
```

## Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK (3.0+)

### Installation

1. Clone the repository
```bash
git clone https://github.com/Cahyooo12/finMate.git
cd finMate
```

2. Install dependencies
```bash
flutter pub get
```

3. Generate code
```bash
dart run build_runner build
```

4. Run the app
```bash
flutter run
```

## Architecture

This project follows **Clean Architecture** with:
- **Core**: Reusable widgets, constants, and themes
- **Presentation**: Pages and feature-specific widgets
- **State Management**: Riverpod for reactive state

## Widget Structure

### Core Widgets (Reusable)
- `CustomCard` - Base card component
- `PrimaryButton`, `SecondaryButton` - Button variants
- `AppTextField` - Text input field
- `ShimmerLoader` - Loading skeleton
- `EmptyState`, `ErrorState` - State management widgets

### Feature Widgets
- `GreetingHeader` - Welcome message
- `BalanceSection` - Total balance display
- `ExpenseSummary` - Category breakdown
- `RecentTransactions` - Transaction list

## Theme System

Custom theme with:
- Color palette (primary, secondary, semantic colors)
- Typography (Poppins font)
- Component styling

## State Management

Using **Riverpod** for:
- Provider-based state
- Async data handling
- Caching and invalidation

## Contributing

Contributions are welcome! Please follow the existing code structure.

## License

MIT License - see LICENSE file for details

## Author

Cahyooo12 (@Cahyooo12)
