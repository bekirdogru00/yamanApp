import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AddGuzergahPage extends StatefulWidget {
  const AddGuzergahPage({super.key});

  @override
  State<AddGuzergahPage> createState() => _AddGuzergahPageState();
}

class _AddGuzergahPageState extends State<AddGuzergahPage> {
  final _formKey = GlobalKey<FormState>();
  final _isimController = TextEditingController();
  final _aciklamaController = TextEditingController();
  String? _selectedHat;
  final List<LatLng> _rotaNoktalar = [];
  final MapController _mapController = MapController();
  bool _isLoading = false;

  // Adıyaman merkez koordinatları
  static const LatLng _center = LatLng(37.7636, 38.2773);

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

  Future<void> _saveGuzergah() async {
    if (_formKey.currentState!.validate() && _selectedHat != null && _rotaNoktalar.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        final geoPoints = _rotaNoktalar
            .map((point) => GeoPoint(point.latitude, point.longitude))
            .toList();

        await FirebaseFirestore.instance
            .collection('guzergahlar')
            .doc(_selectedHat)
            .set({
          'isim': _isimController.text,
          'aciklama': _aciklamaController.text,
          'rota': geoPoints,
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Güzergah başarıyla eklendi')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Hata: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else if (_rotaNoktalar.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen haritadan en az bir nokta seçin')),
      );
    }
  }

  void _clearRoute() {
    setState(() {
      _rotaNoktalar.clear();
    });
  }

  @override
  void dispose() {
    _isimController.dispose();
    _aciklamaController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Güzergah Ekle'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Hat seçimi
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Hat Seçin',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedHat,
                      items: hatlar.map((hat) {
                        return DropdownMenuItem(
                          value: hat['id'],
                          child: Text(hat['isim']!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedHat = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen bir hat seçin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Güzergah adı
                    TextFormField(
                      controller: _isimController,
                      decoration: const InputDecoration(
                        labelText: 'Güzergah Adı',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen güzergah adını girin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Açıklama
                    TextFormField(
                      controller: _aciklamaController,
                      decoration: const InputDecoration(
                        labelText: 'Açıklama',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen açıklama girin';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Harita
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Stack(
                          children: [
                            FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(
                                center: _center,
                                zoom: 13.0,
                                onTap: (tapPosition, point) {
                                  setState(() {
                                    _rotaNoktalar.add(point);
                                  });
                                },
                                interactiveFlags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.example.yamanapp',
                                  tileProvider: NetworkTileProvider(),
                                ),
                                PolylineLayer(
                                  polylines: [
                                    if (_rotaNoktalar.length >= 2)
                                      Polyline(
                                        points: _rotaNoktalar,
                                        color: Colors.blue,
                                        strokeWidth: 3,
                                      ),
                                  ],
                                ),
                                MarkerLayer(
                                  markers: _rotaNoktalar
                                      .asMap()
                                      .entries
                                      .map(
                                        (entry) => Marker(
                                          point: entry.value,
                                          width: 40,
                                          height: 40,
                                          child: Icon(
                                            entry.key == 0
                                                ? Icons.play_circle
                                                : entry.key == _rotaNoktalar.length - 1
                                                    ? Icons.stop_circle
                                                    : Icons.circle,
                                            color: entry.key == 0
                                                ? Colors.green
                                                : entry.key == _rotaNoktalar.length - 1
                                                    ? Colors.red
                                                    : Colors.blue,
                                            size: 30,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Column(
                                children: [
                                  FloatingActionButton(
                                    mini: true,
                                    onPressed: () {
                                      _mapController.move(_center, 13.0);
                                    },
                                    child: const Icon(Icons.center_focus_strong),
                                  ),
                                  const SizedBox(height: 8),
                                  FloatingActionButton(
                                    mini: true,
                                    onPressed: _clearRoute,
                                    backgroundColor: Colors.red,
                                    child: const Icon(Icons.clear),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Kaydet butonu
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveGuzergah,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text('GÜZERGAH EKLE'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
} 