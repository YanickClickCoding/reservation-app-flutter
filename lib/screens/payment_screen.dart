import 'package:flutter/material.dart';
import 'package:hotels/constants/app_colors.dart';
import 'package:hotels/models/hotel.dart';
import 'package:hotels/screens/profile_screen.dart';
import 'package:intl/intl.dart';

class PaymentScreen extends StatefulWidget {
  final Hotel hotel;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int adults;
  final int children;
  final int rooms;

  const PaymentScreen({
    Key? key,
    required this.hotel,
    required this.checkInDate,
    required this.checkOutDate,
    required this.adults,
    required this.children,
    required this.rooms,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardNameController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _saveCard = false;
  int _selectedPaymentMethod = 0; // 0: Carte, 1: PayPal, 2: Apple Pay

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardNameController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _submitPayment() {
    if (_formKey.currentState?.validate() ?? false) {
      // Afficher une boîte de dialogue de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Simuler un traitement de paiement
      Future.delayed(const Duration(seconds: 2), () {
        // Fermer le dialogue de chargement
        Navigator.of(context).pop();
        
        // Afficher une alerte de succès
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Paiement réussi !'),
            content: const Text('Votre réservation a été confirmée. Vous recevrez un email de confirmation sous peu.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Rediriger vers l'écran de profil
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
                child: const Text('D\'accord'),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final nights = widget.checkOutDate.difference(widget.checkInDate).inDays;
    final totalPrice = widget.hotel.price * nights * widget.rooms;
    final serviceFee = totalPrice * 0.1;
    final totalAmount = totalPrice + serviceFee;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiement'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Récapitulatif de la réservation
            _buildBookingSummary(),
            const SizedBox(height: 24),

            // Méthode de paiement
            const Text(
              'Méthode de paiement',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildPaymentMethodSelector(),
            const SizedBox(height: 16),

            // Formulaire de paiement
            if (_selectedPaymentMethod == 0) _buildCreditCardForm(),
            if (_selectedPaymentMethod == 1) _buildPayPalInfo(),
            if (_selectedPaymentMethod == 2) _buildApplePayInfo(),
            
            const SizedBox(height: 24),

            // Conditions et bouton de paiement
            Row(
              children: [
                Checkbox(
                  value: _saveCard,
                  onChanged: (value) {
                    setState(() {
                      _saveCard = value ?? false;
                    });
                  },
                  activeColor: AppColors.primary,
                ),
                const Expanded(
                  child: Text(
                    'Enregistrer cette carte pour des paiements futurs',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'En cliquant sur "Payer maintenant", vous acceptez nos conditions générales et notre politique de confidentialité.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Détails du prix
            _buildPriceDetails(totalPrice, serviceFee, totalAmount),
            const SizedBox(height: 16),

            // Bouton de paiement
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Payer maintenant',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.hotel.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                widget.hotel.location,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          _buildSummaryRow('Date d\'arrivée', DateFormat('dd/MM/yyyy').format(widget.checkInDate)),
          const SizedBox(height: 8),
          _buildSummaryRow('Date de départ', DateFormat('dd/MM/yyyy').format(widget.checkOutDate)),
          const SizedBox(height: 8),
          _buildSummaryRow('Durée du séjour', '${widget.checkOutDate.difference(widget.checkInDate).inDays} nuits'),
          const SizedBox(height: 8),
          _buildSummaryRow('Voyageurs', '${widget.adults} Adulte${widget.adults > 1 ? 's' : ''}${widget.children > 0 ? ', ${widget.children} Enfant${widget.children > 1 ? 's' : ''}' : ''}'),
          const SizedBox(height: 8),
          _buildSummaryRow('Chambres', '${widget.rooms} Chambre${widget.rooms > 1 ? 's' : ''}'),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelector() {
    final paymentMethods = [
      {'icon': Icons.credit_card, 'label': 'Carte'},
      {'icon': Icons.payment, 'label': 'PayPal'},
      {'icon': Icons.apple, 'label': 'Apple Pay'},
    ];

    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: List.generate(paymentMethods.length, (index) {
          final isSelected = _selectedPaymentMethod == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedPaymentMethod = index;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
                  border: isSelected
                      ? Border.all(color: AppColors.primary, width: 2)
                      : null,
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(index == 0 ? 8 : 0),
                    right: Radius.circular(index == paymentMethods.length - 1 ? 8 : 0),
                  ),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      paymentMethods[index]['icon'] as IconData,
                      color: isSelected ? AppColors.primary : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      paymentMethods[index]['label'] as String,
                      style: TextStyle(
                        color: isSelected ? AppColors.primary : Colors.grey,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCreditCardForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _cardNumberController,
            decoration: const InputDecoration(
              labelText: 'Numéro de carte',
              hintText: '1234 5678 9012 3456',
              prefixIcon: Icon(Icons.credit_card),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer un numéro de carte';
              }
              if (value.replaceAll(' ', '').length < 16) {
                return 'Numéro de carte invalide';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _cardNameController,
            decoration: const InputDecoration(
              labelText: 'Nom sur la carte',
              hintText: 'JEAN DUPONT',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.characters,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez entrer le nom sur la carte';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextFormField(
                  controller: _expiryDateController,
                  decoration: const InputDecoration(
                    labelText: 'Date d\'expiration',
                    hintText: 'MM/AA',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'MM/AA';
                    }
                    if (!RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})').hasMatch(value)) {
                      return 'Format invalide';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _cvvController,
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    hintText: '123',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'CVV requis';
                    }
                    if (value.length < 3) {
                      return 'CVV invalide';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPayPalInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Icon(Icons.payment, size: 48, color: Colors.blue),
          const SizedBox(height: 16),
          const Text(
            'Vous serez redirigé vers PayPal pour finaliser votre paiement de manière sécurisée.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Simuler une redirection vers PayPal
              _submitPayment();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003087), // Bleu PayPal
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Payer avec PayPal'),
          ),
        ],
      ),
    );
  }

  Widget _buildApplePayInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Icon(Icons.apple, size: 48, color: Colors.black),
          const SizedBox(height: 16),
          const Text(
            'Utilisez Apple Pay pour un paiement rapide et sécurisé avec Face ID, Touch ID ou votre code d\'accès.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Simuler un paiement Apple Pay
              _submitPayment();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text('Payer avec Apple Pay'),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDetails(double totalPrice, double serviceFee, double totalAmount) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          _buildPriceRow('Prix du séjour', '${totalPrice.toStringAsFixed(2)} €'),
          const SizedBox(height: 8),
          _buildPriceRow('Frais de service', '${serviceFee.toStringAsFixed(2)} €'),
          const Divider(height: 24),
          _buildPriceRow(
            'Total',
            '${totalAmount.toStringAsFixed(2)} €',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isTotal ? Colors.black : Colors.grey[700],
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
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
    );
  }
}
