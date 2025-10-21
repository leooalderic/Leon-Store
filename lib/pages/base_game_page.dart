import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:leon_flutter/models/product.dart';
import 'package:leon_flutter/models/transaction_history.dart';
import 'package:leon_flutter/utils/currency_helper.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

abstract class BaseGamePage extends StatefulWidget {
  const BaseGamePage({super.key});

  String get gameTitle;
  List<Product> get instantProducts;
  List<Product> get passProducts;

  @override
  BaseGamePageState createState();
}

abstract class BaseGamePageState<T extends BaseGamePage> extends State<T> {
  GameTransaction? currentTransaction;
  int quantity = 1;
  double rating = 3;
  String? selectedPayment;

  final List<String> paymentMethods = [
    'Dana',
    'OVO',
    'GoPay',
    'ShopeePay',
    'Transfer Bank (BCA/BRI/BNI)',
    'Pulsa (Telkomsel/XL/Indosat)'
  ];

  final TextEditingController idController = TextEditingController();
  final TextEditingController serverController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final total = currentTransaction?.total ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        centerTitle: true,
        title: Text(
          widget.gameTitle,
          style: const TextStyle(
            color: Color(0xFFD2A679),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionCard(
              title: "Data Akun",
              child: Column(
                children: [
                  _inputField("ID", "Masukkan ID", idController),
                  const SizedBox(height: 12),
                  _inputField("Server", "Masukkan Server", serverController),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _sectionCard(
              title: "Pilih Nominal",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Topup Instant",
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 12),
                  _productGrid(widget.instantProducts),
                  const SizedBox(height: 24),
                  const Text("Diamonds Pass",
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 12),
                  _productGrid(widget.passProducts),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _sectionCard(
              title: "Jumlah Pembelian",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _quantityButton(Icons.remove, () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                        if (currentTransaction != null) {
                          currentTransaction = GameTransaction(
                            product: currentTransaction!.product,
                            quantity: quantity,
                            date: DateTime.now(),
                            game: widget.gameTitle,
                            userId: idController.text,
                            server: serverController.text,
                            payment: selectedPayment ?? "-",
                            rating: rating,
                          );
                        }
                      });
                    }
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "$quantity",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  _quantityButton(Icons.add, () {
                    setState(() {
                      quantity++;
                      if (currentTransaction != null) {
                        currentTransaction = GameTransaction(
                          product: currentTransaction!.product,
                          quantity: quantity,
                          date: DateTime.now(),
                          game: widget.gameTitle,
                          userId: idController.text,
                          server: serverController.text,
                          payment: selectedPayment ?? "-",
                          rating: rating,
                        );
                      }
                    });
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _sectionCard(
              title: "Detail Transaksi",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Produk : ${currentTransaction?.product.name ?? '-'}",
                      style: const TextStyle(color: Colors.white70)),
                  Text(
                      "Harga   : ${CurrencyHelper.formatRupiah(currentTransaction?.product.price ?? 0)}",
                      style: const TextStyle(color: Colors.white70)),
                  Text("Jumlah : $quantity",
                      style: const TextStyle(color: Colors.white70)),
                  const Divider(color: Colors.white24),
                  Text(
                    "Total: ${CurrencyHelper.formatRupiah(total)}",
                    style: const TextStyle(
                      color: Color(0xFFD2A679),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _sectionCard(
              title: "Metode Pembayaran",
              child: DropdownButtonFormField<String>(
                dropdownColor: const Color(0xFF2C2C2C),
                value: selectedPayment,
                items: paymentMethods.map((method) {
                  return DropdownMenuItem(
                    value: method,
                    child: Text(method,
                        style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPayment = value;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2C2C2C),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white24),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xFFD2A679)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _sectionCard(
              title: "Beri Rating",
              child: Center(
                child: RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  allowHalfRating: true,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                  unratedColor: Colors.white24,
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (value) {
                    setState(() => rating = value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD2A679),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _confirmOrder,
                child: const Text(
                  "Pesan Sekarang!",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveTransaction(GameTransaction transaction) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('transactions') ?? [];
    final cleaned = data.where((e) => e != 'null' && e.isNotEmpty).toList();
    cleaned.add(jsonEncode(transaction.toJson()));
    await prefs.setStringList('transactions', cleaned);
  }

  void _confirmOrder() {
    if (idController.text.isEmpty || serverController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi ID dan Server terlebih dahulu")),
      );
      return;
    }
    if (currentTransaction == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih produk terlebih dahulu")),
      );
      return;
    }
    if (selectedPayment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pilih metode pembayaran terlebih dahulu")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        final total = currentTransaction!.total;
        return AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Center(
            child: Text(
              'Konfirmasi Pesanan',
              style: TextStyle(
                color: Color(0xFFD2A679),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildConfirmRow('Game', widget.gameTitle),
              _buildConfirmRow('ID', idController.text),
              _buildConfirmRow('Server', serverController.text),
              _buildConfirmRow('Produk', currentTransaction!.product.name),
              _buildConfirmRow('Jumlah', quantity.toString()),
              _buildConfirmRow('Metode', selectedPayment!),
              const Divider(color: Colors.white24),
              Text(
                'Total: ${CurrencyHelper.formatRupiah(total)}',
                style: const TextStyle(
                    color: Color(0xFFD2A679),
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal',
                  style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD2A679),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () async {
                Navigator.pop(context);
                await _saveTransaction(GameTransaction(
                  product: currentTransaction!.product,
                  quantity: quantity,
                  date: DateTime.now(),
                  userId: idController.text,
                  server: serverController.text,
                  game: widget.gameTitle,
                  payment: selectedPayment!,
                  rating: rating,
                ));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pesanan berhasil disimpan ke riwayat!'),
                    backgroundColor: Color(0xFFD2A679),
                  ),
                );
              },
              child:
                  const Text('Konfirmasi', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildConfirmRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              '$label:',
              style: const TextStyle(
                  color: Colors.white70, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Color(0xFFD2A679),
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _productGrid(List<Product> products) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > 600;
        final crossAxisCount = isLargeScreen ? 4 : 2;
        final aspectRatio = isLargeScreen ? 3.5 : 2.5;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: aspectRatio,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return _productCard(product);
          },
        );
      },
    );
  }

  Widget _productCard(Product product) {
    final isSelected = currentTransaction?.product == product;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentTransaction = GameTransaction(
            product: product,
            quantity: quantity,
            date: DateTime.now(),
            game: widget.gameTitle,
            userId: idController.text,
            server: serverController.text,
            payment: selectedPayment ?? "-",
            rating: rating,
          );
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD2A679) : const Color(0xFF3A3A3A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: screenWidth < 400 ? 12 : 14,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              CurrencyHelper.formatRupiah(product.price),
              style: TextStyle(
                color:
                    isSelected ? Colors.black : const Color(0xFFD2A679),
                fontSize: screenWidth < 400 ? 14 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: const Color(0xFF2C2C2C),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFD2A679)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFD2A679),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.black),
      ),
    );
  }
}
