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
    title: 'The Light of Knowledge',
    subtitle: 'Ideas that illuminate everyday life',
    description:
        'Essays on learning, culture, science, and the enduring habit of wonder.',
    readingMinutes: 42,
    chapters: [
      MagazineChapter(
        kicker: 'Chapter 1',
        title: 'The Light of Knowledge',
        paragraphs: _paragraphs,
      ),
      MagazineChapter(
        kicker: 'Chapter 2',
        title: 'Learning Across Generations',
        paragraphs: _paragraphs,
      ),
      MagazineChapter(
        kicker: 'Chapter 3',
        title: 'The Patient Observer',
        paragraphs: _paragraphs,
      ),
    ],
  ),
  MagazineVolume(
    year: 2026,
    number: 11,
    title: 'Living Traditions',
    subtitle: 'Memory, craft, and community',
    description:
        'Stories about the knowledge held in language, ritual, work, and place.',
    readingMinutes: 36,
    chapters: [
      MagazineChapter(
        kicker: 'Chapter 1',
        title: 'What a Community Remembers',
        paragraphs: _paragraphs,
      ),
      MagazineChapter(
        kicker: 'Chapter 2',
        title: 'Hands That Keep a Craft Alive',
        paragraphs: _paragraphs,
      ),
    ],
  ),
  MagazineVolume(
    year: 2025,
    number: 10,
    title: 'Science and Society',
    subtitle: 'Discovery in the public imagination',
    description:
        'A thoughtful annual collection on evidence, invention, and responsibility.',
    readingMinutes: 48,
    chapters: [
      MagazineChapter(
        kicker: 'Chapter 1',
        title: 'The Courage to Ask',
        paragraphs: _paragraphs,
      ),
      MagazineChapter(
        kicker: 'Chapter 2',
        title: 'Evidence and Empathy',
        paragraphs: _paragraphs,
      ),
    ],
  ),
  MagazineVolume(
    year: 2024,
    number: 9,
    title: 'Earth, Water, Home',
    subtitle: 'Notes on ecology and belonging',
    description:
        'Writers and researchers consider our relationship with the natural world.',
    readingMinutes: 39,
    chapters: [
      MagazineChapter(
        kicker: 'Chapter 1',
        title: 'Reading the Landscape',
        paragraphs: _paragraphs,
      ),
      MagazineChapter(
        kicker: 'Chapter 2',
        title: 'A River Has a Memory',
        paragraphs: _paragraphs,
      ),
    ],
  ),
];
