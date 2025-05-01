import 'package:eye_hours/temples/temples_detail.dart';
import 'package:flutter/material.dart';

class Temple {
  final String id;
  final String name;
  final String imagePath;
  final String shortDescription;
  final String fullDescription;

  Temple({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.shortDescription,
    required this.fullDescription,
  });
}

class MainPageTemples extends StatelessWidget {
  // List of 11 famous temples with descriptions
  final List<Temple> temples = [
    Temple(
      id: '1',
      name: 'Karnak Temple',
      imagePath: 'assets/image/4245d0ee8972cda943ab6ae7cb0c48c9.jpg',
      shortDescription: 'Massive ancient Egyptian temple complex',
      fullDescription:
          'The Karnak Temple Complex is the largest religious ancient site in the world. Located in Luxor, Egypt, it was built over 2000 years and dedicated to the Theban Triad of Amun, Mut, and Khonsu. The complex features massive pylons, obelisks, and the famous Great Hypostyle Hall with its 134 massive columns.',
    ),
    Temple(
      id: '2',
      name: 'Angkor Wat',
      imagePath: 'assets/image/4245d0ee8972cda943ab6ae7cb0c48c9.jpg',
      shortDescription: 'World\'s largest religious monument',
      fullDescription:
          'Angkor Wat in Cambodia is the largest religious monument in the world, covering 162.6 hectares. Originally constructed as a Hindu temple dedicated to Vishnu in the 12th century, it gradually transformed into a Buddhist temple. The temple is famous for its lotus bud-shaped towers and exquisite bas-reliefs.',
    ),
    Temple(
      id: '3',
      name: 'Parthenon',
      imagePath: 'assets/image/4245d0ee8972cda943ab6ae7cb0c48c9.jpg',
      shortDescription: 'Iconic Greek temple',
      fullDescription:
          'The Parthenon is a former temple on the Athenian Acropolis, Greece, dedicated to the goddess Athena. Constructed in the 5th century BCE, it\'s the most important surviving building of Classical Greece and an enduring symbol of Ancient Greek civilization and Western democracy.',
    ),
    Temple(
      id: '4',
      name: 'Borobudur',
      imagePath: 'assets/image/4245d0ee8972cda943ab6ae7cb0c48c9.jpg',
      shortDescription: 'Largest Buddhist temple',
      fullDescription:
          'Borobudur is a 9th-century Mahayana Buddhist temple in Magelang, Indonesia. The temple consists of nine stacked platforms, decorated with 2,672 relief panels and 504 Buddha statues. The central dome is surrounded by 72 Buddha statues, each seated inside a perforated stupa.',
    ),
    Temple(
      id: '5',
      name: 'Golden Temple',
      imagePath: 'assets/image/4245d0ee8972cda943ab6ae7cb0c48c9.jpg',
      shortDescription: 'Sikhism\'s holiest shrine',
      fullDescription:
          'The Golden Temple (Harmandir Sahib) is the holiest Gurdwara of Sikhism, located in Amritsar, India. The temple is known for its stunning golden dome and the sacred pool (Amrit Sarovar) that surrounds it. The temple complex feeds over 100,000 people daily through its langar (community kitchen).',
    ),
    Temple(
      id: '6',
      name: 'Lotus Temple',
      imagePath: 'assets/image/4245d0ee8972cda943ab6ae7cb0c48c9.jpg',
      shortDescription: 'Baháʼí House of Worship',
      fullDescription:
          'The Lotus Temple in Delhi, India is a Baháʼí House of Worship notable for its flowerlike shape. The temple is composed of 27 free-standing marble-clad "petals" arranged in clusters of three to form nine sides. Since its opening in 1986, it has become one of Delhi\'s most visited buildings.',
    ),
    Temple(
      id: '7',
      name: 'Abu Simbel',
      imagePath: 'assets/image/4245d0ee8972cda943ab6ae7cb0c48c9.jpg',
      shortDescription: 'Rock-cut temples of Ramses II',
      fullDescription:
          'The Abu Simbel temples are two massive rock temples in southern Egypt built by Pharaoh Ramses II in the 13th century BCE. The complex was relocated in 1968 to avoid being submerged during the creation of Lake Nasser. The temple is famous for its alignment with the sun during solstices.',
    ),
    Temple(
      id: '8',
      name: 'Tōdai-ji',
      imagePath: 'assets/image/4245d0ee8972cda943ab6ae7cb0c48c9.jpg',
      shortDescription: 'Great Eastern Temple',
      fullDescription:
          'Tōdai-ji is a Buddhist temple complex in Nara, Japan that houses the world\'s largest bronze statue of the Buddha Vairocana. The main hall (Daibutsuden) is the world\'s largest wooden building, despite being only two-thirds the size of the original structure. The temple serves as the Japanese headquarters of the Kegon school of Buddhism.',
    ),
    Temple(
      id: '9',
      name: 'Vishakha Temple',
      imagePath: 'assets/image/4245d0ee8972cda943ab6ae7cb0c48c9.jpg',
      shortDescription: 'Ancient Hindu temple',
      fullDescription:
          'The Vishakha Temple in Pushkar, India is dedicated to the Hindu goddess Vishakha. The temple features intricate carvings and colorful architecture. Pilgrims visit the temple to bathe in the sacred Pushkar Lake and perform religious rituals during special festivals.',
    ),
    Temple(
      id: '10',
      name: 'Temple of Kukulcan',
      imagePath: 'assets/image/4245d0ee8972cda943ab6ae7cb0c48c9.jpg',
      shortDescription: 'Mayan step pyramid',
      fullDescription:
          'The Temple of Kukulcan at Chichen Itza, Mexico is a Mesoamerican step-pyramid that dominates the archaeological site. The temple exhibits precise astronomical alignment where the setting sun during equinoxes creates shadows that resemble a serpent descending the pyramid.',
    ),
    Temple(
      id: '11',
      name: 'Shwedagon Pagoda',
      imagePath: 'assets/image/4245d0ee8972cda943ab6ae7cb0c48c9.jpg',
      shortDescription: 'Golden Buddhist stupa',
      fullDescription:
          'The Shwedagon Pagoda in Yangon, Myanmar is a 99-meter gilded stupa plated with gold and encrusted with thousands of diamonds. According to legend, it contains relics of four Buddhas. The pagoda is the most sacred Buddhist site in Myanmar and a major pilgrimage destination.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Temples Gallery',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepOrange.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemCount: temples.length,
            itemBuilder: (context, index) {
              return TempleCard(temple: temples[index]);
            },
          ),
        ),
      ),
    );
  }
}

class TempleCard extends StatelessWidget {
  final Temple temple;

  const TempleCard({required this.temple});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TempleDetailScreen(
              templee: temple,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Hero(
                  tag: 'temple-${temple.id}',
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(temple.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        temple.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        temple.shortDescription,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          height: 1.3,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
