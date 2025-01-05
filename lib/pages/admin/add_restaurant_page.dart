import 'package:flutter/material.dart';

class AddRestaurantPage extends StatefulWidget {
  const AddRestaurantPage({super.key});

  @override
  State<AddRestaurantPage> createState() => _AddRestaurantPageState();
}

class _AddRestaurantPageState extends State<AddRestaurantPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final List<String> _selectedCategories = [];
  String? _selectedImage;

  final List<String> _availableCategories = [
    'Kebap',
    'Çiğköfte',
    'Kahvaltı',
    'Tatlı',
    'Fast Food',
    'Cafe',
    'Geleneksel',
    'Dünya Mutfağı',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restoran Ekle'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Fotoğraf seçme alanı
              Card(
                child: InkWell(
                  onTap: () {
                    // TODO: Fotoğraf seçme işlemi eklenecek
                  },
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _selectedImage != null
                        ? Image.asset(
                            _selectedImage!,
                            fit: BoxFit.cover,
                          )
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Fotoğraf Ekle',
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // İsim alanı
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Restoran Adı',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen restoran adını girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Açıklama alanı
              TextFormField(
                controller: _descriptionController,
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
              // Adres alanı
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Adres',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen adres bilgisi girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Telefon alanı
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefon',
                  border: OutlineInputBorder(),
                  prefixText: '+90 ',
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen telefon numarası girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Kategoriler
              const Text(
                'Kategoriler',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _availableCategories.map((category) {
                  final isSelected = _selectedCategories.contains(category);
                  return FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedCategories.add(category);
                        } else {
                          _selectedCategories.remove(category);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              // Kaydet butonu
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Kaydetme işlemi eklenecek
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Restoran başarıyla eklendi'),
                      ),
                    );
                    Navigator.pop(context);
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