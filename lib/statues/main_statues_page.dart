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
      name: 'The Great Sphinx',
      imagePath: 'assets/image/4245d0ee8972cda943ab6ae7cb0c48c9.jpg',
      shortDescription: 'Ancient Egyptian ',
      fullDescription:
          'The Great Sphinx of Giza is a limestone statue of a reclining sphinx, a mythical creature with the head of a human and the body of a lion. Facing directly from west to east, it stands on the Giza Plateau on the west bank of the Nile in Giza, Egypt. The face of the Sphinx is generally believed to represent the pharaoh Khafre. Cut from the bedrock, the original shape of the Sphinx has been restored with layers of blocks. It is the oldest known monumental sculpture in Egypt and is commonly believed to have been designed, sculpted, and constructed by ancient Egyptians of the Old Kingdom during the reign of the pharaoh Khafre (c. 2558–2532 BC).',
    ),
    Statue(
      id: '2',
      name: 'Statue of Libertyyy',
      imagePath: 'assets/image/4245d0ee8972cda943ab6ae7cb0c48c9.jpg',
      shortDescription: 'Iconic copper statue in Ne',
      fullDescription:
          'The Statue of Liberty is a colossal neoclassical sculpture on Liberty Island in New York Harbor within New York City. The copper statue, a gift from the people of France to the people of the United States, was designed by French sculptor Frédéric Auguste Bartholdi and its metal framework was built by Gustave Eiffel. The statue was dedicated on October 28, 1886. The statue is a figure of Libertas, a robed Roman liberty goddess. She holds a torch above her head with her right hand, and in her left hand carries a tabula ansata inscribed JULY IV MDCCLXXVI (July 4, 1776 in Roman numerals), the date of the U.S. Declaration of Independence.',
    ),
    Statue(
      id: '3',
      name: 'Christ the Redeemer',
      imagePath: 'assets/image/4245d0ee8972cda943ab6ae7cb0c48c9.jpg',
      shortDescription: 'Art Deco statue ',
      fullDescription:
          'Christ the Redeemer is an Art Deco statue of Jesus Christ in Rio de Janeiro, Brazil, created by French sculptor Paul Landowski and built by Brazilian engineer Heitor da Silva Costa, in collaboration with French engineer Albert Caquot. Romanian sculptor Gheorghe Leonida fashioned the face. Constructed between 1922 and 1931, the statue is 30 meters tall, excluding its 8-meter pedestal. The arms stretch 28 meters wide. The statue weighs 635 metric tons, and is located at the peak of the 700-meter Corcovado mountain in the Tijuca Forest National Park overlooking the city of Rio de Janeiro.',
    ),
    Statue(
      id: '4',
      name: 'David',
      imagePath: 'assets/image/4245d0ee8972cda943ab6ae7cb0c48c9.jpg',
      shortDescription: 'Renaissance masterpiece',
      fullDescription:
          'David is a masterpiece of Renaissance sculpture created in marble between 1501 and 1504 by the Italian artist Michelangelo. David is a 5.17-meter marble statue of the biblical hero David, a favored subject in the art of Florence. David was originally commissioned as one of a series of statues of prophets to be positioned along the roofline of the east end of Florence Cathedral, but was instead placed in a public square, outside the Palazzo Vecchio, the seat of civic government in Florence, in the Piazza della Signoria, where it was unveiled on 8 September 1504.',
    ),
    Statue(
      id: '5',
      name: 'The Thinker',
      imagePath: 'assets/image/4245d0ee8972cda943ab6ae7cb0c48c9.jpg',
      shortDescription: 'Bronze sculpture ',
      fullDescription:
          'The Thinker is a bronze sculpture by Auguste Rodin, usually placed on a stone pedestal. The work shows a nude male figure of heroic size sitting on a rock with his chin resting on one hand as though deep in thought, often used as an image to represent philosophy. There are about 28 full-sized bronze casts around the world, in which the figure is about 186 cm high, though not all were made during Rodin\'s lifetime and under his supervision. There are various other versions, several in plaster, and studies and posthumous castings exist in a range of sizes.',
    ),
    Statue(
      id: '6',
      name: 'Venus de Milo',
      imagePath: 'assets/image/4245d0ee8972cda943ab6ae7cb0c48c9.jpg',
      shortDescription: 'Ancient Greek sculpture of Aphrodite',
      fullDescription:
          'The Venus de Milo is an ancient Greek statue and one of the most famous works of ancient Greek sculpture. Created between 130 and 100 BC, it is believed to depict Aphrodite, the Greek goddess of love and beauty. It is a marble sculpture, slightly larger than life size at 203 cm high. Its arms and original plinth have been lost. From an inscription that was on its plinth, it is thought to be the work of Alexandros of Antioch. It is currently on permanent display at the Louvre Museum in Paris.',
    ),
    Statue(
      id: '7',
      name: 'Moai',
      imagePath: 'assets/image/4245d0ee8972cda943ab6ae7cb0c48c9.jpg',
      shortDescription: 'Monolithic human ',
      fullDescription:
          'Moai, or mo\'ai, are monolithic human figures carved by the Rapa Nui people on Easter Island in eastern Polynesia between the years 1250 and 1500. Nearly half are still at Rano Raraku, the main moai quarry, but hundreds were transported from there and set on stone platforms called ahu around the island\'s perimeter. Almost all moai have overly large heads three-eighths the size of the whole statue. The moai are chiefly the living faces of deified ancestors. The statues still gazed inland across their clan lands when Europeans first visited the island in 1722, but all of them had fallen by the latter part of the 19th century.',
    ),
    Statue(
      id: '8',
      name: 'The Little Mermaid',
      imagePath: 'assets/image/4245d0ee8972cda943ab6ae7cb0c48c9.jpg',
      shortDescription: 'Bronze statue ',
      fullDescription:
          'The Little Mermaid is a bronze statue by Edvard Eriksen, depicting a mermaid becoming human. The sculpture is displayed on a rock by the waterside at the Langelinie promenade in Copenhagen, Denmark. It is 1.25 metres tall and weighs 175 kg. Based on the fairy tale of the same name by Danish author Hans Christian Andersen, the small and unimposing statue is a Copenhagen icon and has been a major tourist attraction since its unveiling in 1913. In recent decades it has become a popular target for defacement by vandals and political activists.',
    ),
    Statue(
      id: '9',
      name: 'Terracotta Army',
      imagePath: 'assets/image/4245d0ee8972cda943ab6ae7cb0c48c9.jpg',
      shortDescription: 'Collection of terracotta ',
      fullDescription:
          'The Terracotta Army is a collection of terracotta sculptures depicting the armies of Qin Shi Huang, the first Emperor of China. It is a form of funerary art buried with the emperor in 210–209 BCE with the purpose of protecting the emperor in his afterlife. The figures, dating from approximately the late third century BCE, were discovered in 1974 by local farmers in Lintong County, outside Xi\'an, Shaanxi, China. The figures vary in height according to their roles, with the tallest being the generals. The figures include warriors, chariots and horses.',
    ),
    Statue(
      id: '10',
      name: 'The Motherland Calls',
      imagePath: 'assets/image/4245d0ee8972cda943ab6ae7cb0c48c9.jpg',
      shortDescription: 'Commemorative statue in Volgograd',
      fullDescription:
          'The Motherland Calls is a statue in Volgograd, Russia, commemorating the Battle of Stalingrad. It was designed by sculptor Yevgeny Vuchetich and structural engineer Nikolai Nikitin. Declared the tallest statue in the world in 1967, it is the tallest statue in Europe and the tallest statue of a woman in the world. The construction of the monument was started in 1959 and completed in 1967. It is the centerpiece of a memorial complex that includes the ruins of the Battle of Stalingrad, the Eternal Flame and the Hall of Warrior Glory.',
    ),
    Statue(
      id: '11',
      name: 'Statue of Unity',
      imagePath: 'assets/image/4245d0ee8972cda943ab6ae7cb0c48c9.jpg',
      shortDescription: 'World\'s tallest statue l',
      fullDescription:
          'The Statue of Unity is a colossal statue of Indian statesman and independence activist Sardar Vallabhbhai Patel (1875–1950), who was the first Deputy Prime Minister and Home Minister of independent India and an adherent of Mahatma Gandhi. The statue is located in the state of Gujarat, India. It is the world\'s tallest statue with a height of 182 metres (597 feet). It is located on the Narmada River in the Kevadiya colony, facing the Sardar Sarovar Dam 100 kilometres (62 mi) southeast of the city of Vadodara.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
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
          padding: const EdgeInsets.all(12.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
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

  const StatueCard({required this.statue});

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
                  tag: 'statue-${statue.id}',
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(statue.imagePath),
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
                        statue.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        statue.shortDescription,
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
