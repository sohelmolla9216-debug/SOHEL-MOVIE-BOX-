
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const SohelMovieBox());
}

const demoVideo =
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';

class Movie {
  final String title;
  final String category;
  final String year;
  final String image;
  final String language;

  const Movie({
    required this.title,
    required this.category,
    required this.year,
    required this.image,
    required this.language,
  });
}

const movies = [
  Movie(
    title: 'Big Buck Bunny',
    category: 'Animation',
    year: '2008',
    language: 'English',
    image:
        'https://peach.blender.org/wp-content/uploads/title_anouncement.jpg',
  ),
  Movie(
    title: 'Sintel',
    category: 'Fantasy',
    year: '2010',
    language: 'English',
    image:
        'https://durian.blender.org/wp-content/uploads/2010/05/sintel_poster.jpg',
  ),
  Movie(
    title: 'Tears of Steel',
    category: 'Sci-Fi',
    year: '2012',
    language: 'English',
    image:
        'https://mango.blender.org/wp-content/uploads/2013/05/01_thom_celia_bridge.jpg',
  ),
];

class SohelMovieBox extends StatelessWidget {
  const SohelMovieBox({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOHEL Movie Box',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0D12),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00D6A0),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String query = '';
  String category = 'All';

  final categories = [
    'All',
    'Hollywood',
    'Bollywood',
    'Bengali',
    'Anime',
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = movies.where((movie) {
      final matchesQuery =
          movie.title.toLowerCase().contains(query.toLowerCase());
      final matchesCategory =
          category == 'All' || movie.category == category;
      return matchesQuery && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SOHEL Movie Box',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0B0D12),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.account_circle_outlined, size: 29),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            onChanged: (value) => setState(() => query = value),
            decoration: InputDecoration(
              hintText: 'Search movies...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFF1B202A),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Discover Movies',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final item = categories[index];
                return ChoiceChip(
                  label: Text(item),
                  selected: category == item,
                  onSelected: (_) =>
                      setState(() => category = item),
                );
              },
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Featured',
            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFF064E48), Color(0xFF172A40)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'YOUR MOVIE DESTINATION',
                  style: TextStyle(
                    color: Color(0xFF57F2C2),
                    letterSpacing: 1.4,
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Movies. Stories. Entertainment.',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const PlayerScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play Demo'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            query.isEmpty ? 'Popular Movies' : 'Search Results',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (filtered.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text('No movies found. Try another search.'),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.57,
              ),
              itemBuilder: (context, index) {
                final movie = filtered[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlayerScreen(title: movie.title),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                movie.image,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    Container(
                                  color: const Color(0xFF242B37),
                                  child: const Icon(
                                    Icons.movie_outlined,
                                    size: 58,
                                  ),
                                ),
                              ),
                              const Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.white,
                                  size: 48,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${movie.year} • ${movie.category}',
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        movie.language,
                        style: const TextStyle(
                          color: Color(0xFF57F2C2),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          const SizedBox(height: 20),
          const Text(
            'Demo content only. Licensed movies can be added later.',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class PlayerScreen extends StatefulWidget {
  final String title;

  const PlayerScreen({
    super.key,
    this.title = 'Big Buck Bunny Demo',
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final VideoPlayerController controller;
  bool ready = false;
  String? error;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(Uri.parse(demoVideo));
    controller.initialize().then((_) {
      if (!mounted) return;
      setState(() => ready = true);
    }).catchError((_) {
      if (!mounted) return;
      setState(() => error = 'Video could not load. Check your internet.');
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: error != null
            ? Padding(
                padding: const EdgeInsets.all(24),
                child: Text(error!, textAlign: TextAlign.center),
              )
            : !ready
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: controller.value.aspectRatio,
                        child: VideoPlayer(controller),
                      ),
                      const SizedBox(height: 18),
                      IconButton.filled(
                        iconSize: 36,
                        onPressed: () {
                          setState(() {
                            controller.value.isPlaying
                                ? controller.pause()
                                : controller.play();
                          });
                        },
                        icon: Icon(
                          controller.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text('Licensed demo video'),
                    ],
                  ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const SohelMovieBox());
}

class SohelMovieBox extends StatelessWidget {
  const SohelMovieBox({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SOHEL Movie Box',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B0D12),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF71DDB6),
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SOHEL Movie Box',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.account_circle_outlined, size: 30),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Search movies...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFF1D222D),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Discover Movies',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 18),
          const Text(
            'Featured',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF075C50), Color(0xFF142A43)],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'YOUR MOVIE DESTINATION',
                  style: TextStyle(color: Color(0xFF71DDB6)),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Movies. Stories.\nEntertainment.',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 18),
                FilledButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MoviePlayerPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play Demo'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Popular Movies',
            style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          const Card(
            child: ListTile(
              leading: Icon(Icons.movie_outlined, size: 40),
              title: Text('Duck and Cover'),
              subtitle: Text('1951 • Educational Film'),
              trailing: Icon(Icons.play_circle_outline),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Demo video only. More licensed movies coming soon.',
            style: TextStyle(color: Colors.white60),
          ),
        ],
      ),
    );
  }
}

class MoviePlayerPage extends StatefulWidget {
  const MoviePlayerPage({super.key});

  @override
  State<MoviePlayerPage> createState() => _MoviePlayerPageState();
}

class _MoviePlayerPageState extends State<MoviePlayerPage> {
  late final VideoPlayerController controller;
  String? errorMessage;

  @override
  void initState() {
    super.initState();

    controller = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://archive.org/download/ArcherProductionsInc/DuckandC1951.mp4',
      ),
    );

    controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    }).catchError((Object error) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Video could not load. Check your internet connection.';
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Watch Movie')),
      body: Center(
        child: errorMessage != null
            ? Padding(
                padding: const EdgeInsets.all(24),
                child: Text(errorMessage!),
              )
            : controller.value.isInitialized
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AspectRatio(
                        aspectRatio: controller.value.aspectRatio,
                        child: VideoPlayer(controller),
                      ),
                      VideoProgressIndicator(
                        controller,
                        allowScrubbing: true,
                      ),
                      IconButton(
                        iconSize: 48,
                        onPressed: () {
                          setState(() {
                            controller.value.isPlaying
                                ? controller.pause()
                                : controller.play();
                          });
                        },
                        icon: Icon(
                          controller.value.isPlaying
                              ? Icons.pause_circle
                              : Icons.play_circle,
                        ),
                      ),
                    ],
                  )
                : const CircularProgressIndicator(),
      ),
    );
  }
}

