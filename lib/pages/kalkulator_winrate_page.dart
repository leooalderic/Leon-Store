import 'package:flutter/material.dart';
import 'joki_page.dart';

class KalkulatorWinratePage extends StatefulWidget {
  const KalkulatorWinratePage({super.key});

  @override
  State<KalkulatorWinratePage> createState() => _KalkulatorWinratePageState();
}

class _KalkulatorWinratePageState extends State<KalkulatorWinratePage> {
  final totalController = TextEditingController();
  final winrateController = TextEditingController();
  final targetController = TextEditingController();

  String hasil = '';

  void hitungWinrate() {
    final total = double.tryParse(totalController.text) ?? 0;
    final winrate = double.tryParse(winrateController.text) ?? 0;
    final target = double.tryParse(targetController.text) ?? 0;

    if (total <= 0 || winrate < 0 || target <= 0 || target <= winrate) {
      setState(() {
        hasil =
            '⚠️ Pastikan semua input benar dan winrate yang diinginkan lebih tinggi dari winrate saat ini.';
      });
      return;
    }

    final currentWins = total * (winrate / 100);
    final requiredWins = (target * total - 100 * currentWins) / (100 - target);

    setState(() {
      hasil =
          '🏆 Kamu membutuhkan ${requiredWins.round()} pertandingan tanpa kalah untuk mendapat winrate ${target.toStringAsFixed(0)}%.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          color: const Color(0xFF2B2B2B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.adjust, color: Color(0xFFd69c63)),
                    const SizedBox(width: 8),
                    const Text(
                      "Kalkulator Winrate",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFd69c63),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: totalController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Total pertandingan saat ini",
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFd69c63)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: winrateController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Winrate saat ini (%)",
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFd69c63)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: targetController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: "Winrate yang diinginkan (%)",
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white38),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFd69c63)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: hitungWinrate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFd69c63),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("Hitung"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const JokiPage(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.sports_esports),
                        label: const Text("Pesan Joki"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFd69c63),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                if (hasil.isNotEmpty)
                  Text(
                    hasil,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
