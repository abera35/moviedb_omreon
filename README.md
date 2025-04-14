# MovieDB Omreon

**MovieDB Omreon** is a modern Flutter application that allows users to browse popular movies, view detailed information, search movies in real-time, and manage favorites—all powered by The Movie Database (TMDB) API.

---

## Features

- **Popular Movies**: Displays a list of trending/popular movies.
- **Movie Details**: View comprehensive information for a selected movie.
- **Search**: Real-time (debounced) search for movies by title.
- **Favorites**: Save and manage your favorite movies locally using `SharedPreferences`.
- **Navigation**: Smooth navigation with `BottomNavigationBar` and `GoRouter`.
- **State Management**: Uses `flutter_bloc` for scalable state handling.
- **Networking**: Built using `Dio` with centralized API client logic.
- **Serialization**: Uses `json_serializable` for model parsing.

---

## Screens

- **Home Page** – Lists popular movies.
- **Search Page** – Enables live search with debounce.
- **Favorites Page** – Displays movies marked as favorites.
- **Movie Detail Page** – Shows detailed info about a selected movie.

---

## Installation

1. **Clone the repository**

```bash
git clone https://github.com/abera35/moviedb_omreon.git
cd moviedb_omreon
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Configure environment**

Create a .env file in the root directory:

```bash
TMDB_BASE_URL=https://api.themoviedb.org/3
TMDB_API_KEY=your_tmdb_api_key_here
```

4. **Run the app**
```bash
flutter run
```

## Project Structure
```bash
lib/
├── core/
│   ├── bloc/             # BLoC and events for movie state
│   ├── constants/        # Constants for application
│   ├── favorites/        # Favorite Cubit and state
│   ├── network/          # Dio API client
│   └── widgets/          # General widgets
├── features/
│   ├── home/             # Home screen UI
│   ├── search/           # Search UI and logic
│   ├── favorites/        # Favorites screen
│   └── detail/           # Movie detail screen
├── models/               # Movie and MovieDetail models
├── services/             # Business logic for movie/favorite operations
└── main.dart             # App entry point with routing
```
## Dependencies

- **flutter_bloc**
- **go_router**
- **dio**
- **json_serializable**
- **shared_preferences**
- **flutter_dotenv** 


Made by *Bera* with Flutter & TMDB API
