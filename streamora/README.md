# Streamora

A premium cross-platform IPTV player app with Xtream API integration for iOS and Android.

## Features

### Core Features
- **Xtream Codes API Integration** - Connect to any IPTV service using Xtream Codes API
- **M3U Playlist Import** - Import playlists via M3U URL
- **Live TV** - Browse and watch live TV channels with categories
- **VOD (Movies)** - Browse and watch video-on-demand content
- **TV Series** - Browse series with seasons and episodes
- **EPG (Electronic Program Guide)** - View TV guide for channels
- **Favorites** - Save favorite channels, movies, and series
- **Continue Watching** - Resume playback from where you left off
- **Search** - Search across all content types
- **Multiple Themes** - Dark and light mode support

### Technical Features
- **Clean Architecture** - Domain, Data, and Presentation layers
- **State Management** - Riverpod for reactive state management
- **Navigation** - GoRouter for declarative routing
- **Video Playback** - Video player with custom controls
- **Secure Storage** - Credentials stored securely
- **Offline Support** - Cache data for offline browsing

## Project Structure

```
lib/
├── core/
│   ├── constants/       # App constants and API endpoints
│   ├── errors/          # Failure and exception classes
│   ├── network/         # Dio client and interceptors
│   ├── router/          # GoRouter configuration
│   ├── theme/           # App themes and colors
│   ├── usecases/        # Base use case classes
│   ├── utils/           # Utility functions and extensions
│   └── widgets/         # Shared widgets
├── features/
│   ├── auth/            # Authentication feature
│   ├── live/            # Live TV feature
│   ├── vod/             # Movies/VOD feature
│   ├── series/          # TV Series feature
│   ├── player/          # Video player feature
│   ├── favorites/       # Favorites feature
│   ├── continue_watching/ # Watch history feature
│   ├── search/          # Search feature
│   ├── settings/        # Settings feature
│   └── main/            # Main navigation shell
└── main.dart            # App entry point
```

## Getting Started

### Prerequisites
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Android Studio / Xcode for platform-specific setup

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Walid-Khalfa/Streamora.git
cd Streamora
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code (for Riverpod, Freezed, etc.):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

### Configuration

The app requires an IPTV subscription with Xtream Codes API support. You can log in using:
- Server URL + Username + Password
- M3U Playlist URL

## Architecture

This project follows **Clean Architecture** principles with:

- **Domain Layer**: Entities, Repository Interfaces, Use Cases
- **Data Layer**: Repository Implementations, Data Sources, Models
- **Presentation Layer**: UI (Widgets), State Management (Riverpod)

### State Management

Using **Riverpod** for dependency injection and state management:
- `StateNotifier` for complex state
- `FutureProvider`/`StreamProvider` for async data
- `Provider` for simple values and dependencies

### Dependency Injection

Riverpod handles all dependency injection:
```dart
@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
}
```

## Features Breakdown

### Authentication
- Login with Xtream Codes credentials
- M3U URL import with automatic credential extraction
- Secure credential storage using `flutter_secure_storage`
- Session validation

### Live TV
- Category-based browsing
- Channel grid view with logos
- EPG integration
- Current program indicator

### VOD (Movies)
- Movie browsing by category
- Movie details with cast, director, synopsis
- Rating and duration display
- Progress tracking

### Series
- Series browsing by category
- Season and episode listing
- Episode playback with progress tracking

### Player
- Full-screen video playback
- Play/Pause, Seek controls
- Progress tracking for continue watching
- Background audio support

## Dependencies

### State Management
- `flutter_riverpod` - Reactive state management
- `riverpod_annotation` - Code generation for Riverpod

### Networking
- `dio` - HTTP client
- `retrofit` - Type-safe HTTP client

### Storage
- `flutter_secure_storage` - Secure credential storage
- `hive` - Local NoSQL database
- `sqflite` - SQLite database for watch history

### Video
- `video_player` - Video playback
- `chewie` - Video player UI
- `wakelock_plus` - Keep screen on during playback

### Navigation
- `go_router` - Declarative routing

### UI
- `flutter_screenutil` - Responsive UI
- `shimmer` - Loading skeletons
- `cached_network_image` - Image caching

### Utils
- `freezed` - Immutable data classes
- `json_serializable` - JSON serialization
- `dartz` - Functional programming

## Testing

Run tests:
```bash
flutter test
```

Run with coverage:
```bash
flutter test --coverage
```

## Building

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## License

This project is for educational purposes. Users are responsible for complying with their local laws and IPTV provider terms of service.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Acknowledgments

- Flutter Team for the amazing framework
- Xtream Codes for the API specification
- All open-source package authors
