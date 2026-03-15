# Streamora

Premium cross-platform IPTV player built with Flutter. Integrates Xtream API for live TV, VOD, and series streaming. MVP released with modern UI, caching, and Riverpod state management.

## Current Status: MVP Released

The minimum viable product (MVP) is now complete with all core features implemented.

## Features

### Core Features
- **Live TV Streaming** - Watch live TV channels with smooth streaming
- **VOD (Movies)** - Browse and watch on-demand movies
- **TV Series** - Full series support with seasons and episodes
- **EPG (Electronic Program Guide)** - View TV schedules and program information
- **Favorites** - Save and quickly access favorite channels and content
- **Continue Watching** - Resume playback from where you left off

### User Experience
- **Modern UI/UX** - Clean, intuitive interface with dark theme
- **Cross-Platform** - iOS and Android support
- **Responsive Design** - Adapts to different screen sizes
- **Smooth Animations** - Polished transitions and interactions

### Technical
- **Xtream Codes API** - Full integration with Xtream Codes compatible providers
- **M3U Playlist Support** - Import playlists directly (coming soon)
- **Secure Storage** - Encrypted credential storage using Flutter Secure Storage
- **Offline Support** - Network detection and caching for better performance
- **Dio Caching** - HTTP response caching with configurable policies

### New in This Release
- Network connectivity detection with offline banner
- Cached network images for better performance
- Shimmer loading placeholders
- Custom error and loading state widgets
- Pagination support for content lists

## Architecture

This project follows **Clean Architecture** principles with:

```
lib/
├── core/                    # Shared components
│   ├── constants/           # App constants
│   ├── errors/              # Failure classes
│   ├── network/             # API client, network info
│   ├── router/              # Navigation (GoRouter)
│   ├── theme/               # Styling
│   ├── usecases/            # Base use case
│   ├── utils/               # Utilities (pagination)
│   └── widgets/             # Shared widgets (error, loading, images)
│
└── features/                # Feature modules
    ├── auth/                # Authentication
    ├── live/                # Live TV
    ├── vod/                 # Movies
    ├── series/              # TV Series
    ├── player/              # Video player
    ├── favorites/           # Favorites
    ├── continue_watching/   # Watch history
    ├── search/              # Search
    └── settings/            # App settings
```

## Dependencies

- **State Management**: `flutter_riverpod`
- **Navigation**: `go_router`
- **Networking**: `dio`, `retrofit`
- **Local Storage**: `hive`, `sqflite`, `flutter_secure_storage`
- **Video Player**: `video_player`, `chewie`
- **UI**: `cached_network_image`, `shimmer`, `flutter_screenutil`

## Getting Started

### Prerequisites
- Flutter SDK 3.0.0+
- Dart SDK 3.0.0+
- Android Studio / Xcode (for emulators)

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

3. Generate code (if needed):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

### Building for Production

**Android:**
```bash
flutter build apk --release
flutter build appbundle --release
```

**iOS:**
```bash
flutter build ios --release
```

## Configuration

### Xtream Codes API
The app supports Xtream Codes API v1 and v2. To connect:

1. Enter your provider's server URL
2. Provide your username and password
3. The app will authenticate and load your content

### M3U Playlist
You can also import M3U playlists directly for quick access.

## Screenshots

*(Screenshots will be added here)*

## Roadmap

### Completed (MVP)
- [x] Project setup and architecture
- [x] Authentication with Xtream API
- [x] Live TV browsing with categories
- [x] VOD (Movies) browsing
- [x] Series browsing with seasons/episodes
- [x] Video player interface with Chewie
- [x] Favorites management
- [x] Search functionality
- [x] Settings with video quality options
- [x] Network caching (Dio)
- [x] Offline detection
- [x] Secure credential storage

### Future Features
- [ ] EPG (Electronic Program Guide) implementation
- [ ] Continue watching progress sync
- [ ] Picture-in-picture mode
- [ ] Chromecast support
- [ ] Recording functionality
- [ ] M3U playlist import
- [ ] Multiple user profiles

## Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

Streamora is a media player application. Users are responsible for ensuring they have the legal right to access any content through their IPTV provider. The developers do not host or distribute any content.

## Acknowledgments

- Flutter Team for the amazing framework
- Contributors and testers
- IPTV community for API standards
