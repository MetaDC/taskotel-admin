import 'package:flutter/material.dart';
import 'package:taskoteladmin/core/theme/app_colors.dart';
import 'package:taskoteladmin/features/super_admin/domain/entities/master_hotel_entity.dart';

class AddMasterHotelDialog extends StatefulWidget {
  final Function(MasterHotelEntity) onMasterHotelAdded;

  const AddMasterHotelDialog({
    super.key,
    required this.onMasterHotelAdded,
  });

  @override
  State<AddMasterHotelDialog> createState() => _AddMasterHotelDialogState();
}

class _AddMasterHotelDialogState extends State<AddMasterHotelDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _selectedPropertyType = 'Luxury Hotel';
  bool _isActive = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Create Master Hotel Template',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Create a hotel template that clients can import to set up their hotels with predefined departments and tasks.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Template Name *',
                      hintText: 'e.g., Luxury Hotel Template',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter template name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Description *',
                      hintText: 'Describe what this template includes and its target use case',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedPropertyType,
                    onChanged: (value) {
                      setState(() {
                        _selectedPropertyType = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Property Type *',
                      border: OutlineInputBorder(),
                    ),
                    items: _propertyTypes.map((type) => DropdownMenuItem(
                          value: type,
                          child: Row(
                            children: [
                              Icon(
                                _getPropertyTypeIcon(type),
                                size: 16,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(type),
                            ],
                          ),
                        )).toList(),
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    title: const Text('Active Template'),
                    subtitle: const Text('Allow clients to import this template'),
                    value: _isActive,
                    onChanged: (value) {
                      setState(() {
                        _isActive = value ?? true;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info, color: Colors.blue[600], size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Next Steps',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[600],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'After creating this template, you can:',
                          style: TextStyle(color: Colors.blue[700]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '• Add departments (Cleaning, Kitchen, Maintenance, etc.)',
                          style: TextStyle(color: Colors.blue[700], fontSize: 13),
                        ),
                        Text(
                          '• Create master tasks for each role and department',
                          style: TextStyle(color: Colors.blue[700], fontSize: 13),
                        ),
                        Text(
                          '• Set up workflows and task dependencies',
                          style: TextStyle(color: Colors.blue[700], fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _isLoading ? null : _createMasterHotel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Create Template'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createMasterHotel() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // TODO: Replace with actual repository call
      await Future.delayed(const Duration(seconds: 1));

      final masterHotel = MasterHotelEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isActive: _isActive,
        propertyType: _selectedPropertyType,
        departments: [],
        tasks: [],
        totalImports: 0,
        activeImports: 0,
      );

      widget.onMasterHotelAdded(masterHotel);
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Master hotel template "${masterHotel.name}" created successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating master hotel: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  static const List<String> _propertyTypes = [
    'Luxury Hotel',
    'Business Hotel',
    'Boutique Hotel',
    'Resort',
    'Budget Hotel',
    'Extended Stay',
  ];

  IconData _getPropertyTypeIcon(String type) {
    switch (type) {
      case 'Luxury Hotel':
        return Icons.star;
      case 'Business Hotel':
        return Icons.business;
      case 'Boutique Hotel':
        return Icons.local_florist;
      case 'Resort':
        return Icons.beach_access;
      case 'Budget Hotel':
        return Icons.attach_money;
      case 'Extended Stay':
        return Icons.home;
      default:
        return Icons.hotel;
    }
  }
}
