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
      imagePath: 'assets/image/karnak.jpeg',
      shortDescription: 'The Greatest Religious Complex of Ancient Egypt',
      fullDescription:
          'Karnak Temple is one of the greatest religious complexes of ancient Egypt, built and expanded over 2,000 years. Construction began in the Middle Kingdom, with major contributions from New Kingdom pharaohs like Thutmose III, Hatshepsut, and Ramses II. The temple includes impressive features such as the First Pylon, Avenue of Sphinxes, the Great Hypostyle Hall with 134 towering columns, and the Sacred Lake. Obelisks, including one by Queen Hatshepsut, still stand today. It was the main center of worship for Amun-Ra and held immense religious and political power.',
    ),
    Temple(
        id: '2',
        name: 'Luxor Temple',
        imagePath: 'assets/image/luxor temple.jpeg',
        shortDescription: 'Luxor Temple was begun by Amenhotep III',
        fullDescription:
            'Luxor Temple was begun by Amenhotep III and completed by Ramses II, dedicated to the Theban Triad: Amun, Mut, and Khonsu. It\'s famous for its grand statues, towering columns, and obelisks—one of which now stands in Paris. The temple uniquely includes the Mosque of Abu Haggag, blending ancient Egyptian and Islamic architecture. It was the central site of the Opet Festival, where gods\' statues were paraded from Karnak Temple. A highlight is its connection to Karnak via the Avenue of Sphinxes.'),
    Temple(
      id: '3',
      name: 'Hatshepsut Temple',
      imagePath: 'assets/image/Hatshepsut Temple.jpeg',
      shortDescription: 'built during Queen Hatshepsut’s reign',
      fullDescription:
          'Hatshepsut Temple, built during Queen Hatshepsut’s reign, is a stunning monument at Deir el-Bahari near the Valley of the Kings. Designed by her architect Senenmut, it honors Amun-Ra and celebrates Hatshepsut’s divine birth and achievements. The temple features a unique three-tiered design with terraces and columns that blend into the cliffs. Its walls depict the famous expedition to the Land of Punt, showcasing ships, exotic goods, and incense trees. This mountain-carved masterpiece stands out as one of ancient Egypt’s most remarkable architectural feats.',
    ),
    Temple(
      id: '4',
      name: 'Abu Simbel Temple',
      imagePath: 'assets/image/Abu Simbel Temple.jpeg',
      shortDescription: 'one of the most famous Pharaonic temples in Egypt',
      fullDescription:
          'Abu Simbel Temple, built by Ramses II around 1264 BC, was intended to celebrate his military victories and divine status. It consists of two temples: the Great Temple with four colossal statues of Ramses, and the Small Temple dedicated to Queen Nefertari. The site honors gods like Amun-Ra, Ra-Horakhty, and Ptah. A remarkable solar alignment lights up Ramses’ statue inside the sanctuary twice a year. In the 1960s, the entire complex was relocated to save it from flooding, a massive UNESCO-led effort that preserved this iconic monument.',
    ),
    Temple(
      id: '5',
      name: 'Edfu Temple',
      imagePath: 'assets/image/Edfu Temple.jpeg',
      shortDescription: 'one of Egypt’s best-preserved temples',
      fullDescription:
          'Edfu Temple, built during the Ptolemaic period (237–57 BC), is dedicated to Horus, the sky and protection god. Located on the Nile’s west bank in Edfu, it\'s one of Egypt’s best-preserved temples. Its architecture includes a towering pylon, hypostyle hall, courtyard, and sanctuary. The temple walls depict the mythological battle between Horus and Seth. It reflects traditional Egyptian design blended with Ptolemaic elements, showcasing intricate carvings and exceptional construction.',
    ),
    Temple(
      id: '6',
      name: 'Ramesseum Temple',
      imagePath: 'assets/image/Ramesseum Temple.jpeg',
      shortDescription: 'built by Ramses II in the 13th century BC',
      fullDescription:
          'The Ramesseum, built by Ramses II in the 13th century BC, served as his mortuary temple to honor him after death and ensure his eternal life. Located on Luxor’s west bank, it featured massive pylons, courtyards, a hypostyle hall, and once held a colossal statue of Ramses over 17 meters tall. The temple’s walls display scenes from the Battle of Kadesh and religious rituals. Though partly ruined, it remains a stunning example of New Kingdom architecture. The name "Ramesseum" was later given by the Greeks who admired its grandeur.',
    ),
    Temple(
      id: '7',
      name: 'Dendera Temple',
      imagePath: 'assets/image/Dendera Temple.jpeg',
      shortDescription: ' Built during the Ptolemaic and Roman periods',
      fullDescription:
          'Dendera Temple, located north of Luxor, is dedicated to Hathor, the goddess of love, music, and motherhood. Built during the Ptolemaic and Roman periods, the site itself was sacred since the Old Kingdom. The temple features a grand entrance, decorated columns, crypts, rooftop chambers, and a well-preserved roof. Its walls depict rituals, festivals, and astronomical scenes, including the famous Dendera Zodiac. As one of the best-preserved temples in Egypt, it provides rich insight into late-period religious art and architecture.',
    ),
    Temple(
      id: '8',
      name: 'Kom Ombo Temple',
      imagePath: 'assets/image/Kom Ombo Temple.jpeg',
      shortDescription: 'built during the Ptolemaic period',
      fullDescription:
          'Kom Ombo Temple, built during the Ptolemaic period and expanded in the Roman era, is a unique double temple dedicated to Sobek and Horus the Elder. Its symmetrical design includes twin entrances, halls, and sanctuaries for each god. The temple’s walls depict rituals, medical tools, and religious scenes. It represents the duality of good and evil, with Horus symbolizing good and Sobek power and fear. Nearby, the Crocodile Museum houses mummified crocodiles. Despite damage over time, much of the temple remains remarkably intact.',
    ),
    Temple(
      id: '9',
      name: 'Philae Temple',
      imagePath: 'assets/image/Philae Temple.jpeg',
      shortDescription: 'Was dedicated to the goddess Isis',
      fullDescription:
          'Philae Temple, built mainly during the Ptolemaic period, was dedicated to the goddess Isis, a major deity of magic, healing, and motherhood. It features elegant architecture, including colonnades, pylons, and the famous Trajan’s Kiosk. Originally on Philae Island, the temple was relocated to Agilkia Island in the 1960s due to flooding from the Aswan High Dam. Worship at the site continued into the 6th century AD, making it one of the last active centers of ancient Egyptian religion. Today, it remains a popular destination with sound-and-light shows bringing its history to life.',
    ),
    Temple(
      id: '10',
      name: 'Seti I Temple',
      imagePath: 'assets/image/Seti I Temple.jpeg',
      shortDescription: 'built by Seti I and completed by Ramses II',
      fullDescription:
          'The Temple of Seti I in Abydos, built by Seti I and completed by Ramses II, is dedicated to Osiris and serves as a memorial to Seti I. It has a rare L-shaped design with seven sanctuaries for various gods, including Seti himself. The temple is renowned for its exquisite reliefs and houses the Abydos King List, a vital record of pharaonic succession. Abydos was a major pilgrimage site, believed to be the burial place of Osiris. Despite its age, the temple remains well-preserved, especially in its inner chambers.',
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
