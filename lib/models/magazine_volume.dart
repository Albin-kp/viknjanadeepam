class MagazineVolume {
  const MagazineVolume({
    required this.year,
    required this.number,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.readingMinutes,
    required this.chapters,
  });

  final int year;
  final int number;
  final String title;
  final String subtitle;
  final String description;
  final int readingMinutes;
  final List<MagazineChapter> chapters;
}

class MagazineChapter {
  const MagazineChapter({
    required this.title,
    required this.kicker,
    required this.paragraphs,
  });

  final String title;
  final String kicker;
  final List<String> paragraphs;
}
