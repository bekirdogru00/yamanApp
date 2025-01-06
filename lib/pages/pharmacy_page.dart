import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class Pharmacy {
  final String name;
  final String address;
  final String phone;
  final LatLng location;
  final Map<DateTime, bool> dutyDates;

  Pharmacy({
    required this.name,
    required this.address,
    required this.phone,
    required this.location,
    required this.dutyDates,
  });

  bool isOnDuty(DateTime date) {
    return dutyDates[DateTime(date.year, date.month, date.day)] ?? false;
  }
}

class PharmacyPage extends StatefulWidget {
  const PharmacyPage({Key? key}) : super(key: key);

  @override
  _PharmacyPageState createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DateTime _selectedDate;
  final DateFormat _dateFormat = DateFormat('d MMMM yyyy', 'tr_TR');
  
  final List<Pharmacy> pharmacies = [
    Pharmacy(
      name: 'Merkez Eczanesi',
      address: 'Atatürk Bulvarı No:123, Merkez/Adıyaman',
      phone: '0416123456',
      location: const LatLng(37.7640, 38.2767),
      dutyDates: {
        DateTime(2024, 1, 6): true,
        DateTime(2024, 1, 12): true,
        DateTime(2024, 1, 18): true,
      },
    ),
    Pharmacy(
      name: 'Yeni Eczane',
      address: 'Gölbaşı Caddesi No:45, Merkez/Adıyaman',
      phone: '0416789012',
      location: const LatLng(37.7645, 38.2772),
      dutyDates: {
        DateTime(2024, 1, 7): true,
        DateTime(2024, 1, 13): true,
        DateTime(2024, 1, 19): true,
      },
    ),
    Pharmacy(
      name: 'Sağlık Eczanesi',
      address: 'Sümer Caddesi No:78, Merkez/Adıyaman',
      phone: '0416345678',
      location: const LatLng(37.7650, 38.2780),
      dutyDates: {
        DateTime(2024, 1, 8): true,
        DateTime(2024, 1, 14): true,
        DateTime(2024, 1, 20): true,
      },
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Arama yapılamıyor: $phoneNumber';
    }
  }

  Future<void> _openMaps(LatLng location, String name) async {
    final Uri launchUri = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: 'maps/dir/',
      queryParameters: {
        'api': '1',
        'destination': '${location.latitude},${location.longitude}',
        'destination_name': name,
      },
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Harita açılamıyor';
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      locale: const Locale('tr', 'TR'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  List<Pharmacy> _getDutyPharmacies(DateTime date) {
    return pharmacies.where((pharmacy) => pharmacy.isOnDuty(date)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Nöbetçi Eczane'),
            Tab(text: 'Tüm Eczaneler'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildDutyPharmacyTab(),
              _buildAllPharmaciesTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDutyPharmacyTab() {
    final dutyPharmacies = _getDutyPharmacies(_selectedDate);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _dateFormat.format(_selectedDate),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  if (dutyPharmacies.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: Text(
                          'Bu tarih için nöbetçi eczane bilgisi bulunamadı',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dutyPharmacies.first.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          dutyPharmacies.first.address,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () => _makePhoneCall(dutyPharmacies.first.phone),
                              icon: const Icon(Icons.phone),
                              label: const Text('Ara'),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => _openMaps(
                                dutyPharmacies.first.location,
                                dutyPharmacies.first.name,
                              ),
                              icon: const Icon(Icons.directions),
                              label: const Text('Yol Tarifi'),
                            ),
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllPharmaciesTab() {
    return ListView.builder(
      itemCount: pharmacies.length,
      itemBuilder: (context, index) {
        final pharmacy = pharmacies[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(
              pharmacy.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(pharmacy.address),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: () => _makePhoneCall(pharmacy.phone),
                ),
                IconButton(
                  icon: const Icon(Icons.directions),
                  onPressed: () => _openMaps(
                    pharmacy.location,
                    pharmacy.name,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 