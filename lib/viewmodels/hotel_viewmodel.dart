import 'package:flutter/material.dart';
import '../models/hotel.dart';

class HotelViewModel extends ChangeNotifier {
  List<Hotel> _hotels = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Hotel> get hotels => _hotels;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  HotelViewModel() {
    fetchHotels();
  }

  void fetchHotels() {
    _isLoading = true;
    notifyListeners();

    // Simuler un appel réseau
    Future.delayed(const Duration(milliseconds: 500), () {
      _hotels = [
        Hotel(
          id: '1',
          name: 'Hôtel du Parc',
          location: 'Paris, France',
          rating: 4.8,
          price: 120,
          distance: 1.2,
          imageUrl: 'assets/Images/hotel_1.png',
          facilities: ['Wifi', 'Piscine', 'Spa', 'Petit-déjeuner'],
          description: 'Un hôtel de luxe avec une vue imprenable sur la ville.',
          isFavorite: true,
        ),
        Hotel(
          id: '2',
          name: 'Royal Palace',
          location: 'Lyon, France',
          rating: 4.5,
          price: 95,
          distance: 2.5,
          imageUrl: 'assets/Images/hotel_2.png',
          facilities: ['Wifi', 'Parking', 'Bar', 'Climatisation'],
          description: 'Confort et élégance au cœur de la ville.',
        ),
        Hotel(
          id: '3',
          name: 'Sunset Resort',
          location: 'Nice, France',
          rating: 4.7,
          price: 150,
          distance: 0.8,
          imageUrl: 'assets/Images/hotel_3.png',
          facilities: ['Wifi', 'Piscine', 'Plage privée', 'Restaurant'],
          description: 'Profitez du coucher de soleil sur la Méditerranée.',
        ),
        Hotel(
          id: '4',
          name: 'Mountain View',
          location: 'Chamonix, France',
          rating: 4.9,
          price: 180,
          distance: 3.2,
          imageUrl: 'assets/Images/hotel_4.png',
          facilities: ['Wifi', 'Spa', 'Restaurant', 'Vue sur les montagnes'],
          description: 'Un havre de paix au pied des montagnes enneigées.',
        ),
        Hotel(
          id: '5',
          name: 'Hôtel de la Plage',
          location: 'Cannes, France',
          rating: 4.6,
          price: 110,
          distance: 2.8,
          imageUrl: 'assets/Images/hotel_5.png',
          facilities: ['Wifi', 'Piscine', 'Plage privée', 'Restaurant'],
          description: 'Un hôtel de charme avec une vue sur la mer.',
        ),
      ];
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    });
  }

  void toggleFavorite(String hotelId) {
    final index = _hotels.indexWhere((hotel) => hotel.id == hotelId);
    if (index != -1) {
      _hotels[index] = _hotels[index].copyWith(
        isFavorite: !_hotels[index].isFavorite,
      );
      notifyListeners();
    }
  }
}
