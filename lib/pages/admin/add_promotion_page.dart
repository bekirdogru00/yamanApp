import 'package:flutter/material.dart';
import '../../services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPromotionPage extends StatefulWidget {
  const AddPromotionPage({super.key});

  @override
  _AddPromotionPageState createState() => _AddPromotionPageState();
}

class _AddPromotionPageState extends State<AddPromotionPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? _selectedRestaurant;
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));
  bool _isLoading = false;
  List<Map<String, dynamic>> _restaurants = [];

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  Future<void> _loadRestaurants() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('businesses')
        .where('categories', arrayContains: 'Restoran')
        .get();

    setState(() {
      _restaurants = snapshot.docs
          .map((doc) => {
                'id': doc.id,
                'name': doc['name'] as String,
              })
          .toList();
    });
  }

  Future<void> _savePromotion() async {
    if (_formKey.currentState!.validate() && _selectedRestaurant != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final firebaseService = FirebaseService();
        await firebaseService.addPromotion(
          title: _titleController.text,
          description: _descriptionController.text,
          businessId: _selectedRestaurant!,
          startDate: _startDate,
          endDate: _endDate,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kampanya başarıyla eklendi')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Hata oluştu: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else if (_selectedRestaurant == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir restoran seçin')),
      );
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: isStartDate ? DateTime.now() : _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 7));
          }
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
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
                decoration: const InputDecoration(
                  labelText: 'Restoran',
                  border: OutlineInputBorder(),
                ),
                value: _selectedRestaurant,
                items: _restaurants.map((restaurant) {
                  return DropdownMenuItem<String>(
                    value: restaurant['id'] as String,
                    child: Text(restaurant['name'] as String),
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

              // Başlangıç tarihi
              ListTile(
                title: const Text('Başlangıç Tarihi'),
                subtitle: Text(
                  '${_startDate.day}/${_startDate.month}/${_startDate.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, true),
              ),

              // Bitiş tarihi
              ListTile(
                title: const Text('Bitiş Tarihi'),
                subtitle: Text(
                  '${_endDate.day}/${_endDate.month}/${_endDate.year}',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _selectDate(context, false),
              ),
              const SizedBox(height: 24),

              // Kaydet butonu
              ElevatedButton(
                onPressed: _isLoading ? null : _savePromotion,
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
                    : const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 