import 'package:eye_hours/Basics/Favorite.dart';
import 'package:eye_hours/Basics/favorite_manager.dart';
import 'package:eye_hours/statues/statues_detail.dart';
import 'package:eye_hours/temples/main_temples_page.dart';
import 'package:eye_hours/temples/temples_detail.dart';
import 'package:flutter/material.dart';
import 'package:eye_hours/statues/main_statues_page.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get favorites from the manager
    final favoritesManager = FavoritesManager();
    final favoriteStatues = favoritesManager.favoriteStatues;
    final favoriteTemples = favoritesManager.favoriteTemples;
    final allFavorites = favoritesManager.allFavorites;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Favorites',
          style: TextStyle(
            fontSize: 26,
          ),
        ),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.black,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Statues'),
            Tab(text: 'Temples'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // All favorites tab
          allFavorites.isEmpty
              ? _buildEmptyFavorites('No favorites yet')
              : _buildAllFavoritesList(allFavorites),

          // Statues tab
          favoriteStatues.isEmpty
              ? _buildEmptyFavorites('No favorite statues yet')
              : _buildStatuesList(favoriteStatues),

          // Temples tab
          favoriteTemples.isEmpty
              ? _buildEmptyFavorites('No favorite temples yet')
              : _buildTemplesList(favoriteTemples),
        ],
      ),
    );
  }

  Widget _buildEmptyFavorites(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.favorite_border,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to your favorites by clicking the heart icon',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllFavoritesList(List<Map<String, dynamic>> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final type = item['type'];

        if (type == 'statue') {
          return _buildStatueCard(item['item'] as Statue);
        } else if (type == 'temple') {
          return _buildTempleCard(item['item'] as Temple);
        }

        return const SizedBox.shrink(); // Fallback
      },
    );
  }

  Widget _buildStatuesList(List<Statue> statues) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: statues.length,
      itemBuilder: (context, index) {
        final statue = statues[index];
        return _buildStatueCard(statue);
      },
    );
  }

  Widget _buildTemplesList(List<Temple> temples) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: temples.length,
      itemBuilder: (context, index) {
        final temple = temples[index];
        return _buildTempleCard(temple);
      },
    );
  }

  Widget _buildStatueCard(Statue statue) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            statue.imagePath,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          statue.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          statue.shortDescription,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () {
            // Remove from favorites
            setState(() {
              FavoritesManager().removeFavorite(statue.id);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Removed from favorites'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
        onTap: () {
          // Navigate to statue details
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StatueDetailScreen(statue: statue),
            ),
          ).then((_) {
            // Refresh the list when returning to this page
            setState(() {});
          });
        },
      ),
    );
  }

  Widget _buildTempleCard(Temple temple) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            temple.imagePath,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          temple.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          temple.shortDescription,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () {
            // Remove from favorites
            setState(() {
              FavoritesManager().removeFavorite(temple.id);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Removed from favorites'),
                duration: Duration(seconds: 1),
              ),
            );
          },
        ),
        onTap: () {
          // Navigate to temple details
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TempleDetailScreen(templee: temple),
            ),
          ).then((_) {
            // Refresh the list when returning to this page
            setState(() {});
          });
        },
      ),
    );
  }
}
