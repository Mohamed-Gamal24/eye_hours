import 'package:eye_hours/Basics/Favorite.dart';
import 'package:eye_hours/Basics/favorite_manager.dart';
import 'package:flutter/material.dart';
import 'package:eye_hours/statues/main_statues_page.dart';
import 'package:flutter_tts/flutter_tts.dart';

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

  // Add FlutterTts instance
  final FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    isFavorite = favoritesManager.isFavorite(widget.statue.id);

    // بدء تأثير الكتابة للوصف الكامل بعد تأخير بسيط
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        animateFullDescription();
      }
    });

    // Initialize text to speech without auto-playing
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
      if (mounted) {
        setState(() {
          isSpeaking = false;
        });
      }
    });
  }

  // Start speaking function
  Future<void> _speak(String text) async {
    if (text.isNotEmpty && mounted) {
      setState(() {
        isSpeaking = true;
      });
      await flutterTts.speak(text);
    }
  }

  // Stop speaking function
  Future<void> _stop() async {
    if (mounted) {
      setState(() {
        isSpeaking = false;
      });
    }
    await flutterTts.stop();
  }

  // Toggle between speaking and stopping
  void _toggleSpeak() {
    if (isSpeaking) {
      _stop();
    } else {
      // Speak the full statue description
      _speak(widget.statue.fullDescription);
    }
  }

  void animateFullDescription() {
    if (fullDescIndex < widget.statue.fullDescription.length && mounted) {
      setState(() {
        displayedFullDesc += widget.statue.fullDescription[fullDescIndex];
        fullDescIndex++;
      });
      Future.delayed(const Duration(milliseconds: 5), () {
        // جعل السرعة أسرع (3ms لكل حرف)
        if (mounted) {
          animateFullDescription();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F5),
      appBar: AppBar(
        title: Text(
          widget.statue.name,
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
                  widget.statue.name,
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
                    widget.statue.shortDescription,
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
                          fullDescIndex == 0 ? '' : displayedFullDesc,
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
