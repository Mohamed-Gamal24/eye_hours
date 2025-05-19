import 'package:eye_hours/statues/main_statues_page.dart';
import 'package:eye_hours/temples/main_temples_page.dart';

class FavoritesManager {
  // Singleton pattern
  static final FavoritesManager _instance = FavoritesManager._internal();

  factory FavoritesManager() {
    return _instance;
  }

  FavoritesManager._internal();

  // Lists to store favorite statues and temples
  final List<Statue> _favoriteStatues = [];
  final List<Temple> _favoriteTemples = [];

  // Getters for the lists
  List<Statue> get favoriteStatues => List.unmodifiable(_favoriteStatues);
  List<Temple> get favoriteTemples => List.unmodifiable(_favoriteTemples);

  // Combined list of all favorites (as a map with type)
  List<Map<String, dynamic>> get allFavorites {
    List<Map<String, dynamic>> result = [];

    for (var statue in _favoriteStatues) {
      result.add({'id': statue.id, 'item': statue, 'type': 'statue'});
    }

    for (var temple in _favoriteTemples) {
      result.add({'id': temple.id, 'item': temple, 'type': 'temple'});
    }

    return result;
  }

  // Check if an item is in favorites by ID
  bool isFavorite(String id) {
    return _favoriteStatues.any((statue) => statue.id == id) ||
        _favoriteTemples.any((temple) => temple.id == id);
  }

  // Add a statue to favorites
  void addFavorite(Statue statue) {
    if (!_favoriteStatues.any((s) => s.id == statue.id)) {
      _favoriteStatues.add(statue);
    }
  }

  // Add a temple to favorites
  void addFavoriteTemple(Temple temple) {
    if (!_favoriteTemples.any((t) => t.id == temple.id)) {
      _favoriteTemples.add(temple);
    }
  }

  // Remove from favorites (works for both statues and temples)
  void removeFavorite(String id) {
    _favoriteStatues.removeWhere((statue) => statue.id == id);
    _favoriteTemples.removeWhere((temple) => temple.id == id);
  }
}
