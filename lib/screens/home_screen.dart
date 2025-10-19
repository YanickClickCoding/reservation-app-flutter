import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/hotel.dart';
import '../viewmodels/hotel_viewmodel.dart';
import '../widgets/hotel_card.dart';
import '../constants/app_colors.dart';

// Options de tri
enum SortOption { none, rating, priceAsc, priceDesc }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  SortOption _sortOption = SortOption.none;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  DateTime? _lastPressedAt; // Pour le double appui

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<Hotel> _getFilteredAndSortedHotels(HotelViewModel viewModel) {
    List<Hotel> hotels = List.from(viewModel.hotels);

    // 1. Filtrage par recherche
    if (_searchQuery.isNotEmpty) {
      hotels = hotels
          .where((hotel) =>
              hotel.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // 2. Tri
    switch (_sortOption) {
      case SortOption.rating:
        hotels.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case SortOption.priceAsc:
        hotels.sort((a, b) => a.price.compareTo(b.price));
        break;
      case SortOption.priceDesc:
        hotels.sort((a, b) => b.price.compareTo(a.price));
        break;
      case SortOption.none:
        break;
    }

    return hotels;
  }

  // AppBar par défaut
  AppBar _buildDefaultAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true, // Centrer le titre
      title: Text(
        'Explore',
        style: GoogleFonts.nunito(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
            _searchFocusNode.requestFocus();
          },
        ),
        IconButton(
          icon: const Icon(Icons.filter_list, color: Colors.black),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Fonctionnalité de filtre à venir !')),
            );
          },
        ),
      ],
    );
  }

  // AppBar pour la recherche
  AppBar _buildSearchAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          setState(() {
            _isSearching = false;
            _searchQuery = '';
            _searchController.clear();
          });
          _searchFocusNode.unfocus();
        },
      ),
      title: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        autofocus: true,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: const InputDecoration(
          hintText: 'Rechercher un hôtel...',
          border: InputBorder.none,
        ),
      ),
      actions: [
        if (_searchQuery.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear, color: Colors.black),
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _searchController.clear();
              });
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final hotelViewModel = Provider.of<HotelViewModel>(context);
    final displayedHotels = _getFilteredAndSortedHotels(hotelViewModel);

    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        final timeSinceLastPress = _lastPressedAt != null ? now.difference(_lastPressedAt!) : const Duration(seconds: 3);

        if (timeSinceLastPress < const Duration(seconds: 2)) {
          return true; // L'application se ferme
        } else {
          _lastPressedAt = now;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Appuyez à nouveau pour quitter'),
              duration: Duration(seconds: 2),
            ),
          );
          return false; // L'application ne se ferme pas
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.lightGrey,
        appBar: _isSearching ? _buildSearchAppBar() : _buildDefaultAppBar(),
        body: GestureDetector(
          onTap: () {
            // Permet de fermer le clavier si on tape en dehors du champ
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${displayedHotels.length} hôtels trouvés',
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    PopupMenuButton<SortOption>(
                      onSelected: (option) {
                        setState(() {
                          _sortOption = option;
                        });
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: SortOption.none,
                          child: Text('Aucun tri'),
                        ),
                        const PopupMenuItem(
                          value: SortOption.rating,
                          child: Text('Par note'),
                        ),
                        const PopupMenuItem(
                          value: SortOption.priceAsc,
                          child: Text('Prix croissant'),
                        ),
                        const PopupMenuItem(
                          value: SortOption.priceDesc,
                          child: Text('Prix décroissant'),
                        ),
                      ],
                      child: Row(
                        children: [
                          Text(
                            'Trier par',
                            style: GoogleFonts.nunito(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: displayedHotels.length,
                  itemBuilder: (context, index) {
                    final hotel = displayedHotels[index];
                    return HotelCard(
                      hotel: hotel,
                      onTap: () {
                        context.push('/hotel/${hotel.id}', extra: hotel);
                      },
                      onFavoriteTap: () => hotelViewModel.toggleFavorite(hotel.id),
                      onBookingTap: () {
                        context.push('/booking', extra: {'hotel': hotel});
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0, // L'onglet Explorer est actif
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          onTap: (index) {
            switch (index) {
              case 0:
                break;
              case 1:
                context.push('/favorites');
                break;
              case 2:
                context.push('/notifications');
                break;
              case 3:
                context.push('/profile');
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Explorer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              activeIcon: Icon(Icons.favorite),
              label: 'Favoris',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_none),
              activeIcon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
