import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'parallax_card.dart';

class ParallaxPage extends StatefulWidget {
  const ParallaxPage({super.key});

  @override
  State<ParallaxPage> createState() => _ParallaxPageState();
}

class _ParallaxPageState extends State<ParallaxPage> {
  // Controller untuk memantau maxScrollExtent sesuai modul PDF
  final ScrollController _mainScrollController = ScrollController();
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _mainScrollController.addListener(() {
      // Logika deteksi akhir halaman (Infinite Scrolling)
      if (_mainScrollController.position.pixels >= _mainScrollController.position.maxScrollExtent - 100) {
        debugPrint("Sistem: Memuat data baru...");
      }
    });
  }

  @override
  void dispose() {
    _mainScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Mengubah ke Dark Mode sesuai request
      backgroundColor: const Color(0xFF0F0F0F),
      body: NotificationListener<ScrollNotification>(
        onNotification: (notif) {
          if (notif is ScrollUpdateNotification) {
            setState(() {
              _scrollOffset = _mainScrollController.offset;
            });
          }
          return true;
        },
        child: CustomScrollView(
          controller: _mainScrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // AppBar dengan Tema Gelap & Efek Stretch
            SliverAppBar(
              expandedHeight: 280.0,
              pinned: true,
              stretch: true,
              backgroundColor: const Color(0xFF1A1A1A),
              centerTitle: true,
              leading: const Icon(Icons.menu_rounded, color: Colors.white),
              actions: const [
                Icon(Icons.notifications_none_rounded, color: Colors.white),
                SizedBox(width: 16)
              ],
              flexibleSpace: FlexibleSpaceBar(
                title: const Text(
                    "PARALLAX FEED",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    )
                ),
                stretchModes: const [
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                ],
                background: ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withOpacity(0.2), Colors.black],
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.darken,
                  child: Image.network(
                    "https://images.unsplash.com/photo-1470770841072-f978cf4d019e?auto=format&fit=crop&w=800",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // Section Pemanis (Banner)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Trending Today",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                          image: NetworkImage("https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=800"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Tab Kategori (Sticky) - Warna diubah ke Dark
            SliverPersistentHeader(
              pinned: true,
              delegate: _DarkCategoryDelegate(),
            ),

            // Masonry Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              sliver: SliverMasonryGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                itemBuilder: (context, index) {
                  final List<double> randomHeights = [240, 320, 200, 280];
                  return ParallaxStoryCard(
                    imageUrl: "https://picsum.photos/id/${index + 40}/500/800",
                    title: "Voyage #${index + 1}",
                    height: randomHeights[index % 4],
                    scrollPosition: _scrollOffset, // Variabel dikirim ke card
                  );
                },
                childCount: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DarkCategoryDelegate extends SliverPersistentHeaderDelegate {
  final List<String> _tags = ["All Stories", "Landscape", "Adventure", "Urban", "Vlog"];
  final ValueNotifier<int> _selectedIndex = ValueNotifier(0);

  @override double get minExtent => 60;
  @override double get maxExtent => 60;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFF0F0F0F),
      child: ValueListenableBuilder(
        valueListenable: _selectedIndex,
        builder: (context, int val, _) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _tags.length,
            itemBuilder: (context, i) {
              bool active = (val == i);
              return GestureDetector(
                onTap: () => _selectedIndex.value = i,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: active ? Colors.orangeAccent : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _tags[i],
                    style: TextStyle(
                        color: active ? Colors.black : Colors.white70,
                        fontWeight: FontWeight.bold,
                        fontSize: 13
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override bool shouldRebuild(covariant SliverPersistentHeaderDelegate old) => true;
}