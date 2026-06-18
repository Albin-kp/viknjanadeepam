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

  factory MagazineVolume.fromJson(Map<String, dynamic> json) {
    final rawChapters = json['chapters'] as List<dynamic>? ?? const [];
    return MagazineVolume(
      year: (json['year'] as num).toInt(),
      number: (json['number'] as num).toInt(),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      readingMinutes: (json['readingMinutes'] as num?)?.toInt() ?? 30,
      chapters: rawChapters
          .map(
            (chapter) =>
                MagazineChapter.fromJson(chapter as Map<String, dynamic>),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'year': year,
        'number': number,
        'title': title,
        'subtitle': subtitle,
        'description': description,
        'readingMinutes': readingMinutes,
        'chapters': chapters.map((chapter) => chapter.toJson()).toList(),
      };
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

  factory MagazineChapter.fromJson(Map<String, dynamic> json) {
    return MagazineChapter(
      title: json['title'] as String,
      kicker: json['kicker'] as String? ?? 'Chapter',
      paragraphs: (json['paragraphs'] as List<dynamic>? ?? const [])
          .map((paragraph) => paragraph.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'kicker': kicker,
        'paragraphs': paragraphs,
      };
}
