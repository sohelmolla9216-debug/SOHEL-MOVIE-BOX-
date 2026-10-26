
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
