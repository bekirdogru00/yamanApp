import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AddDurakPage extends StatefulWidget {
  const AddDurakPage({super.key});

  @override
  State<AddDurakPage> createState() => _AddDurakPageState();
}

class _AddDurakPageState extends State<AddDurakPage> {
  final _formKey = GlobalKey<FormState>();
  final _isimController = TextEditingController();
  final _aciklamaController = TextEditingController();
  String? _selectedHat;
  LatLng? _selectedLocation;
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

  Future<void> _saveDurak() async {
    if (_formKey.currentState!.validate() && _selectedHat != null && _selectedLocation != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final geoPoint = GeoPoint(_selectedLocation!.latitude, _selectedLocation!.longitude);

        await FirebaseFirestore.instance.collection('duraklar').add({
          'isim': _isimController.text,
          'aciklama': _aciklamaController.text,
          'konum': geoPoint,
          'hat_id': _selectedHat,
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Durak başarıyla eklendi')),
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
    } else if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen haritadan bir konum seçin')),
      );
    }
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
        title: const Text('Durak Ekle'),
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

                    // Durak adı
                    TextFormField(
                      controller: _isimController,
                      decoration: const InputDecoration(
                        labelText: 'Durak Adı',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Lütfen durak adını girin';
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
                                    _selectedLocation = point;
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
                                MarkerLayer(
                                  markers: [
                                    if (_selectedLocation != null)
                                      Marker(
                                        point: _selectedLocation!,
                                        width: 40,
                                        height: 40,
                                        child: const Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                          size: 40,
                                        ),
                                      ),
                                  ],
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
                                    child: const Icon(Icons.my_location),
                                  ),
                                  if (_selectedLocation != null) ...[
                                    const SizedBox(height: 8),
                                    FloatingActionButton(
                                      mini: true,
                                      onPressed: () {
                                        setState(() {
                                          _selectedLocation = null;
                                        });
                                      },
                                      child: const Icon(Icons.clear),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Kaydet butonu
                    ElevatedButton(
                      onPressed: _saveDurak,
                      child: const Text('Durak Ekle'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
} 