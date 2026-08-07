enum MealSection { breakfast, lunch, dinner }

extension MealSectionLabel on MealSection {
  String get label => switch (this) {
    MealSection.breakfast => 'Breakfast',
    MealSection.lunch => 'Lunch',
    MealSection.dinner => 'Dinner',
  };
}

class Dish {
  const Dish({
    required this.id,
    required this.imagePath,
    required this.name,
    required this.restaurant,
    required this.description,
    required this.mealSection,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id, imagePath, name, restaurant, description;
  final MealSection mealSection;
  final DateTime createdAt, updatedAt;

  Dish copyWith({
    String? imagePath,
    String? name,
    String? restaurant,
    String? description,
    MealSection? mealSection,
    DateTime? updatedAt,
  }) => Dish(
    id: id,
    imagePath: imagePath ?? this.imagePath,
    name: name ?? this.name,
    restaurant: restaurant ?? this.restaurant,
    description: description ?? this.description,
    mealSection: mealSection ?? this.mealSection,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'imagePath': imagePath,
    'name': name,
    'restaurant': restaurant,
    'description': description,
    'mealSection': mealSection.name,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Dish.fromJson(Map<String, Object?> json) => Dish(
    id: json['id']! as String,
    imagePath: json['imagePath']! as String,
    name: json['name']! as String,
    restaurant: json['restaurant']! as String,
    description: json['description']! as String,
    mealSection: MealSection.values.byName(json['mealSection']! as String),
    createdAt: DateTime.parse(json['createdAt']! as String),
    updatedAt: DateTime.parse(json['updatedAt']! as String),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Dish &&
          id == other.id &&
          imagePath == other.imagePath &&
          name == other.name &&
          restaurant == other.restaurant &&
          description == other.description &&
          mealSection == other.mealSection &&
          createdAt == other.createdAt &&
          updatedAt == other.updatedAt;
  @override
  int get hashCode => Object.hash(
    id,
    imagePath,
    name,
    restaurant,
    description,
    mealSection,
    createdAt,
    updatedAt,
  );
}
