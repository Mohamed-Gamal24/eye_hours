import 'package:eye_hours/statues/statues_detail.dart';
import 'package:flutter/material.dart';

class Statue {
  final String id;
  final String name;
  final String imagePath;
  final String shortDescription;
  final String fullDescription;

  Statue({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.shortDescription,
    required this.fullDescription,
  });
}

class MainPageStatues extends StatelessWidget {
  // List of 11 famous statues with descriptions
  final List<Statue> statues = [
    Statue(
      id: '1',
      name: 'Colossal Statue of Ramesses',
      imagePath: 'assets/image/images (8).jpeg',
      shortDescription: 'was the third pharaoh of Egypt\'s 19th Dynasty',
      fullDescription:
          'A colossal statue of Ramesses II, carved from a single block of pink granite quarried in Aswan, stands approximately 11 meters tall and weighs around 83 tons. It was originally located in front of the Ramesseum, his mortuary temple in Luxor, and served as a powerful symbol of his divine authority and royal grandeur. The statue portrays the pharaoh in a majestic seated or standing pose, wearing the royal crown and traditional attire, with a calm yet commanding expression.In 2006, one of the most famous replicas was carefully relocated from Ramses Square in Cairo to the Grand Egyptian Museum using advanced engineering techniques.',
    ),
    Statue(
      id: '2',
      name: 'The Great Sphinx',
      imagePath: 'assets/image/2c1ddaf2-60cf-4ad1-88bf-b4157ea3b034.jpg',
      shortDescription: 'combining the body of lion and the head of a human.',
      fullDescription:
          'The Great Sphinx of Giza, carved from limestone, stands near the pyramids and likely represents Pharaoh Khafre. It has a lion\'s body and a human head, symbolizing strength and wisdom. Measuring about 73 meters long and 20 meters high, it faces east toward the sunrise. Believed to guard royal tombs, it is linked to the sun god Ra-Horakhty. The Sphinx has been restored many times and remains a symbol of ancient Egyptian mystery and power',
    ),
    Statue(
      id: '3',
      name: 'King Djoser Statue',
      imagePath: 'assets/image/Djoser1.jpeg',
      shortDescription: 'Was The Third Dynasty of the Old Kingdom',
      fullDescription:
          'King Djoser was the first to build a stone pyramid—the Step Pyramid at Saqqara—with help from architect Imhotep.His painted limestone statue, about 142 cm tall, was found inside the pyramid and now resides in the Egyptian Museum.It shows Djoser seated in royal robes and a wig, with inlaid eyes and hieroglyphs on the throne.The statue is the oldest known stone statue of an Egyptian king, marking a shift from wood to stone in royal art.It was used in religious rituals and linked to the king\'s spirit (Ka) and the concept of immortality.Despite its simplicity, it reflects dignity, stability, and is a milestone in ancient Egyptian sculpture.',
    ),
    Statue(
      id: '4',
      name: 'Colossi of Memnon',
      imagePath: 'assets/image/images (9).jpeg',
      shortDescription: 'representing King Amenhotep III',
      fullDescription:
          'The Colossi of Memnon are two massive statues of Pharaoh Amenhotep III, seated on thrones, located in Luxor\'s west bank.Each statue is about 21 meters tall and weighs over 700 tons, carved from quartz sandstone.They once stood at the entrance of a vast mortuary temple, now mostly ruined.Greek visitors named them "Memnon" after a mythological hero, linking one statue\'s sunrise sounds to legend.The "singing" began after an earthquake in 27 BC and stopped after Roman restoration.Despite erosion and time, they remain iconic symbols of ancient Egyptian grandeur and early tourism.',
    ),
    Statue(
      id: '5',
      name: 'Statue of Hatshepsut',
      imagePath: 'assets/image/images (10).jpeg',
      shortDescription: 'Ruled Egypt during the Eighteenth Dynasty',
      fullDescription:
          'Hatshepsut, titled "Wife of Amun" and "Daughter of Ra," ruled as pharaoh and portrayed herself as a king.Her statues, found mainly at Deir el-Bahari, now reside in museums like the Egyptian Museum and the Met.Made from limestone, granite, or alabaster, the statues were once brightly painted.She appears in male pharaonic attire—kilt, false beard, and crowns—to assert her legitimacy.Statues show her seated on a throne, offering to Amun, or standing at temple gates in colossal form.Despite later attempts to erase her legacy, many statues survived and highlight her power and ingenuity.',
    ),
    Statue(
      id: '6',
      name: 'Queen Nefertiti',
      imagePath: 'assets/image/Nefertiti.jpeg',
      shortDescription: 'She was the wife of King Akhenaten (Amenhotep IV)',
      fullDescription:
          'Queen Nefertiti, who lived in the 14th century BC, was the powerful wife of Pharaoh Akhenaten.She played a major role in the religious shift to worship the sun god Aten and appeared in rituals and battle scenes.Nefertiti may have been the mother of Ankhesenamun and mysteriously disappeared from records.Her famous bust, made by sculptor Thutmose, was found in 1912 in Tell el-Amarna.Now in Berlin\'s Neues Museum, the 48 cm limestone bust is admired for its beauty and artistry.Its removal sparked a lasting controversy, with Egypt demanding its return as a national treasure.',
    ),
    Statue(
      id: '7',
      name: 'Goddess Isis',
      imagePath: 'assets/image/images (14).jpeg',
      shortDescription: 'The Famous Goddesses In Ancient Egyptian',
      fullDescription:
          'Isis was a powerful Egyptian goddess symbolizing motherhood, magic, and protection.She was the wife of Osiris and mother of Horus, often shown nursing him in statues.The statue typically depicts Isis seated with Horus on her lap, sometimes breastfeeding him.She wears a tight dress and a crown shaped like a throne or a sun disk with horns.Made of bronze or stone, these statues served as protective amulets in temples and tombs.The image of Isis with Horus influenced later Christian art, inspiring depictions of Mary and Jesus.',
    ),
    Statue(
      id: '8',
      name: 'King Tutankhamun',
      imagePath: 'assets/image/tutankhamun.jpeg',
      shortDescription: 'young pharaoh who ruled Egypt during the 18th',
      fullDescription:
          'Tutankhamun was a teenage pharaoh of Egypt\'s 18th Dynasty who ruled briefly but became world-famous after his tomb was found in 1922.His golden statue, made of wood and covered in gold with inlaid gems, shows him holding royal symbols with lifelike obsidian eyes.Two black-painted guardian statues stood inside his tomb, representing his Ka and guarding his spirit.The gold in his statues symbolized divinity and eternity, while his poses affirmed royal legitimacy.His statues are rich in spiritual symbolism, including links to death, rebirth, and divine power.Today, his treasures are displayed at the NMEC and will feature prominently at the Grand Egyptian Museum.',
    ),
    Statue(
      id: '9',
      name: 'Queen Cleopatra',
      imagePath: 'assets/image/images (16).jpeg',
      shortDescription: 'Enchanted the World with Her Beauty and Intelligenc',
      fullDescription:
          'Cleopatra, the last queen of the Ptolemaic dynasty, is immortalized in several statues around the world that reflect both her Egyptian and Greek heritage.The most famous is in the British Museum, made of limestone or black granite, combining pharaonic symbolism with Hellenistic style.Another is in Alexandria\'s sunken ruins, believed to be part of an ancient temple, with copies displayed in the modern Library of Alexandria.A Roman-era statue in the Vatican shows Cleopatra with her distinctive hairstyle and a cobra on her forehead.Her statues often include symbols like the cobra, pharaonic crowns, and Isis-like features to emphasize power and divine connection.Sunken statues in Heracleion, including one possibly of Cleopatra, hint at more undiscovered treasures beneath the sea.',
    ),
    Statue(
      id: '10',
      name: 'Pharaoh Thutmose III',
      imagePath: 'assets/image/IMG-20250420-WA0072.jpg',
      shortDescription: 'Pharaohs of the Eighteenth Dynasty',
      fullDescription:
          'Thutmose III, known as the "Napoleon of Ancient Egypt," ruled from 1479–1425 BC and expanded Egypt into a true empire.He co-ruled with Queen Hatshepsut before becoming sole pharaoh and led 17 successful military campaigns, including the famous Battle of Megiddo.Thutmose reformed Egypt\'s army, introduced chariots, and secured wealth through conquest and tribute.He was a great builder, especially at Karnak, where his victories were recorded in inscriptions.His rare gray schist statue shows him powerfully built, wearing a crown with a cobra, standing over the "Nine Bows," symbolizing defeated enemies.Discovered in 1904 at Karnak, the statue reflects his strength, legacy, and historical importance.',
    ),
    Statue(
      id: '11',
      name: 'Amenhotep IV',
      imagePath: 'assets/image/images12.jpg',
      shortDescription: 'Ruled during the Eighteenth Dynasty',
      fullDescription:
          'Akhenaten, originally named Amenhotep IV, ruled from about 1353 to 1336 BC and is known for introducing worship of the sun god Aten.He changed his name to Akhenaten, meaning "beneficial to Aten," and started a major religious and artistic revolution.His sandstone statue, with exaggerated features like a long face, bulging belly, and narrow shoulders, reflects the unique Amarna art style.He ruled with his wife Nefertiti and had six daughters, often depicted in warm family scenes unusual for Egyptian royal art.His reign ended mysteriously, and after his death, Egypt returned to the worship of Amun, erasing his legacy.Akhenaten is remembered as a revolutionary who challenged tradition with early ideas of religious monotheism.',
    ),
  ];

  MainPageStatues({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Statue Gallery',
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
          padding: const EdgeInsets.all(10.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio:
                  0.65, // Changed from 0.7 to 0.65 to make cards taller
            ),
            itemCount: statues.length,
            itemBuilder: (context, index) {
              return StatueCard(statue: statues[index]);
            },
          ),
        ),
      ),
    );
  }
}

class StatueCard extends StatelessWidget {
  final Statue statue;

  const StatueCard({super.key, required this.statue});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StatueDetailScreen(
              statue: statue,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26, // Slightly darker shadow
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6, // Increased from 5 to 6 to make image area larger
                child: Hero(
                  tag: 'statue-${statue.id}',
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(statue.imagePath),
                        fit: BoxFit.cover,
                        alignment: const Alignment(
                            0, -0.9), // Move image down slightly
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
                        statue.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        statue.shortDescription,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          height: 1.5,
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
