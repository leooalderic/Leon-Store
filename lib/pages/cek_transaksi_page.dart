import 'package:flutter/material.dart';


class CekTransaksiPage extends StatelessWidget {
  const CekTransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          "Cek Transaksi",
          style: TextStyle(color: Color(0xFFD2A679)),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "Belum ada transaksi.",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
    );
  }
}
