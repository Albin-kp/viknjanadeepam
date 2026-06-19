class MagazineVolume {
  const MagazineVolume({
    this.id,
    required this.year,
    required this.number,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.readingMinutes,
    required this.chapters,
    this.published = false,
    this.updatedAt,
  });

  final String? id;
  final int year;
  final int number;
  final String title;
  final String subtitle;
  final String description;
  final int readingMinutes;
  final List<MagazineChapter> chapters;
  final bool published;
  final DateTime? updatedAt;

  factory MagazineVolume.fromJson(Map<String, dynamic> json) {
    final rawChapters = json['chapters'] as List<dynamic>? ?? const [];
    return MagazineVolume(
      id: json['id'] as String?,
      year: (json['year'] as num).toInt(),
      number: ((json['volume_number'] ?? json['number']) as num).toInt(),
      title: json['title'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      readingMinutes:
          ((json['reading_minutes'] ?? json['readingMinutes']) as num?)
                  ?.toInt() ??
              30,
      chapters: rawChapters
          .map(
            (chapter) =>
                MagazineChapter.fromJson(chapter as Map<String, dynamic>),
          )
          .toList(),
      published: json['published'] as bool? ?? false,
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.tryParse(json['updated_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'year': year,
        'volume_number': number,
        'title': title,
        'subtitle': subtitle,
        'description': description,
        'reading_minutes': readingMinutes,
        'chapters': chapters.map((chapter) => chapter.toJson()).toList(),
        'published': published,
      };

  MagazineVolume copyWith({
    String? id,
    int? year,
    int? number,
    String? title,
    String? subtitle,
    String? description,
    int? readingMinutes,
    List<MagazineChapter>? chapters,
    bool? published,
    DateTime? updatedAt,
  }) {
    return MagazineVolume(
      id: id ?? this.id,
      year: year ?? this.year,
      number: number ?? this.number,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      readingMinutes: readingMinutes ?? this.readingMinutes,
      chapters: chapters ?? this.chapters,
      published: published ?? this.published,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
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
