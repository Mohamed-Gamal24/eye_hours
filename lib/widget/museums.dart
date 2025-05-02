import 'package:eye_hours/widget/museum_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MuseumTour extends StatelessWidget {
  const MuseumTour({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> museums = [
      {
        'title': 'Grand Egyptian Museum',
        'location': 'Cairo, Giza',
        'image': 'assets/image/IMG-20250416-WA0062.jpg',
        'description':
            'The Grand Egyptian Museum, which began construction in 2002 near the Giza Pyramids, is scheduled to fully open in 2025. It is the world\'s largest archaeological museum dedicated to a single civilization, housing more than 100,000 artifacts. Among its most notable exhibits are the complete collection of King Tutankhamun, displayed for the first time, and colossal statues such as that of Ramses II. The museum also includes a restoration center, educational and recreational areas, and gardens. Its architectural design is inspired by the pyramids, and it is a global cultural landmark that reflects the grandeur of ancient Egypt.',
      },
      {
        'title': 'Egyptian Museum',
        'location': 'Cairo, Tahrir Square',
        'image': 'assets/image/images (6).jpeg',
        'description':
            'The Egyptian Museum in Tahrir Square is the oldest archaeological museum in the Middle East and is located in Cairo\'s Tahrir Square. Construction began in 1897, according to a design by French architect Marcel Dornon, and it was officially inaugurated on November 15, 1902, during the reign of Khedive Abbas Hilmi II. The museum houses more than 160,000 artifacts, including mummies, coffins, and rare pharaonic artifacts. Among its most prominent exhibits are the treasures of Tutankhamun, a statue of Ramses II, and a collection of royal mummies. Although some of the artifacts have been relocated to the Grand Egyptian Museum, the Museum in Tahrir remains a major destination for history and antiquities enthusiasts.',
      },
      {
        'title': 'Museum of Egyptian',
        'location': 'Cairo, Fustat',
        'image': 'assets/image/images.jpeg',
        'description':
            'The Museum of Egyptian Civilization in Fustat, Cairo, began construction in 2002, was partially inaugurated in 2017, and was fully inaugurated on April 3, 2021. It houses more than 50,000 artifacts that chronicle the development of Egyptian civilization from prehistoric times to the modern era. Among its most prominent exhibits is the Royal Mummies Hall, which houses 22 mummies of pharaonic kings and queens. The museum is designed to be a global cultural center that showcases Egyptian heritage in a modern way. It features advanced display technologies and spacious spaces for visitors and researchers.',
      },
      {
        'title': 'Luxor Museum',
        'location': 'Luxor, Nile Corniche',
        'image': 'assets/image/Luxor-Museum-3-1.jpg',
        'description':
            'The Luxor Museum was established and officially opened in 1975 on the east bank of the Nile River in Luxor. The museum houses a distinguished collection of antiquities discovered in Thebes (ancient Luxor) and the surrounding areas. Highlights include magnificent statues from the New Kingdom, pieces from the treasures of Tutankhamun\'s tomb, and a funerary wall from the Karnak Temple. It features elegant displays that emphasize quality over quantity, with simple explanations of each piece. It also houses the Royal Mummies Hall and the Luxor Temple Cache Hall, which was discovered in 1989.',
      },
      {
        'title': 'Mummification Museum',
        'location': 'Luxor, Nile Corniche',
        'image': 'assets/image/images.jpeg',
        'description':
            'The Mummification Museum in Luxor opened in 1997 to showcase the art and techniques of mummification in ancient Egypt. Located on the Nile Corniche near Luxor Temple, the museum houses more than 150 artifacts, including human and animal mummies, embalming tools, and chemicals used in the process. The museum highlights the religious and medical aspects of mummification, displaying texts and funerary rituals. Its dark and serene interior evokes the atmosphere of pharaonic tombs.',
      },
      {
        'title': 'Open Air Museum',
        'location': 'Luxor, Karnak Complex',
        'image': 'assets/image/images (7).jpeg',
        'description':
            'The Mummification Museum in Luxor opened in 1997 to showcase the art and techniques of mummification in ancient Egypt. Located on the Nile Corniche near Luxor Temple, the museum houses more than 150 artifacts, including human and animal mummies, embalming tools, and chemicals used in the process. The museum highlights the religious and medical aspects of mummification, displaying texts and funerary rituals. Its dark and serene interior evokes the atmosphere of pharaonic tombs.',
      },
      {
        'title': 'Nubian Museum',
        'location': 'Aswan, First Sheikhdom',
        'image': 'assets/image/20789431351669239015.jpg',
        'description':
            'The Nubian Museum in Aswan began construction in 1981 and officially opened in 1997. The museum was established in collaboration with UNESCO to document the history and culture of Nubia after its inhabitants were displaced due to the construction of the High Dam. The museum houses more than 3,000 artifacts, showcasing the history of Nubia from prehistoric times to the Islamic era. Prominent exhibits include Pharaonic and Nubian statues, mummies, and everyday objects. The museum features Nubian-inspired architecture and is surrounded by a garden featuring models of traditional Nubian dwellings.',
      },
      {
        'title': 'Tell Basta Museum',
        'location': 'Cairo, Zagazig',
        'image': 'assets/image/images (3).jpeg',
        'description':
            'The Tell Basta Museum in Zagazig, Sharqia Governorate, began construction in 2006, but was halted in 2010. Work resumed in 2017 and was officially opened on March 3, 2018. Located in the Tell Basta archaeological site, the museum houses more than 1,000 artifacts representing the history of Sharqia Governorate throughout the ages, particularly those from excavations at Tell Basta. Prominent exhibits include a statue of Princess Meritamun, daughter of Ramses II, and artifacts associated with Bastet, the goddess of cats. The museum consists of an indoor building and an open exhibition garden and aims to highlight the cultural heritage of the region. It is one of the most important tourist attractions in Sharqia and celebrates its opening anniversary annually.',
      },
      {
        'title': 'Tanta Antiquities Museum',
        'location': 'Cairo, Tanta',
        'image': 'assets/image/images (1).jpeg',
        'description':
            'The Tanta Antiquities Museum was first established in 1913 inside the Tanta Municipality building. It was moved to the Municipal Cinema building in 1957 and reopened in its current location in 1990. Closed for a long period for restoration work, it was officially reopened on September 1, 2019. It houses more than 8,500 artifacts from the Pharaonic, Greek, Roman, Coptic, and Islamic eras. Among its most prominent exhibits are a statue of the architect Imhotep and an icon of the Virgin Mary. It is considered one of the most important regional museums in the Nile Delta.',
      },
      {
        'title': 'Matrouh Antiquities Museum',
        'location': 'Matrouh,Nile Corniche',
        'image': 'assets/image/images (2).jpeg',
        'description':
            'The Matrouh Antiquities Museum was officially opened on March 2, 2018, and is the first comprehensive archaeological museum in Matrouh Governorate. Located within the Misr Public Library in Marsa Matrouh, its construction cost approximately 3.5 million Egyptian pounds. The museum houses more than 1,000 artifacts from the Pharaonic, Roman, Coptic, and Islamic eras, in addition to antiquities from ancient Libya. Prominent exhibits include two small sphinxes and a bust of King Ramses II. The museum aims to showcase the region\'s diverse cultural heritage and shed light on its rich history.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6.0),
          child: Text(
            AppLocalizations.of(context)!.top,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(
          height: 260,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: museums.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MuseumDetailPage(museum: museums[index]),
                    ),
                  );
                },
                child: _buildMuseumCard(museums[index]),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMuseumCard(Map<String, dynamic> museum) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المتحف مع تأثير الضغط
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Stack(
              children: [
                Image.asset(
                  museum['image'],
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: Colors.grey[200],
                    child: Icon(Icons.broken_image, color: Colors.grey[400]),
                  ),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      splashColor: Colors.black.withOpacity(0.1),
                      highlightColor: Colors.transparent,
                      onTap:
                          null, // تم التعامل مع الضغط في GestureDetector الأب
                    ),
                  ),
                ),
              ],
            ),
          ),
          // معلومات المتحف
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اسم المتحف
                  Text(
                    museum['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // موقع المتحف مع الأيقونة
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.deepOrange,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        museum['location'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
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
