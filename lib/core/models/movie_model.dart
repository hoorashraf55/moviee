class MovieCast {
  final String name;
  final String characterName;
  final String imageUrl;

  MovieCast({
    required this.name,
    required this.characterName,
    required this.imageUrl,
  });

  factory MovieCast.fromJson(Map<String, dynamic> json) {
    return MovieCast(
      name: json['name']?.toString() ?? '',
      characterName: json['character_name']?.toString() ?? '',
      imageUrl: json['url_small_image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'character_name': characterName,
      'url_small_image': imageUrl,
    };
  }
}

class MovieModel {
  final int id;
  final String title;
  final int year;
  final double rating;
  final int runtime;
  final int likeCount;
  final String summary;
  final String mediumCoverImage;
  final String largeCoverImage;
  final List<String> genres;
  final String? backgroundImage;
  final String? screenshot1;
  final String? screenshot2;
  final String? screenshot3;
  final List<MovieCast> cast;

  MovieModel({
    required this.id,
    required this.title,
    required this.year,
    required this.rating,
    required this.runtime,
    required this.likeCount,
    required this.summary,
    required this.mediumCoverImage,
    required this.largeCoverImage,
    required this.genres,
    this.backgroundImage,
    this.screenshot1,
    this.screenshot2,
    this.screenshot3,
    this.cast = const [],
  });

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }

  static String _toString(dynamic value) {
    return value?.toString() ?? '';
  }

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    final genresData = json['genres'];
    final castData = json['cast'];

    return MovieModel(
      id: _toInt(json['id']),
      title: _toString(json['title']),
      year: _toInt(json['year']),
      rating: _toDouble(json['rating']),
      runtime: _toInt(json['runtime']),
      likeCount: _toInt(json['like_count'] ?? json['likeCount']),
      summary: _toString(
        json['summary'] ?? json['description_full'],
      ),
      mediumCoverImage: _toString(
        json['medium_cover_image'] ?? json['mediumCoverImage'],
      ),
      largeCoverImage: _toString(
        json['large_cover_image'] ??
            json['largeCoverImage'] ??
            json['medium_cover_image'] ??
            json['mediumCoverImage'],
      ),
      genres: genresData is List
          ? genresData.map((genre) => genre.toString()).toList()
          : [],
      backgroundImage: json['background_image_original'] ??
          json['backgroundImage'],
      screenshot1: json['large_screenshot_image1'] ??
          json['screenshot1'],
      screenshot2: json['large_screenshot_image2'] ??
          json['screenshot2'],
      screenshot3: json['large_screenshot_image3'] ??
          json['screenshot3'],
      cast: castData is List
          ? castData
          .whereType<Map<String, dynamic>>()
          .map((actor) => MovieCast.fromJson(actor))
          .toList()
          : [],
    );
  }

  factory MovieModel.fromMap(Map<String, dynamic> map) {
    return MovieModel.fromJson(map);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'rating': rating,
      'runtime': runtime,
      'likeCount': likeCount,
      'summary': summary,
      'mediumCoverImage': mediumCoverImage,
      'largeCoverImage': largeCoverImage,
      'genres': genres,
      'backgroundImage': backgroundImage,
      'screenshot1': screenshot1,
      'screenshot2': screenshot2,
      'screenshot3': screenshot3,
      'cast': cast.map((actor) => actor.toMap()).toList(),
    };
  }
}