import 'package:eye_hours/Basics/Favorite.dart';
import 'package:eye_hours/Basics/favorite_manager.dart';
import 'package:eye_hours/temples/main_temples_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TempleDetailScreen extends StatefulWidget {
  final Temple templee;

  const TempleDetailScreen({Key? key, required this.templee}) : super(key: key);

  @override
  _TempleDetailScreenState createState() => _TempleDetailScreenState();
}

class _TempleDetailScreenState extends State<TempleDetailScreen> {
  late bool isFavorite;
  final favoritesManager = FavoritesManager();

  // Add FlutterTts instance
  final FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    isFavorite = favoritesManager.isFavorite(widget.templee.id);

    // Initialize text to speech
    _initTts();
  }

  @override
  void dispose() {
    // Stop speaking when leaving the page
    flutterTts.stop();
    super.dispose();
  }

  // Initialize text to speech
  Future<void> _initTts() async {
    // Set language to English
    await flutterTts.setLanguage("en-US");

    // Set speech rate (0.5 to 2.0)
    await flutterTts.setSpeechRate(0.5);

    // Set volume
    await flutterTts.setVolume(1.0);

    // Listen for completion
    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });
  }

  // Start speaking function
  Future<void> _speak(String text) async {
    if (text.isNotEmpty) {
      setState(() {
        isSpeaking = true;
      });
      await flutterTts.speak(text);
    }
  }

  // Stop speaking function
  Future<void> _stop() async {
    setState(() {
      isSpeaking = false;
    });
    await flutterTts.stop();
  }

  // Toggle between speaking and stopping
  void _toggleSpeak() {
    if (isSpeaking) {
      _stop();
    } else {
      // Speak the full temple description
      _speak(widget.templee.fullDescription);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F5),
      appBar: AppBar(
        title: Text(
          widget.templee.name,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // إضافة زر للنطق في شريط التطبيق
          IconButton(
            icon: Icon(
              isSpeaking ? Icons.volume_off : Icons.volume_up,
              color: Colors.black87,
            ),
            onPressed: _toggleSpeak,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: double.infinity,
            child: Hero(
              tag: 'temple-${widget.templee.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  widget.templee.imagePath,
                  fit: BoxFit.cover,
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
                  widget.templee.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite;
                          if (isFavorite) {
                            favoritesManager.addFavoriteTemple(widget.templee);
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
                            favoritesManager.removeFavorite(widget.templee.id);
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
                    widget.templee.shortDescription,
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.templee.fullDescription,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // إيقاف الصوت عند الضغط على زر إكمال الجولة
                        if (isSpeaking) {
                          _stop();
                        }
                        // استخدام pop للعودة للصفحة السابقة بدلاً من استبدال الصفحة الحالية
                        Navigator.pop(context);
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
      // إضافة زر عائم للنطق
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleSpeak,
        backgroundColor: Color(0xFF5E2B10),
        child: Icon(
          isSpeaking ? Icons.stop : Icons.record_voice_over,
          color: Colors.white,
        ),
        tooltip: isSpeaking ? 'Stop Reading' : 'Read Description',
      ),
    );
  }
}
