import 'package:flutter/material.dart';

class SanrioCharacter {
  final int id;
  final String name;
  final String description;
  final String imagePath;
  final Color color;
  final List<String> exampleImagePaths;

  SanrioCharacter({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.color,
    this.exampleImagePaths = const [],
  });
}

Map<String, SanrioCharacter> _getLabelToCharacterMap() {
  final map = <String, SanrioCharacter>{};
  for (final char in characters) {
    map[char.name.toLowerCase()] = char;
  }
  return map;
}

SanrioCharacter? getCharacterByLabel(String label) {
  final normalizedLabel = label.toLowerCase().trim();
  
  final labelMap = <String, SanrioCharacter>{};
  for (final char in characters) {
    labelMap[char.name.toLowerCase()] = char;
  }
  
  if (labelMap.containsKey(normalizedLabel)) {
    return labelMap[normalizedLabel];
  }
  
  final mapping = {
    'badtz maru-a': 'Badtz-Maru',
    'badtz-maru': 'Badtz-Maru',
    'chococat': 'Chococat',
  };
  
  if (mapping.containsKey(normalizedLabel)) {
    return labelMap[mapping[normalizedLabel]?.toLowerCase()];
  }
  
  return null;
}

final List<SanrioCharacter> characters = [
  SanrioCharacter(
    id: 0,
    name: 'Hello Kitty',
    description: 'Full Name: Kitty White. Born in London, England, Hello Kitty is the most famous Sanrio character representing kindness, friendship, and happiness. She does not have a mouth to show that emotions can be shared without words. Her closest friends include her twin sister Mimmy (who wears a yellow bow), her boyfriend Dear Daniel, and friends like My Melody and Keroppi.',
    imagePath: 'assets/icons/hello kitty.jpg',
    color: const Color(0xFFFF6B9D),
    exampleImagePaths: const [
      'assets/character_gallery/hello kitty 3.jpg',
      'assets/character_gallery/hello kitty or 1.jpg',
      'assets/character_gallery/hello kitty or 2.jpg',
    ],
  ),
  SanrioCharacter(
    id: 1,
    name: 'Kuromi',
    description: 'First Appearance: 2005. Name derived from "Kuro" meaning black in Japanese. From the magical world, Kuromi looks tough and naughty but actually has a soft and girly side. She likes writing in her diary and reading romance novels. Her rival but also close friend is My Melody, and she has her own gang called Kuromi\'s 5.',
    imagePath: 'assets/icons/kuromi icon.jpg',
    color: const Color(0xFF8B4789),
    exampleImagePaths: const [
      'assets/character_gallery/kuromi 1.jpg',
      'assets/character_gallery/kuromi 2.jpg',
      'assets/character_gallery/kuromi 3.jpg',
    ],
  ),
  SanrioCharacter(
    id: 2,
    name: 'Pompompurin',
    description: 'First Appearance: 1996. A golden retriever dog who is very friendly and loves relaxing. His trademark is his brown beret. Named from the dessert "pudding" (purin) and the sound "pom pom." His closest friends include Muffin the hamster, Scone, and Custard.',
    imagePath: 'assets/icons/pompompurin.jpg',
    color: const Color(0xFFFFD700),
    exampleImagePaths: const [
      'assets/character_gallery/pompompurin 1.jpg',
      'assets/character_gallery/pompompurin 2.jpg',
      'assets/character_gallery/pompompurin3.jpg',
    ],
  ),
  SanrioCharacter(
    id: 3,
    name: 'Keroppi',
    description: 'First Appearance: 1988. Name comes from "kero kero," the Japanese sound a frog makes. From Donut Pond, Keroppi is energetic, cheerful, and loves adventure and sports. His siblings are Pikki and Koroppi, and he has many friends from Donut Pond.',
    imagePath: 'assets/icons/keroppi.jpg',
    color: const Color(0xFF7FBA00),
    exampleImagePaths: const [
      'assets/character_gallery/keroppi 1.jpg',
      'assets/character_gallery/keroppi 2.jpg',
      'assets/character_gallery/keroppi 3.jpg',
    ],
  ),
  SanrioCharacter(
    id: 4,
    name: 'Badtz-Maru',
    description: 'First Appearance: 1993. From Gorgeous Town. A mischievous penguin with an attitude who dreams of becoming rich and famous. His name means "wrong or bad" (Badtz) and "circle or cute ending" (Maru). His closest friends include Hana-Maru the alligator and his pet Pochi.',
    imagePath: 'assets/icons/badtz.jpg',
    color: const Color(0xFF2E5090),
    exampleImagePaths: const [
      'assets/character_gallery/badtz maru 1.jpg',
      'assets/character_gallery/badtz maru 2.jpg',
      'assets/character_gallery/badtz maru 3.jpg',
    ],
  ),
  SanrioCharacter(
    id: 5,
    name: 'Chococat',
    description: 'First Appearance: 1996. Smart, curious, and loves learning new things. Named after chocolate because of his brown nose. From a town full of technology and inventions. His whiskers help him sense information. He often hangs out with Hello Kitty and other characters.',
    imagePath: 'assets/icons/chococat icon.jpg',
    color: const Color(0xFF6B4423),
    exampleImagePaths: const [
      'assets/character_gallery/chococat 1.jpg',
      'assets/character_gallery/chococat 2.jpg',
      'assets/character_gallery/chococat 3.jpg',
    ],
  ),
  SanrioCharacter(
    id: 6,
    name: 'Little Twin Stars',
    description: 'First Appearance: 1975. Twin stars from the Star Cloud in the sky. Kiki (blue hair) is curious and playful, while Lala (pink hair) is gentle and artistic. They are inseparable twins who bring dreams and magic to the universe.',
    imagePath: 'assets/icons/little twin stars.jpg',
    color: const Color(0xFFFF69B4),
    exampleImagePaths: const [
      'assets/character_gallery/little twin stars 1.jpg',
      'assets/character_gallery/little twin stars 2.jpg',
      'assets/character_gallery/little twin stars 3.jpg',
    ],
  ),
  SanrioCharacter(
    id: 7,
    name: 'Pekkle',
    description: 'First Appearance: 1990. A kind-hearted duck from a small town who loves dancing and helping others. His cute-sounding name was inspired by duck sounds. He has a group of animal friends that he cherishes.',
    imagePath: 'assets/icons/pekkle icon 1.jpg',
    color: const Color(0xFFA9D08E),
    exampleImagePaths: const [
      'assets/character_gallery/pekkle 1.jpg',
      'assets/character_gallery/pekkle 2.jpg',
      'assets/character_gallery/pekkle 3.png',
    ],
  ),
  SanrioCharacter(
    id: 8,
    name: 'Tuxedo Sam',
    description: 'First Appearance: 1979. A polite penguin from Antarctica who loves food and collecting bow ties. Named from his signature tuxedo outfit. His best friends are Chip and Dip, and he is known for his refined and gentlemanly demeanor.',
    imagePath: 'assets/icons/tuxedo sam icon.jpg',
    color: const Color(0xFF4472C4),
    exampleImagePaths: const [
      'assets/character_gallery/tuxedosam 1.jpg',
      'assets/character_gallery/tuxedosam 2.jpg',
      'assets/character_gallery/tuxedosam 3.jpg',
    ],
  ),
  SanrioCharacter(
    id: 9,
    name: 'Pochacco',
    description: 'First Appearance: 1989. Athletic and friendly dog who loves sports like soccer. From Fuwafuwa Town, Pochacco is playful with boundless energy. He has many animal friends from his town and brings joy wherever he goes.',
    imagePath: 'assets/icons/pochacco.jpg',
    color: const Color(0xFF70AD47),
    exampleImagePaths: const [
      'assets/character_gallery/pochacco 1.jpg',
      'assets/character_gallery/pochacco 2.jpg',
      'assets/character_gallery/pochacco 3.jpg',
    ],
  ),
];
