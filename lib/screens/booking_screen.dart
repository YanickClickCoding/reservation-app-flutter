import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hotels/constants/app_colors.dart';
import 'package:hotels/models/hotel.dart';
import 'package:hotels/screens/payment_screen.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final Hotel hotel;

  const BookingScreen({
    Key? key,
    required this.hotel,
  }) : super(key: key);

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  int _adults = 1;
  int _children = 0;
  int _rooms = 1;
  final _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? DateTime.now() : _checkInDate?.add(const Duration(days: 1)) ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: isCheckIn ? DateTime.now() : _checkInDate ?? DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
          if (_checkOutDate != null && _checkOutDate!.isBefore(picked.add(const Duration(days: 1)))) {
            _checkOutDate = null;
          }
        } else {
          _checkOutDate = picked;
        }
      });
    }
  }

  void _submitBooking() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_checkInDate == null || _checkOutDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez sélectionner les dates de séjour'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      context.push('/payment', extra: {
        'hotel': widget.hotel,
        'checkInDate': _checkInDate!,
        'checkOutDate': _checkOutDate!,
        'adults': _adults,
        'children': _children,
        'rooms': _rooms,
      });
    }
  }

  int get _numberOfNights {
    if (_checkInDate == null || _checkOutDate == null) return 0;
    return _checkOutDate!.difference(_checkInDate!).inDays;
  }

  double get _subtotal {
    if (_checkInDate == null || _checkOutDate == null) return 0.0;
    return widget.hotel.price * _numberOfNights * _rooms;
  }

  double get _serviceFee {
    return _subtotal * 0.1; // 10% de frais de service
  }

  double get _totalPrice {
    return _subtotal + _serviceFee;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réserver un séjour'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(widget.hotel.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    widget.hotel.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Dates du séjour',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDateField(
                      context,
                      'Arrivée',
                      _checkInDate,
                      true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDateField(
                      context,
                      'Départ',
                      _checkOutDate,
                      false,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _buildCounterRow(
                'Adultes',
                _adults,
                (value) => setState(() => _adults = value),
                min: 1,
                max: 10,
              ),
              const SizedBox(height: 16),
              _buildCounterRow(
                'Enfants',
                _children,
                (value) => setState(() => _children = value),
                min: 0,
                max: 10,
              ),
              const SizedBox(height: 16),
              _buildCounterRow(
                'Chambres',
                _rooms,
                (value) => setState(() => _rooms = value),
                min: 1,
                max: 10,
              ),
              const SizedBox(height: 32),

              const Text(
                'Détails du prix',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildPriceDetail(
                '${widget.hotel.price.toStringAsFixed(2)} € x $_numberOfNights nuits x $_rooms chambre${_rooms > 1 ? 's' : ''}',
                '${_subtotal.toStringAsFixed(2)} €',
              ),
              const SizedBox(height: 8),
              _buildPriceDetail(
                'Frais de service',
                '${_serviceFee.toStringAsFixed(2)} €',
              ),
              const Divider(height: 32),
              _buildPriceDetail(
                'Total',
                '${_totalPrice.toStringAsFixed(2)} €',
                isTotal: true,
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Confirmer la réservation',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
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
              context.go('/profile');
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

  Widget _buildDateField(
    BuildContext context,
    String label,
    DateTime? date,
    bool isCheckIn,
  ) {
    return GestureDetector(
      onTap: () => _selectDate(context, isCheckIn),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              date != null
                  ? DateFormat('dd/MM/yyyy').format(date)
                  : 'Sélectionner une date',
              style: TextStyle(
                color: date != null ? Colors.black : Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounterRow(
    String label,
    int value,
    Function(int) onChanged, {
    required int min,
    required int max,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: value > min ? AppColors.primary : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.remove, size: 16, color: Colors.white),
          ),
          onPressed: value > min
              ? () => onChanged(value - 1)
              : null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            value.toString(),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: value < max ? AppColors.primary : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, size: 16, color: Colors.white),
          ),
          onPressed: value < max
              ? () => onChanged(value + 1)
              : null,
        ),
      ],
    );
  }

  Widget _buildPriceDetail(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppColors.primary : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
