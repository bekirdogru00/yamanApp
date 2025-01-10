import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:intl/intl.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('tr', timeago.TrMessages());
  }

  String _formatTimeAgo(DateTime date) {
    return timeago.format(date, locale: 'tr');
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Haberler'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Tümü'),
              Tab(text: 'Belediye'),
              Tab(text: 'Spor'),
              Tab(text: 'Kültür'),
              Tab(text: 'Turizm'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildNewsList('Tümü'),
            _buildNewsList('Belediye'),
            _buildNewsList('Spor'),
            _buildNewsList('Kültür'),
            _buildNewsList('Turizm'),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsList(String category) {
    return StreamBuilder<QuerySnapshot>(
      stream: category == 'Tümü'
          ? _firebaseService.getNews()
          : FirebaseFirestore.instance
              .collection('news')
              .where('category', isEqualTo: category)
              .orderBy('publishDate', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Hata: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('Henüz haber bulunmuyor'));
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final data = doc.data() as Map<String, dynamic>;
            final publishDate = (data['publishDate'] as Timestamp).toDate();

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (data['videoUrl'] != null && data['videoUrl'].toString().isNotEmpty)
                    _buildYoutubePlayer(data['videoUrl'])
                  else if (data['imageUrl'] != null && data['imageUrl'].toString().isNotEmpty)
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          data['imageUrl'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.error_outline, size: 50),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                data['category'] ?? '',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              _formatTimeAgo(publishDate),
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data['title'] ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data['content'] ?? '',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                // TODO: Haber detay sayfasına yönlendirme
                              },
                              child: const Text('Devamını Oku'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildYoutubePlayer(String url) {
    String? videoId = YoutubePlayerController.convertUrlToId(url);
    if (videoId == null) return const SizedBox();

    final controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
      ),
    );

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: YoutubePlayer(
          controller: controller,
        ),
      ),
    );
  }
} 