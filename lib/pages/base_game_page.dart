import 'package:flutter/material.dart';
import 'package:leon_flutter/models/product.dart';
import 'package:leon_flutter/models/transaction.dart';
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
  Transaction? currentTransaction;
  int quantity = 1;
  double rating = 3;

  @override
  Widget build(BuildContext context) {
    final total = currentTransaction?.total ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFF121212), // lebih gelap
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
            // Input Akun
            _sectionCard(
              title: "Data Akun",
              child: Column(
                children: [
                  _inputField("ID", "Masukkan ID"),
                  const SizedBox(height: 12),
                  _inputField("Server", "Masukkan Server"),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Pilih Nominal
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

            // Jumlah Pembelian
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
                          currentTransaction = Transaction(
                            product: currentTransaction!.product,
                            quantity: quantity,
                          );
                        }
                      });
                    }
                  }),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "$quantity",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                  _quantityButton(Icons.add, () {
                    setState(() {
                      quantity++;
                      if (currentTransaction != null) {
                        currentTransaction = Transaction(
                          product: currentTransaction!.product,
                          quantity: quantity,
                        );
                      }
                    });
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Detail Transaksi
            _sectionCard(
              title: "Detail Transaksi",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Produk: ${currentTransaction?.product.name ?? '-'}",
                      style: const TextStyle(color: Colors.white70)),
                  Text(
                      "Harga: ${CurrencyHelper.formatRupiah(currentTransaction?.product.price ?? 0)}",
                      style: const TextStyle(color: Colors.white70)),
                  Text("Jumlah: $quantity",
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

            // Rating
            _sectionCard(
              title: "Beri Rating",
              child: Center(
                child: RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  allowHalfRating: true,
                  itemSize: 30,
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

            // Tombol Pesan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD2A679),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Pesanan berhasil dibuat!")),
                  );
                },
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
          currentTransaction = Transaction(
            product: product,
            quantity: quantity,
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
                color: isSelected ? Colors.black : const Color(0xFFD2A679),
                fontSize: screenWidth < 400 ? 14 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String label, String hint) {
    return TextField(
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