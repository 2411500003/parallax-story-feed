import 'package:flutter/material.dart';

class ParallaxStoryCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double height;
  final double scrollPosition;

  // Menggunakan GlobalKey untuk mendeteksi posisi kartu di layar secara akurat
  final GlobalKey _cardKey = GlobalKey();

  ParallaxStoryCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.height,
    required this.scrollPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _cardKey,
      margin: const EdgeInsets.symmetric(vertical: 4), // Margin lebih rapi untuk Masonry
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // LOGIKA INOVASI: Menghitung posisi relatif terhadap layar (Viewport)
            double relativePos = 0.5;
            final RenderBox? box = _cardKey.currentContext?.findRenderObject() as RenderBox?;

            if (box != null && box.hasSize) {
              final offset = box.localToGlobal(Offset.zero).dy;
              final screenHeight = MediaQuery.of(context).size.height;
              // Normalisasi posisi: 0.0 (atas), 0.5 (tengah), 1.0 (bawah)
              relativePos = (offset / screenHeight).clamp(0.0, 1.0);
            }

            return Stack(
              fit: StackFit.expand,
              children: [
                // LAPISAN 1: Citra Latar Belakang (Parallax Lebih Cepat)
                // Menggunakan Transform.translate dengan perhitungan relativePos
                Transform.translate(
                  offset: Offset(0, (relativePos - 0.5) * -80), // Bergerak berlawanan untuk kedalaman
                  child: Transform.scale(
                    scale: 1.4, // Zoom in sedikit agar area gambar menutupi frame saat bergerak
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // LAPISAN 2: Shadow & Gradasi (Parallax Lebih Lambat)
                // Memberikan efek kedalaman ekstra antara gambar dan teks
                Transform.translate(
                  offset: Offset(0, (relativePos - 0.5) * -30),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: const [0.5, 0.9],
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.85),
                        ],
                      ),
                    ),
                  ),
                ),

                // LAPISAN 3: Konten Teks & UI (Statis/Interaktif)
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "FEATURED",
                          style: TextStyle(color: Colors.black, fontSize: 9, fontWeight: FontWeight.w900),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        title.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          letterSpacing: 0.5,
                          shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.white.withOpacity(0.6), size: 12),
                          const SizedBox(width: 4),
                          Text(
                            "Wonderland, Earth",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}