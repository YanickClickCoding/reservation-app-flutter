import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotels/constants/app_colors.dart';
import 'package:hotels/models/hotel.dart';
import 'package:hotels/screens/hotel_detail_screen.dart';
import 'package:hotels/screens/login_screen.dart';
import 'package:intl/intl.dart' as intl;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Données de l'utilisateur (à remplacer par les données réelles de l'utilisateur connecté)
  final Map<String, dynamic> _userData = {
    'name': 'yanick M\'POLLO',
    'email': 'yanickmpollo@gmail.com',
    'phone': '+22997466618',
    'memberSince': '2023-01-15',
  };

  // Liste des réservations (à remplacer par les données réelles de l'utilisateur)
  final List<Map<String, dynamic>> _bookings = [
    {
      'id': 'BK001',
      'hotel': Hotel(
        id: '1',
        name: 'Hôtel de Luxe Paris',
        location: 'Paris, France',
        price: 250.0,
        rating: 4.8,
        imageUrl: 'assets/Images/hotel_1.png',
        description:
            'Un hôtel de luxe au cœur de Paris avec une vue imprenable sur la Tour Eiffel.',
        facilities: ['Wifi', 'Piscine', 'Spa', 'Restaurant', 'Bar'],
        distance: 0.0,
      ),
      'checkIn': DateTime.now().add(const Duration(days: 7)),
      'checkOut': DateTime.now().add(const Duration(days: 10)),
      'guests': 2,
      'rooms': 1,
      'total': 750.0,
      'status': 'confirmée',
    },
    {
      'id': 'BK002',
      'hotel': Hotel(
        id: '2',
        name: 'Resort Méditerranée',
        location: 'Nice, France',
        price: 180.0,
        rating: 4.6,
        imageUrl: 'assets/Images/hotel_2.png',
        description:
            'Un magnifique resort en bord de mer avec piscine à débordement et spa luxueux.',
        facilities: ['Wifi', 'Piscine', 'Spa', 'Plage privée', 'Restaurant'],
        distance: 0.0,
      ),
      'checkIn': DateTime.now().add(const Duration(days: 30)),
      'checkOut': DateTime.now().add(const Duration(days: 37)),
      'guests': 4,
      'rooms': 2,
      'total': 2520.0,
      'status': 'confirmée',
    },
  ];

  // Afficher la boîte de dialogue de confirmation de déconnexion
  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Déconnexion'),
          content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Déconnexion'),
              onPressed: () {
                // Ici, vous ajouterez la logique de déconnexion
                Navigator.of(context).pop();
                // Rediriger vers l'écran de connexion
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                context.go('/');
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Mon Profil'),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF54D3C2), Color(0xFF4CAF50)],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            AssetImage('assets/Images/profile_placeholder.png'),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _userData['name'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _userData['email'],
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mes informations',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildInfoRow(Icons.person, 'Nom', _userData['name']),
                          const Divider(),
                          _buildInfoRow(
                              Icons.email, 'Email', _userData['email']),
                          const Divider(),
                          _buildInfoRow(
                              Icons.phone, 'Téléphone', _userData['phone']),
                          const Divider(),
                          _buildInfoRow(Icons.calendar_today, 'Membre depuis',
                              _userData['memberSince']),
                          const Divider(),
                          _buildLogoutButton(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Mes réservations',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _bookings.isEmpty ? _buildNoBookings() : _buildBookingsList(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3, // L'onglet Profil est actif
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/favorites');
              break;
            case 2:
              context.go('/notifications');
              break;
            case 3:
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
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF54D3C2)),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: _showLogoutDialog,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout, size: 20),
            SizedBox(width: 8),
            Text('Se déconnecter'),
          ],
        ),
      ),
    );
  }

  Widget _buildNoBookings() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.hotel_class_outlined,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune réservation trouvée',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Commencez à explorer nos hôtels et faites votre première réservation !',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Naviguer vers l'écran d'accueil
              context.go('/');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF54D3C2),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Explorer les hôtels'),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _bookings.length,
      itemBuilder: (context, index) {
        final booking = _bookings[index];
        final hotel = booking['hotel'] as Hotel;
        final checkIn = booking['checkIn'] as DateTime;
        final checkOut = booking['checkOut'] as DateTime;
        final nights = checkOut.difference(checkIn).inDays;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: InkWell(
            onTap: () {
              // Naviguer vers les détails de la réservation
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HotelDetailScreen(hotel: hotel),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          hotel.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hotel.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              hotel.location,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${hotel.rating} (${hotel.distance})',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Dates
                  _buildBookingDetailRow(
                    Icons.calendar_today,
                    '${intl.DateFormat('dd/MM/yyyy').format(checkIn)} - ${intl.DateFormat('dd/MM/yyyy').format(checkOut)}',
                    '$nights nuits',
                  ),
                  const SizedBox(height: 8),
                  // Voyageurs et chambres
                  _buildBookingDetailRow(
                    Icons.people,
                    '${booking['guests']} ${int.parse(booking['guests'].toString()) > 1 ? 'voyageurs' : 'voyageur'}, ${booking['rooms']} ${int.parse(booking['rooms'].toString()) > 1 ? 'chambres' : 'chambre'}',
                    '${(booking['total'] as num).toStringAsFixed(2)} €',
                    isBold: true,
                  ),
                  const SizedBox(height: 12),
                  // Boutons d'action
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Action pour annuler la réservation
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: const Text(
                            'Annuler',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Action pour modifier la réservation
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF54D3C2),
                          ),
                          child: const Text('Modifier'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookingDetailRow(IconData? icon, String label, String value,
      {bool isBold = false}) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 8),
        ],
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: isBold ? const Color(0xFF54D3C2) : Colors.grey[800],
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  // Méthode utilitaire pour obtenir la couleur en fonction du statut de la réservation
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmée':
        return Colors.green;
      case 'en attente':
        return Colors.orange;
      case 'annulée':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
