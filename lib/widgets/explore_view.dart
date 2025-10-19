import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotels/models/hotel.dart';
import 'package:hotels/widgets/hotel_card.dart';
import 'package:provider/provider.dart';
import '../viewmodels/hotel_viewmodel.dart';

class ExploreView extends StatefulWidget {
  const ExploreView({Key? key}) : super(key: key);

  @override
  State<ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<ExploreView> {
  @override
  void initState() {
    super.initState();
    // Charger les données des hôtels au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HotelViewModel>(context, listen: false).fetchHotels();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hotelViewModel = Provider.of<HotelViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explorer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              // Naviguer vers l'écran de profil en l'ajoutant à la pile de navigation
              context.push('/profile');
            },
          ),
        ],
      ),
      body: _buildHotelList(hotelViewModel),
    );
  }

  Widget _buildHotelList(HotelViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (viewModel.errorMessage != null) {
      return Center(child: Text(viewModel.errorMessage!));
    } else {
      return ListView.builder(
        itemCount: viewModel.hotels.length,
        itemBuilder: (context, index) {
          final hotel = viewModel.hotels[index];
          return HotelCard(
            hotel: hotel,
            onTap: () {
              context.push('/hotel/${hotel.id}', extra: hotel);
            },
            onFavoriteTap: () {
              viewModel.toggleFavorite(hotel.id);
            },
            onBookingTap: () {
              context.push('/booking', extra: {'hotel': hotel});
            },
          );
        },
      );
    }
  }
}
