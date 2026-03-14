# Streamora

Streamora is a premium cross-platform IPTV player app built with Flutter, featuring Xtream API integration for live TV, VOD (Video on Demand), and TV series streaming.

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
- **M3U Playlist Support** - Import playlists directly
- **Secure Storage** - Encrypted credential storage
- **Offline Support** - Cache management for better performance

## Architecture

This project follows **Clean Architecture** principles with:

```
lib/
├── core/                    # Shared components
│   ├── constants/           # App constants
│   ├── errors/              # Failure classes
│   ├── network/             # API client
│   ├── router/              # Navigation
│   ├── theme/               # Styling
│   ├── usecases/            # Base use case
│   ├── utils/               # Utilities
│   └── widgets/             # Shared widgets
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

- [x] Project setup and architecture
- [x] Authentication with Xtream API
- [x] Live TV browsing
- [x] VOD (Movies) browsing
- [x] Series browsing
- [x] Video player interface
- [x] Favorites
- [x] Search
- [x] Settings
- [ ] EPG implementation
- [ ] Continue watching
- [ ] Picture-in-picture
- [ ] Chromecast support
- [ ] Recording functionality

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
