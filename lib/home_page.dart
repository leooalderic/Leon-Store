import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/mobile_legend_page.dart';
import 'pages/pubg_page.dart';
import 'pages/free_fire_page.dart';
import 'pages/roblox_page.dart';
import 'pages/joki_page.dart';
import 'pages/riwayat_transaksi_page.dart';

class HomePage extends StatefulWidget {
  final String email;

  const HomePage({super.key, required this.email});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedMenu = 0;

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  void _onMenuTap(int index) {
    setState(() => selectedMenu = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 30, 30, 30),
        title: Text(
          "Selamat datang, ${widget.email}",
          style: const TextStyle(
            color: Color.fromARGB(255, 210, 166, 121),
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color.fromARGB(255, 210, 166, 121)),
            tooltip: 'Logout',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final crossAxisCount = isMobile ? 2 : 3;

          return Column(
            children: [
              Container(
                color: const Color.fromARGB(255, 30, 30, 30),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildMenuButton(Icons.shopping_bag, "Topup", 0),
                    const SizedBox(width: 20),
                    _buildMenuButton(Icons.history, "Riwayat", 1),
                    const SizedBox(width: 20),
                    _buildMenuButton(Icons.calculate, "Kalkulator Winrate", 2),
                  ],
                ),
              ),

              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  switchInCurve: Curves.easeIn,
                  switchOutCurve: Curves.easeOut,
                  child: CustomScrollView(
                    key: ValueKey<int>(selectedMenu),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final isMobile = constraints.maxWidth < 600;
                                final bannerHeight = isMobile
                                    ? MediaQuery.of(context).size.height * 0.25
                                    : MediaQuery.of(context).size.height * 0.35;

                                return SizedBox(
                                  height: bannerHeight,
                                  width: double.infinity,
                                  child: Image.asset(
                                    "assets/images/banner.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      if (selectedMenu == 0) ...[
                        _buildTopupSection(isMobile, crossAxisCount, context),
                      ] else if (selectedMenu == 1) ...[
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: const RiwayatTransaksiPage(),
                            ),
                          ),
                        ),
                      ] else ...[
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: KalkulatorWinrate(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMenuButton(IconData icon, String title, int index) {
    final bool isSelected = selectedMenu == index;

    return GestureDetector(
      onTap: () => _onMenuTap(index),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon,
                  color: isSelected
                      ? const Color.fromARGB(255, 210, 166, 121)
                      : Colors.white),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: isSelected
                      ? const Color.fromARGB(255, 210, 166, 121)
                      : Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 60,
            color: isSelected
                ? const Color.fromARGB(255, 210, 166, 121)
                : Colors.transparent,
          ),
        ],
      ),
    );
  }

  SliverPadding _buildTopupSection(bool isMobile, int crossAxisCount, BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      sliver: SliverGrid.count(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: isMobile ? 2.5 : 4.6,
        children: [
          GameCard(title: "Mobile Legends", subtitle: "Moonton", imagePath: "assets/images/ml.jpg", bgColor: Colors.blue, onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const MobileLegendsPage()));
          }),
          GameCard(title: "PUBG Mobile", subtitle: "Tencent", imagePath: "assets/images/pubg.jpg", bgColor: Colors.amber, onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const PubgPage()));
          }),
          GameCard(title: "Free Fire", subtitle: "Garena", imagePath: "assets/images/freefire.jpg", bgColor: Colors.redAccent, onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const FreeFirePage()));
          }),
          GameCard(title: "ROBLOX", subtitle: "Roblox Corporation", imagePath: "assets/images/roblox.jpg", bgColor: Colors.purple, onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const RobloxPage()));
          }),
          GameCard(title: "Joki Penurun Rank", subtitle: "Party Anomali", imagePath: "assets/images/dwi.jpg", bgColor: Colors.green, onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const JokiPage()));
          }),
        ],
      ),
    );
  }
}

class KalkulatorWinrate extends StatefulWidget {
  const KalkulatorWinrate({super.key});

  @override
  State<KalkulatorWinrate> createState() => _KalkulatorWinrateState();
}

class _KalkulatorWinrateState extends State<KalkulatorWinrate> {
  final TextEditingController totalMatchController = TextEditingController();
  final TextEditingController currentWRController = TextEditingController();
  final TextEditingController targetWRController = TextEditingController();
  String? hasil;

  void hitungWinrate() {
    final totalMatch = double.tryParse(totalMatchController.text) ?? 0;
    final currentWR = double.tryParse(currentWRController.text) ?? 0;
    final targetWR = double.tryParse(targetWRController.text) ?? 0;

    if (totalMatch <= 0 || currentWR < 0 || targetWR <= 0 || targetWR > 100) {
      setState(() {
        hasil = "⚠️ Harap isi semua kolom dengan angka yang valid.";
      });
      return;
    }

    final currentWins = totalMatch * (currentWR / 100);
    final numerator = (targetWR / 100) * totalMatch - currentWins;
    final denominator = 1 - (targetWR / 100);
    final neededWins = numerator / denominator;

    setState(() {
      if (neededWins.isNaN || neededWins.isInfinite) {
        hasil = "Input tidak valid.";
      } else if (neededWins < 0) {
        hasil =
            "✅ Winrate kamu (${currentWR.toStringAsFixed(0)}%) sudah melebihi target ${targetWR.toStringAsFixed(0)}%.";
      } else {
        hasil =
            "🏆 Kamu membutuhkan ${neededWins.ceil()} pertandingan tanpa kalah untuk mendapat winrate ${targetWR.toStringAsFixed(0)}%.";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 45, 45, 45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                SizedBox(width: 8),
                Text(
                  "Kalkulator Winrate",
                  style: TextStyle(
                    color: Color.fromARGB(255, 210, 166, 121),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _buildInput("Total pertandingan saat ini", totalMatchController),
            const SizedBox(height: 10),
            _buildInput("Winrate saat ini (%)", currentWRController),
            const SizedBox(height: 10),
            _buildInput("Winrate yang diinginkan (%)", targetWRController),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: hitungWinrate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 210, 166, 121),
                      foregroundColor: Colors.black,
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
                        MaterialPageRoute(builder: (_) => const JokiPage()),
                      );
                    },
                    label: const Text("Pesan Joki"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 210, 166, 121),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            if (hasil != null)
              Text(
                hasil!,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              const BorderSide(color: Color.fromARGB(255, 210, 166, 121)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}


class GameCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final Color bgColor;
  final VoidCallback? onTap;

  const GameCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.bgColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  imagePath,
                  width: 70,
                  height: 70,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
