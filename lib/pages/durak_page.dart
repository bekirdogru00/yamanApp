import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DurakPage extends StatelessWidget {
  const DurakPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> hatlar = [
      {'isim': 'Kolej 1', 'id': 'kolej1'},
      {'isim': 'Kolej 2', 'id': 'kolej2'},
      {'isim': 'Yukarı Karaali', 'id': 'yukari_karaali'},
      {'isim': 'Aşağı Karaali', 'id': 'asagi_karaali'},
      {'isim': 'Esentepe', 'id': 'esentepe'},
      {'isim': 'Hastane', 'id': 'hastane'},
      {'isim': 'Aşağı Karapınar', 'id': 'asagi_karapinar'},
      {'isim': 'Yukarı Karapınar', 'id': 'yukari_karapinar'},
      {'isim': 'Belediye Bulvar', 'id': 'belediye_bulvar'},
      {'isim': 'Belediye 3.Çevre Yolu', 'id': 'belediye_cevre'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dolmuş Hatları'),
      ),
      body: ListView.builder(
        itemCount: hatlar.length,
        itemBuilder: (context, index) {
          final hat = hatlar[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: const Icon(Icons.directions_bus, color: Colors.blue, size: 32),
              title: Text(
                hat['isim']!,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HatDetayPage(
                      hatId: hat['id']!,
                      hatIsim: hat['isim']!,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class HatDetayPage extends StatefulWidget {
  final String hatId;
  final String hatIsim;

  const HatDetayPage({
    Key? key,
    required this.hatId,
    required this.hatIsim,
  }) : super(key: key);

  @override
  State<HatDetayPage> createState() => _HatDetayPageState();
}

class _HatDetayPageState extends State<HatDetayPage> {
  final MapController _mapController = MapController();
  final List<Marker> _markers = [];
  
  // Adıyaman merkez koordinatları
  static const LatLng _center = LatLng(37.7636, 38.2773);

  @override
  void initState() {
    super.initState();
    _loadDuraklar();
  }

  Future<void> _loadDuraklar() async {
    try {
      final duraklar = await FirebaseFirestore.instance
          .collection('duraklar')
          .where('hat_id', isEqualTo: widget.hatId)
          .get();

      setState(() {
        for (var durak in duraklar.docs) {
          final data = durak.data();
          final location = data['konum'] as GeoPoint;
          
          _markers.add(
            Marker(
              point: LatLng(location.latitude, location.longitude),
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(data['isim'] as String),
                      content: Text(data['aciklama'] as String),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Kapat'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Icon(
                  Icons.location_on,
                  color: Colors.blue,
                  size: 40,
                ),
              ),
            ),
          );
        }
      });
    } catch (e) {
      debugPrint('Duraklar yüklenirken hata: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hatIsim),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: _center,
              zoom: 13.0,
              onTap: (_, __) {
                // Haritada boş bir yere tıklandığında açık olan info window'u kapat
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.yamanapp',
              ),
              MarkerLayer(
                markers: _markers,
              ),
            ],
          ),
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: () {
                    _mapController.move(_center, 13.0);
                  },
                  child: const Icon(Icons.center_focus_strong),
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      _markers.clear();
                    });
                    _loadDuraklar();
                  },
                  child: const Icon(Icons.refresh),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 