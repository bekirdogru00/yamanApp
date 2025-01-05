import 'package:flutter/material.dart';

class AddPromotionPage extends StatefulWidget {
  const AddPromotionPage({super.key});

  @override
  State<AddPromotionPage> createState() => _AddPromotionPageState();
}

class _AddPromotionPageState extends State<AddPromotionPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _conditionsController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  String? _selectedRestaurant;

  final List<String> _restaurants = [
    'Çiğköfteci Ali Usta',
    'Kebapçı Mehmet',
    'Kahvaltıcı Ahmet',
    'Tatlıcı Hasan',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _conditionsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kampanya Ekle'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Restoran seçimi
              DropdownButtonFormField<String>(
                value: _selectedRestaurant,
                decoration: const InputDecoration(
                  labelText: 'Restoran',
                  border: OutlineInputBorder(),
                ),
                items: _restaurants.map((String restaurant) {
                  return DropdownMenuItem<String>(
                    value: restaurant,
                    child: Text(restaurant),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRestaurant = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen bir restoran seçin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Kampanya başlığı
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Kampanya Başlığı',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen kampanya başlığını girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Kampanya açıklaması
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Kampanya Açıklaması',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen kampanya açıklamasını girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Kampanya koşulları
              TextFormField(
                controller: _conditionsController,
                decoration: const InputDecoration(
                  labelText: 'Kampanya Koşulları',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen kampanya koşullarını girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Başlangıç tarihi
              ListTile(
                title: const Text('Başlangıç Tarihi'),
                subtitle: Text(
                  _startDate != null
                      ? '${_startDate!.day}/${_startDate!.month}/${_startDate!.year}'
                      : 'Seçilmedi',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, true),
              ),
              // Bitiş tarihi
              ListTile(
                title: const Text('Bitiş Tarihi'),
                subtitle: Text(
                  _endDate != null
                      ? '${_endDate!.day}/${_endDate!.month}/${_endDate!.year}'
                      : 'Seçilmedi',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, false),
              ),
              const SizedBox(height: 24),
              // Kaydet butonu
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _startDate != null &&
                      _endDate != null) {
                    // TODO: Kaydetme işlemi eklenecek
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Kampanya başarıyla eklendi'),
                      ),
                    );
                    Navigator.pop(context);
                  } else if (_startDate == null || _endDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Lütfen başlangıç ve bitiş tarihlerini seçin'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 