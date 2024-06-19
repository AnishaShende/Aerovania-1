class Course {
  final int id;
  final String name;
  final String image;
  final String price;
  final String duration;
  final String session;
  final String review;
  final bool isFavorited;
  final List<String> category;
  final String description;

  Course({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.duration,
    required this.session,
    required this.review,
    required this.isFavorited,
    required this.category,
    required this.description,
  });

  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      name: map['name'],
      image: map['image'],
      price: map['price'],
      duration: map['duration'],
      session: map['session'],
      review: map['review'],
      isFavorited: map['is_favorited'],
      category: List<String>.from(map['category'] ?? []),
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'price': price,
      'duration': duration,
      'session': session,
      'review': review,
      'is_favorited': isFavorited,
      'category': category,
      'description': description,
    };
  }
}
