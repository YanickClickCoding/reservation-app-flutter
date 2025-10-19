// Modèle de données pour un hôtel

class Hotel {
  final String id;
  final String name;
  final String location;
  final double rating;
  final double price;
  final String imageUrl;
  final List<String> facilities;
  final String description;
  final double distance;
  final bool isFavorite;

  Hotel({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.price,
    required this.imageUrl,
    required this.facilities,
    required this.description,
    this.distance = 0.0,
    this.isFavorite = false,
  });

  // Méthode pour créer une copie avec des valeurs modifiées
  Hotel copyWith({
    String? id,
    String? name,
    String? location,
    double? rating,
    double? price,
    String? imageUrl,
    List<String>? facilities,
    String? description,
    double? distance,
    bool? isFavorite,
  }) {
    return Hotel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      rating: rating ?? this.rating,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      facilities: facilities ?? this.facilities,
      description: description ?? this.description,
      distance: distance ?? this.distance,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
