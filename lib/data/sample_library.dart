import '../models/magazine_volume.dart';

const _paragraphs = [
  'Knowledge is not merely a collection of facts. It is a lamp carried from one generation to the next, becoming brighter whenever curiosity is joined with compassion.',
  'The pages of this annual volume gather reflections from teachers, researchers, writers, and careful observers of everyday life. Each essay begins with a question and invites the reader to pause before reaching for an answer.',
  'In a noisy age, attentive reading is itself a quiet discipline. It asks us to remain with an idea long enough for it to reveal its edges, its history, and the new paths hidden within it.',
  'May this digital edition preserve the intimacy of the printed page while making the archive easier to explore. The journey continues whenever a reader opens an old volume and finds a thought that still feels new.',
];

const sampleLibrary = [
  MagazineVolume(
    year: 2026,
    number: 12,
    title: 'Apostolic Roots',
    subtitle: 'The beginnings of the Jacobite Syrian Christian tradition',
    description:
        'Historical reflections on apostolic memory, early communities, and the roots of faith in Malankara.',
    readingMinutes: 42,
    category: 'Sabhacharithram',
    coverColorHex: '#9B2C2C',
    chapters: [
      MagazineChapter(
        kicker: 'Chapter 1',
        title: 'The Apostolic Inheritance',
        paragraphs: _paragraphs,
      ),
      MagazineChapter(
        kicker: 'Chapter 2',
        title: 'From Antioch to Malankara',
        paragraphs: _paragraphs,
      ),
      MagazineChapter(
        kicker: 'Chapter 3',
        title: 'A Living Tradition',
        paragraphs: _paragraphs,
      ),
    ],
  ),
  MagazineVolume(
    year: 2026,
    number: 11,
    title: 'The Syriac Heritage',
    subtitle: 'Language, liturgy, manuscripts, and sacred memory',
    description:
        'An introduction to West Syriac worship, literature, music, and the spiritual vocabulary of the Church.',
    readingMinutes: 36,
    category: 'Kurbana',
    coverColorHex: '#276749',
    chapters: [
      MagazineChapter(
        kicker: 'Chapter 1',
        title: 'The Language of Prayer',
        paragraphs: _paragraphs,
      ),
      MagazineChapter(
        kicker: 'Chapter 2',
        title: 'Manuscripts and Memory',
        paragraphs: _paragraphs,
      ),
    ],
  ),
  MagazineVolume(
    year: 2025,
    number: 10,
    title: 'Churches of Malankara',
    subtitle: 'Sacred places and the communities that shaped them',
    description:
        'A historical journey through churches, stone crosses, architecture, and parish life in Kerala.',
    readingMinutes: 48,
    category: 'Sabhacharithram',
    coverColorHex: '#9B2C2C',
    chapters: [
      MagazineChapter(
        kicker: 'Chapter 1',
        title: 'Houses of Worship',
        paragraphs: _paragraphs,
      ),
      MagazineChapter(
        kicker: 'Chapter 2',
        title: 'Parishes Through Time',
        paragraphs: _paragraphs,
      ),
    ],
  ),
  MagazineVolume(
    year: 2024,
    number: 9,
    title: 'Faith Through the Centuries',
    subtitle: 'Witness, leadership, and community across generations',
    description:
        'Stories of endurance, ecclesial leadership, migration, education, and service across the centuries.',
    readingMinutes: 39,
    category: 'Faith Formation',
    coverColorHex: '#2B6CB0',
    chapters: [
      MagazineChapter(
        kicker: 'Chapter 1',
        title: 'A History of Witness',
        paragraphs: _paragraphs,
      ),
      MagazineChapter(
        kicker: 'Chapter 2',
        title: 'Faith in a Changing World',
        paragraphs: _paragraphs,
      ),
    ],
  ),
];
