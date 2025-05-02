import 'package:eye_hours/Basics/Favorite.dart';
import 'package:eye_hours/Basics/favorite_manager.dart';
import 'package:flutter/material.dart';
import 'package:eye_hours/statues/main_statues_page.dart';
import 'package:eye_hours/statues/main_statues_page.dart';
import 'package:eye_hours/temples/main_temples_page.dart';

class StatueDetailScreen extends StatefulWidget {
  final Statue statue;

  const StatueDetailScreen({required this.statue});

  @override
  _StatueDetailScreenState createState() => _StatueDetailScreenState();
}

class _StatueDetailScreenState extends State<StatueDetailScreen> {
  late bool isFavorite;
  final favoritesManager = FavoritesManager();

  // متغيرات للكتابة التدريجية (للوصف الكامل فقط)
  String displayedFullDesc = '';
  int fullDescIndex = 0;

  @override
  void initState() {
    super.initState();
    isFavorite = favoritesManager.isFavorite(widget.statue.id);

    // بدء تأثير الكتابة للوصف الكامل بعد تأخير بسيط
    Future.delayed(const Duration(milliseconds: 300), () {
      animateFullDescription();
    });
  }

  void animateFullDescription() {
    if (fullDescIndex < widget.statue.fullDescription.length) {
      setState(() {
        displayedFullDesc += widget.statue.fullDescription[fullDescIndex];
        fullDescIndex++;
      });
      Future.delayed(const Duration(milliseconds: 3), () {
        // جعل السرعة أسرع (3ms لكل حرف)
        animateFullDescription();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            child: Hero(
              tag: 'statue-${widget.statue.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  widget.statue.imagePath,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            margin: EdgeInsets.symmetric(horizontal: 16),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget
                      .statue.name, // اسم التمثال يظهر مباشرة بدون تأثير كتابة
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      isFavorite = !isFavorite;
                      if (isFavorite) {
                        favoritesManager.addFavorite(widget.statue);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added to favorites'),
                            duration: Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'VIEW',
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FavoritePage(),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        favoritesManager.removeFavorite(widget.statue.id);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Removed from favorites'),
                          duration: Duration(seconds: 1),
                        ));
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.statue.shortDescription, // الوصف القصير يظهر مباشرة
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    fullDescIndex == 0
                        ? ''
                        : displayedFullDesc, // الوصف الكامل يكتب تدريجياً
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainPageStatues(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF5E2B10),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Complete your Tour',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
