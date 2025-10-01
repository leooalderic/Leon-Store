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

  @override
  Widget build(BuildContext context) {
    final total = currentTransaction?.total ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        title: Text(widget.gameTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Masukkan Data Akun
            _sectionCard(
              title: "Masukkan Data Akun",
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: "ID",
                      hintText: "Masukkan ID",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Server",
                      hintText: "Masukkan Server",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
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
                  const Text(
                    "Topup Instant",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: widget.instantProducts
                        .map((p) => _productCard(p))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Diamonds Pass",
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: widget.passProducts
                        .map((p) => _productCard(p))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Jumlah Pembelian
            _sectionCard(
              title: "Masukkan Jumlah Pembelian",
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
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
                    },
                    icon: const Icon(Icons.remove, color: Colors.white),
                  ),
                  Text(
                    "$quantity",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        quantity++;
                        if (currentTransaction != null) {
                          currentTransaction = Transaction(
                            product: currentTransaction!.product,
                            quantity: quantity,
                          );
                        }
                      });
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                  ),
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
                  Text(
                    "Produk: ${currentTransaction?.product.name ?? '-'}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "Harga: ${CurrencyHelper.formatRupiah(currentTransaction?.product.price ?? 0)}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    "Jumlah: $quantity",
                    style: const TextStyle(color: Colors.white70),
                  ),
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

Center(
  child: RatingBar.builder(
    initialRating: 3,
    minRating: 1,
    direction: Axis.horizontal,
    allowHalfRating: true,
    itemCount: 5,
    itemPadding: EdgeInsets.symmetric(horizontal: 3.0),
    itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
    onRatingUpdate: (rating) {
      print(rating);
    },
  ),
),
const SizedBox(height: 24), 

            // Tombol Pesan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD2A679),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Pesanan berhasil dibuat!")),
                  );
                },
                icon: const Icon(Icons.shopping_bag, color: Colors.white),
                label: const Text(
                  "Pesan Sekarang!",
                  style: TextStyle(color: Colors.white),
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
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFD2A679),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _productCard(Product product) {
    final isSelected = currentTransaction?.product == product;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentTransaction = Transaction(
            product: product,
            quantity: quantity,
          );
        });
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double screenWidth = constraints.maxWidth;
          final double cardWidth = (screenWidth / 2) - 18;
          return Container(
            width: cardWidth,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFD2A679)
                  : const Color(0xFF3A3A3A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  CurrencyHelper.formatRupiah(product.price),
                  style: TextStyle(
                    color: isSelected ? Colors.black : const Color(0xFFD2A679),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
