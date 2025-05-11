import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grade3/core/utils/get_responsive_font_size.dart';
import 'package:grade3/features/user_account/data/models/user_profile_model.dart';
import 'package:grade3/features/user_account/logic/user_profile_cubit.dart';

class EditProfileView extends StatefulWidget {
  final UserProfileModel userProfile;

  const EditProfileView({
    super.key,
    required this.userProfile,
  });

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _dobController;
  late final TextEditingController _bioController;
  late final TextEditingController _locationController;
  late final TextEditingController _experienceYearsController;

  String _selectedGender = '';
  final List<String> _selectedTypes = [];
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Available translator types
  final List<String> _translatorTypes = ['immediate', 'emergency', 'editorial'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userProfile.name);
    _emailController = TextEditingController(text: widget.userProfile.email);
    _phoneController =
        TextEditingController(text: widget.userProfile.mobileNumber);
    _dobController =
        TextEditingController(text: _formatDate(widget.userProfile.dob));
    _bioController = TextEditingController(text: widget.userProfile.bio ?? '');
    _locationController =
        TextEditingController(text: widget.userProfile.location ?? '');
    _experienceYearsController = TextEditingController(
        text: widget.userProfile.experienceYears?.toString() ?? '0');

    _selectedGender = widget.userProfile.gender;

    // Initialize selected types
    if (widget.userProfile.types != null &&
        widget.userProfile.types!.isNotEmpty) {
      _selectedTypes.addAll(widget.userProfile.types!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _experienceYearsController.dispose();
    super.dispose();
  }

  String _formatDate(String dateString) {
    if (dateString.isEmpty) return '';

    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return '';
    }
  }

  DateTime? _parseDate(String formattedDate) {
    if (formattedDate.isEmpty) return null;

    try {
      final parts = formattedDate.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? initialDate;
    if (_dobController.text.isNotEmpty) {
      initialDate = _parseDate(_dobController.text);
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dobController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  void _toggleTypeSelection(String type) {
    setState(() {
      if (_selectedTypes.contains(type)) {
        _selectedTypes.remove(type);
      } else {
        _selectedTypes.add(type);
      }
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Parse the date from DD/MM/YYYY to YYYY-MM-DD for API
      String formattedDob = '';
      if (_dobController.text.isNotEmpty) {
        final dateTime = _parseDate(_dobController.text);
        if (dateTime != null) {
          formattedDob =
              '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
        }
      }

      // Parse experience years
      int? experienceYears;
      if (_experienceYearsController.text.isNotEmpty) {
        experienceYears = int.tryParse(_experienceYearsController.text) ?? 0;
      }

      // Ensure location is not empty
      String location = _locationController.text;
      if (location.isEmpty) {
        location = 'Not specified';
      }

      // Update profile using the cubit
      final success = await context.read<UserProfileCubit>().updateUserProfile(
            name: _nameController.text,
            mobileNumber: _phoneController.text,
            gender: _selectedGender,
            dob: formattedDob,
            bio: _bioController.text,
            location: location,
            experienceYears: experienceYears,
            types: _selectedTypes,
          );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(
              context, true); // Return true to indicate profile was updated
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update profile'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _saveProfile,
            icon: const Icon(Icons.check, color: Colors.blue),
            tooltip: 'Save changes',
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProfileHeader(),
                      _buildSectionCard(
                        title: 'Personal Information',
                        children: [
                          _buildTextField(
                            controller: _nameController,
                            labelText: 'Full Name',
                            prefixIcon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _emailController,
                            labelText: 'Email Address',
                            prefixIcon: Icons.email_outlined,
                            enabled: false, // Email cannot be changed
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _phoneController,
                            labelText: 'Mobile Number',
                            prefixIcon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 16),
                          _buildDateField(
                            controller: _dobController,
                            labelText: 'Date of Birth',
                            prefixIcon: Icons.calendar_today_outlined,
                            onTap: () => _selectDate(context),
                          ),
                          const SizedBox(height: 20),
                          _buildGenderSelection(),
                        ],
                      ),
                      _buildSectionCard(
                        title: 'Translator Information',
                        children: [
                          _buildTextField(
                            controller: _bioController,
                            labelText: 'Bio',
                            prefixIcon: Icons.description_outlined,
                            maxLines: 3,
                            hintText: 'Tell us about yourself...',
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _locationController,
                            labelText: 'Location',
                            prefixIcon: Icons.location_on_outlined,
                            hintText: 'City, Country',
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _experienceYearsController,
                            labelText: 'Experience (Years)',
                            prefixIcon: Icons.work_outline,
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 20),
                          _buildTypeSelection(),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildSaveButton(),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.person,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Edit Your Profile',
            style: TextStyle(
              fontSize: getResponsiveFontSize(context, baseFontSize: 22),
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Update your information',
            style: TextStyle(
              fontSize: getResponsiveFontSize(context, baseFontSize: 14),
              color: Colors.blue.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: getResponsiveFontSize(context, baseFontSize: 18),
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
              ),
            ),
            const Divider(height: 30),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    bool enabled = true,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
    String? hintText,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
        ),
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey.shade50,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: Icon(prefixIcon, color: Colors.blue),
            suffixIcon: const Icon(Icons.calendar_month, color: Colors.blue),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue.shade400, width: 2),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(
            fontSize: getResponsiveFontSize(context, baseFontSize: 16),
            fontWeight: FontWeight.w500,
            color: Colors.blue.shade800,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildGenderOption('male', 'Male', Icons.male),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildGenderOption('female', 'Female', Icons.female),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(String value, String label, IconData icon) {
    final isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = value;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.grey,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue.shade700 : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Translator Type',
          style: TextStyle(
            fontSize: getResponsiveFontSize(context, baseFontSize: 16),
            fontWeight: FontWeight.w500,
            color: Colors.blue.shade800,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children:
              _translatorTypes.map((type) => _buildTypeOption(type)).toList(),
        ),
      ],
    );
  }

  Widget _buildTypeOption(String type) {
    final isSelected = _selectedTypes.contains(type);
    final String displayName =
        type.substring(0, 1).toUpperCase() + type.substring(1);

    // Choose icon based on type
    IconData getIconForType() {
      switch (type) {
        case 'immediate':
          return Icons.access_time;
        case 'emergency':
          return Icons.warning_amber;
        case 'editorial':
          return Icons.edit_document;
        default:
          return Icons.translate;
      }
    }

    return GestureDetector(
      onTap: () => _toggleTypeSelection(type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              getIconForType(),
              color: isSelected ? Colors.blue : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              displayName,
              style: TextStyle(
                color: isSelected ? Colors.blue.shade700 : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save, size: 24),
            SizedBox(width: 12),
            Text(
              'Save Changes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
