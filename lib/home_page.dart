import 'package:flutter/material.dart';
import 'pages/mobile_legend_page.dart';
import 'pages/pubg_page.dart';
import 'pages/free_fire_page.dart';
import 'pages/roblox_page.dart';
import 'pages/joki_page.dart';

class HomePage extends StatelessWidget {
  final String email;

  const HomePage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 30, 30),
      body: LayoutBuilder(  
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          final crossAxisCount = isMobile ? 2 : 3; 

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: const Color.fromARGB(255, 30, 30, 30),
                pinned: false,
                floating: false,
                expandedHeight: isMobile ? 250 : 450, 
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 50, vertical: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/images/banner.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(12.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const Row(
                      children: [
                        Text(
                          "POPULER SEKARANG!",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                sliver: SliverGrid.count(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: isMobile ? 2.5 : 4.6, // Adjust aspect ratio for mobile vs. desktop
                  children: [
                    GameCard(
                      title: "Mobile Legends",
                      subtitle: "Moonton",
                      imagePath: "assets/images/ml.jpg",
                      bgColor: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MobileLegendsPage(),
                          ),
                        );
                      },
                    ),
                    GameCard(
                      title: "PUBG Mobile",
                      subtitle: "Tencent",
                      imagePath: "assets/images/pubg.jpg",
                      bgColor: Colors.amber,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PubgPage(),
                          ),
                        );
                      },
                    ),
                    GameCard(
                      title: "Free Fire",
                      subtitle: "Garena",
                      imagePath: "assets/images/freefire.jpg",
                      bgColor: Colors.redAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const FreeFirePage(),
                          ),
                        );
                      },
                    ),
                    GameCard(
                      title: "ROBLOX",
                      subtitle: "Roblox Corporation",
                      imagePath: "assets/images/roblox.jpg",
                      bgColor: Colors.purple,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RobloxPage(),
                          ),
                        );
                      },
                    ),
                    GameCard(
                      title: "Joki Penurun Rank",
                      subtitle: "Party Anomali",
                      imagePath: "assets/images/dwi.jpg",
                      bgColor: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const JokiPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
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