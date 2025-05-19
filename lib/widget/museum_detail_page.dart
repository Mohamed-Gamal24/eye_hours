import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

// صفحة تفاصيل المتحف
class MuseumDetailPage extends StatefulWidget {
  final Map<String, dynamic> museum;

  const MuseumDetailPage({super.key, required this.museum});

  @override
  State<MuseumDetailPage> createState() => _MuseumDetailPageState();
}

class _MuseumDetailPageState extends State<MuseumDetailPage> {
  // إضافة مثيل من FlutterTts
  final FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;

  @override
  void initState() {
    super.initState();
    // تهيئة خاصية النطق
    _initTts();
  }

  @override
  void dispose() {
    // إيقاف الصوت عند الخروج من الصفحة
    flutterTts.stop();
    super.dispose();
  }

  // تهيئة خاصية النطق
  Future<void> _initTts() async {
    // ضبط اللغة إلى الإنجليزية
    await flutterTts.setLanguage("en-US");

    // ضبط سرعة النطق (0.5 إلى 2.0)
    await flutterTts.setSpeechRate(0.5);

    // ضبط مستوى الصوت
    await flutterTts.setVolume(1.0);

    // الاستماع لإكمال النطق
    flutterTts.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          isSpeaking = false;
        });
      }
    });
  }

  // دالة بدء النطق
  Future<void> _speak(String text) async {
    if (text.isNotEmpty && mounted) {
      setState(() {
        isSpeaking = true;
      });
      await flutterTts.speak(text);
    }
  }

  // دالة إيقاف النطق
  Future<void> _stop() async {
    if (mounted) {
      setState(() {
        isSpeaking = false;
      });
    }
    await flutterTts.stop();
  }

  // دالة التبديل بين التشغيل والإيقاف
  void _toggleSpeak() {
    if (isSpeaking) {
      _stop();
    } else {
      // نطق وصف المتحف
      _speak(widget.museum['description']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.museum['title']),
        actions: [
          // زر تشغيل/إيقاف النطق في شريط التطبيق
          IconButton(
            icon: Icon(
              isSpeaking ? Icons.volume_off : Icons.volume_up,
              color: isSpeaking ? Colors.blue : null,
            ),
            onPressed: _toggleSpeak,
            tooltip: isSpeaking ? 'Stop Audio' : 'Play Audio',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المتحف الكبيرة
            Image.asset(
              widget.museum['image'],
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 300,
                color: Colors.grey[200],
                child: Icon(Icons.broken_image, color: Colors.grey[400]),
              ),
            ),
            // معلومات المتحف
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.museum['title'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 20,
                        color: Colors.deepOrange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.museum['location'],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget
                        .museum['description'], // استخدام الوصف المخصص لكل متحف
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // زر عائم للنطق
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleSpeak,
        backgroundColor: Colors.deepOrange,
        tooltip: isSpeaking ? 'Stop Reading' : 'Read Description',
        child: Icon(
          isSpeaking ? Icons.stop : Icons.record_voice_over,
          color: Colors.white,
        ),
      ),
    );
  }
}
