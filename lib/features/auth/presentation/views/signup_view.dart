import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:grade3/features/auth/data/service/auth_service.dart';
import 'package:grade3/features/auth/logic/signup_cubit.dart';
import 'package:grade3/features/auth/logic/signup_state.dart';
import 'package:grade3/features/auth/presentation/views/widgets/custom_textfield.dart';
import 'package:grade3/features/auth/presentation/views/sendcode_view.dart';
import 'package:file_picker/file_picker.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  // Translator fields
  final TextEditingController _languagesController = TextEditingController();
  final TextEditingController _experienceYearsController =
      TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _typesController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isTranslator = false;
  File? _certificationsFile;
  File? _cvFile;
  String _certificationsFileName = '';
  String _cvFileName = '';

  // Profile and cover picture fields
  File? _profilePic;
  File? _coverPic;
  String _profilePicName = '';
  String _coverPicName = '';

  String _selectedGender = 'male';
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => SignupCubit(authService: AuthService()),
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state is SignupSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Signup successful!'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 1),
                ),
              );

              if (_isTranslator) {
                // Create translator profile after signup
                context.read<SignupCubit>().createTranslator(
                      email: _emailController.text,
                      certifications: _certificationsFile,
                      languages: _languagesController.text,
                      experienceYears: _experienceYearsController.text,
                      bio: _bioController.text,
                      types: _typesController.text,
                      cv: _cvFile,
                      location: _locationController.text,
                    );
              } else {
                // If not a translator, navigate directly to verification
                Future.delayed(const Duration(milliseconds: 800), () {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          SendCodeView(email: _emailController.text),
                    ),
                  );
                });
              }
            } else if (state is SignupError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is SignupRetrying) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      '${state.errorMessage} (Attempt ${state.currentAttempt}/${state.maxAttempts})'),
                  backgroundColor: Colors.orange,
                  duration: const Duration(seconds: 2),
                ),
              );
            } else if (state is TranslatorCreationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Translator profile created successfully!'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );

              // Navigate to verification after successful translator creation
              Future.delayed(const Duration(milliseconds: 800), () {
                // ignore: use_build_context_synchronously
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        SendCodeView(email: _emailController.text),
                  ),
                );
              });
            } else if (state is TranslatorCreationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Error creating translator profile: ${state.error}'),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );

              // Even if translator creation fails, still navigate to verification
              Future.delayed(const Duration(seconds: 3), () {
                // ignore: use_build_context_synchronously
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        SendCodeView(email: _emailController.text),
                  ),
                );
              });
            }
          },
          builder: (context, state) {
            final cubit = context.read<SignupCubit>();

            return Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF81D4FA), Colors.white],
                ),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // Header with back button
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios,
                                  color: Colors.black87),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  "Create Account",
                                  style: GoogleFonts.poppins(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 48), // Balance the header
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Form card
                      Container(
                        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Personal Information Section
                            Text(
                              "Personal Information",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Name field
                            CustomTextField(
                              controller: _nameController,
                              labelText: "Full Name",
                              hintText: "Enter your full name",
                              isPassword: false,
                            ),
                            const SizedBox(height: 16),

                            // Profile Picture
                            Text(
                              "Profile Picture",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['jpg', 'jpeg', 'png'],
                                );

                                if (result != null) {
                                  setState(() {
                                    _profilePic =
                                        File(result.files.single.path!);
                                    _profilePicName = result.files.single.name;
                                  });
                                }
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      // ignore: deprecated_member_use
                                      color: Colors.grey.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: _profilePic != null
                                            ? Colors.blue
                                            : Colors.transparent,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate,
                                          color: _profilePic != null
                                              ? Colors.blue
                                              : Colors.grey,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            _profilePic != null
                                                ? _profilePicName
                                                : "Upload your profile picture",
                                            style: GoogleFonts.poppins(
                                              color: _profilePic != null
                                                  ? Colors.black87
                                                  : Colors.grey,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (_profilePic != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          _profilePic!,
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Cover Picture
                            Text(
                              "Cover Picture",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['jpg', 'jpeg', 'png'],
                                );

                                if (result != null) {
                                  setState(() {
                                    _coverPic = File(result.files.single.path!);
                                    _coverPicName = result.files.single.name;
                                  });
                                }
                              },
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    decoration: BoxDecoration(
                                      // ignore: deprecated_member_use
                                      color: Colors.grey.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: _coverPic != null
                                            ? Colors.blue
                                            : Colors.transparent,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add_photo_alternate,
                                          color: _coverPic != null
                                              ? Colors.blue
                                              : Colors.grey,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            _coverPic != null
                                                ? _coverPicName
                                                : "Upload your cover picture",
                                            style: GoogleFonts.poppins(
                                              color: _coverPic != null
                                                  ? Colors.black87
                                                  : Colors.grey,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (_coverPic != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(
                                          _coverPic!,
                                          height: 100,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Email field
                            CustomTextField(
                              controller: _emailController,
                              labelText: "Email",
                              hintText: "Enter your email",
                              isPassword: false,
                            ),
                            const SizedBox(height: 16),

                            // Mobile field
                            CustomTextField(
                              controller: _mobileController,
                              labelText: "Mobile Number",
                              hintText: "Enter your mobile number",
                              isPassword: false,
                            ),
                            const SizedBox(height: 24),

                            // Gender selection - improved UI
                            Text(
                              "Gender",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedGender = 'male';
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: _selectedGender == 'male'
                                            // ignore: deprecated_member_use
                                            ? Colors.blue.withOpacity(0.1)
                                            // ignore: deprecated_member_use
                                            : Colors.grey.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: _selectedGender == 'male'
                                              ? Colors.blue
                                              : Colors.transparent,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.male,
                                            color: _selectedGender == 'male'
                                                ? Colors.blue
                                                : Colors.grey,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Male',
                                            style: GoogleFonts.poppins(
                                              color: _selectedGender == 'male'
                                                  ? Colors.blue
                                                  : Colors.grey,
                                              fontWeight:
                                                  _selectedGender == 'male'
                                                      ? FontWeight.w600
                                                      : FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedGender = 'female';
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      decoration: BoxDecoration(
                                        color: _selectedGender == 'female'
                                            // ignore: deprecated_member_use
                                            ? Colors.pink.withOpacity(0.1)
                                            // ignore: deprecated_member_use
                                            : Colors.grey.withOpacity(0.05),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: _selectedGender == 'female'
                                              ? Colors.pink
                                              : Colors.transparent,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.female,
                                            color: _selectedGender == 'female'
                                                ? Colors.pink
                                                : Colors.grey,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Female',
                                            style: GoogleFonts.poppins(
                                              color: _selectedGender == 'female'
                                                  ? Colors.pink
                                                  : Colors.grey,
                                              fontWeight:
                                                  _selectedGender == 'female'
                                                      ? FontWeight.w600
                                                      : FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Date of birth - improved UI
                            Text(
                              "Date of Birth",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: _selectedDate ??
                                      DateTime.now().subtract(
                                          const Duration(days: 365 * 18)),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime.now(),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                          primary: Colors.blue,
                                          onPrimary: Colors.white,
                                          surface: Colors.white,
                                          onSurface: Colors.black,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (picked != null) {
                                  setState(() {
                                    _selectedDate = picked;
                                    _dobController.text =
                                        "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  // ignore: deprecated_member_use
                                  color: Colors.grey.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: _selectedDate != null
                                        ? Colors.blue
                                        : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: _selectedDate != null
                                          ? Colors.blue
                                          : Colors.grey,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _selectedDate != null
                                            ? "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}"
                                            : "Select your birth date",
                                        style: GoogleFonts.poppins(
                                          color: _selectedDate != null
                                              ? Colors.black87
                                              : Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Translator checkbox
                            Row(
                              children: [
                                Checkbox(
                                  value: _isTranslator,
                                  onChanged: (value) {
                                    setState(() {
                                      _isTranslator = value ?? false;
                                    });
                                  },
                                  activeColor: Colors.blue,
                                ),
                                Text(
                                  "Register as a translator",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),

                            // Translator fields
                            if (_isTranslator) ...[
                              const SizedBox(height: 24),
                              Text(
                                "Translator Information",
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Languages field
                              CustomTextField(
                                controller: _languagesController,
                                labelText: "Languages",
                                hintText:
                                    "Enter languages you can translate (e.g., English, Arabic)",
                                isPassword: false,
                              ),
                              const SizedBox(height: 16),

                              // Experience years field
                              CustomTextField(
                                controller: _experienceYearsController,
                                labelText: "Experience Years",
                                hintText: "Enter your years of experience",
                                isNumber:
                                    true, // ⬅️ اجعلها true لقبول الأرقام فقط
                              ),

                              const SizedBox(height: 16),

                              // Bio field
                              CustomTextField(
                                controller: _bioController,
                                labelText: "Bio",
                                hintText: "Enter a short bio about yourself",
                                isPassword: false,
                                maxLines: 3,
                              ),
                              const SizedBox(height: 16),

                              // Types field
                              Text(
                                "Translation Type",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  // ignore: deprecated_member_use
                                  color: Colors.grey.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Colors.blue.withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    isExpanded: true,
                                    value: _typesController.text.isEmpty
                                        ? null
                                        : _typesController.text,
                                    hint: Text(
                                      "Select translation type",
                                      style: GoogleFonts.poppins(
                                          color: Colors.grey),
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: "editorial",
                                        child: Text("Editorial"),
                                      ),
                                      DropdownMenuItem(
                                        value: "immediate",
                                        child: Text("Immediate"),
                                      ),
                                      DropdownMenuItem(
                                        value: "emergency",
                                        child: Text("Emergency"),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        _typesController.text = value ?? '';
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Location field
                              CustomTextField(
                                controller: _locationController,
                                labelText: "Location",
                                hintText: "Enter your location",
                                isPassword: false,
                              ),
                              const SizedBox(height: 16),

                              // Certifications file picker
                              Text(
                                "Certifications (PDF)",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['pdf'],
                                  );

                                  if (result != null) {
                                    setState(() {
                                      _certificationsFile =
                                          File(result.files.single.path!);
                                      _certificationsFileName =
                                          result.files.single.name;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    // ignore: deprecated_member_use
                                    color: Colors.grey.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: _certificationsFile != null
                                          ? Colors.blue
                                          : Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.upload_file,
                                        color: _certificationsFile != null
                                            ? Colors.blue
                                            : Colors.grey,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _certificationsFile != null
                                              ? _certificationsFileName
                                              : "Upload your certifications (PDF)",
                                          style: GoogleFonts.poppins(
                                            color: _certificationsFile != null
                                                ? Colors.black87
                                                : Colors.grey,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // CV file picker
                              Text(
                                "CV (PDF)",
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () async {
                                  FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['pdf'],
                                  );

                                  if (result != null) {
                                    setState(() {
                                      _cvFile = File(result.files.single.path!);
                                      _cvFileName = result.files.single.name;
                                    });
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    // ignore: deprecated_member_use
                                    color: Colors.grey.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: _cvFile != null
                                          ? Colors.blue
                                          : Colors.transparent,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.upload_file,
                                        color: _cvFile != null
                                            ? Colors.blue
                                            : Colors.grey,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          _cvFile != null
                                              ? _cvFileName
                                              : "Upload your CV (PDF)",
                                          style: GoogleFonts.poppins(
                                            color: _cvFile != null
                                                ? Colors.black87
                                                : Colors.grey,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],

                            const SizedBox(height: 24),

                            // Security Section
                            Text(
                              "Security",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Password field
                            CustomTextField(
                              controller: _passwordController,
                              labelText: "Password",
                              hintText: "Enter your password",
                              isPassword: true,
                            ),
                            const SizedBox(height: 16),

                            // Confirm Password field
                            CustomTextField(
                              controller: _confirmPasswordController,
                              labelText: "Confirm Password",
                              hintText: "Confirm your password",
                              isPassword: true,
                            ),
                            const SizedBox(height: 32),

                            // Signup button
                            state is SignupLoading || state is SignupRetrying
                                ? Center(
                                    child: Column(
                                      children: [
                                        const CircularProgressIndicator(),
                                        if (state is SignupRetrying)
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              'Retrying... (${state.currentAttempt}/${state.maxAttempts})',
                                              style: GoogleFonts.poppins(
                                                color: Colors.orange,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  )
                                : SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_validateInputs()) {
                                          if (_isTranslator) {
                                            final type =
                                                _typesController.text.trim();
                                            final experienceYears =
                                                int.tryParse(
                                                    _experienceYearsController
                                                        .text
                                                        .trim());

                                            if (type.isEmpty ||
                                                ![
                                                  "editorial",
                                                  "immediate",
                                                  "emergency"
                                                ].contains(type) ||
                                                experienceYears == null) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'Please enter valid translation type and experience years'),
                                                ),
                                              );
                                              return;
                                            }
                                          }

                                          // Proceed with signup
                                          cubit.signup(
                                            name: _nameController.text.trim(),
                                            email: _emailController.text.trim(),
                                            password:
                                                _passwordController.text.trim(),
                                            confirmPassword:
                                                _confirmPasswordController.text
                                                    .trim(),
                                            mobileNumber:
                                                _mobileController.text.trim(),
                                            gender: _selectedGender,
                                            dob: _dobController.text.trim(),
                                            profilePic: _profilePic,
                                            coverPic: _coverPic,
                                            type: _isTranslator
                                                ? _typesController.text.trim()
                                                : '',
                                            experienceYears: _isTranslator
                                                ? int.tryParse(
                                                        _experienceYearsController
                                                            .text
                                                            .trim()) ??
                                                    0
                                                : 0,
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        elevation: 3,
                                      ),
                                      child: Text(
                                        "Create Account",
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),

                      // Login link
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: GoogleFonts.poppins(color: Colors.black54),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Login",
                                style: GoogleFonts.poppins(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  bool _validateInputs() {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty ||
        _mobileController.text.isEmpty ||
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    // Validate translator fields if checkbox is checked
    if (_isTranslator) {
      if (_languagesController.text.isEmpty ||
          _experienceYearsController.text.isEmpty ||
          _bioController.text.isEmpty ||
          _typesController.text.isEmpty ||
          !["editorial", "immediate", "emergency"]
              .contains(_typesController.text) ||
          _locationController.text.isEmpty ||
          _certificationsFile == null ||
          _cvFile == null) {
        // Show specific error message for type field
        if (_typesController.text.isEmpty ||
            !["editorial", "immediate", "emergency"]
                .contains(_typesController.text)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Please select a valid translation type (editorial, immediate, or emergency)'),
              backgroundColor: Colors.red,
            ),
          );
          return false;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Please fill in all translator fields and upload required documents'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    }

    return true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _mobileController.dispose();
    _dobController.dispose();
    _languagesController.dispose();
    _experienceYearsController.dispose();
    _bioController.dispose();
    _typesController.dispose();
    _locationController.dispose();
    // No need to dispose File objects as they don't have dispose methods
    super.dispose();
  }
}
