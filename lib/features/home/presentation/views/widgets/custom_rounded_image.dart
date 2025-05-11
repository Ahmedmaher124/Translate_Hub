import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grade3/constents.dart';

class CustomRoundedImage extends StatelessWidget {
  const CustomRoundedImage({
    super.key,
    this.width,
    this.imageUrl,
    this.imageFile,
    this.onTap,
    this.isCompanyLogo = false,
  });
  final double? width;
  final String? imageUrl;
  final File? imageFile;
  final VoidCallback? onTap;
  final bool isCompanyLogo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width ?? MediaQuery.sizeOf(context).width * 0.13,
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: _buildImageWidget(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    if (imageFile != null) {
      // Use local file image if available
      return Image.file(
        imageFile!,
        fit: BoxFit.cover,
      );
    } else if (imageUrl != null && imageUrl!.isNotEmpty) {
      // Use network image if URL is available and valid
      if (imageUrl!.contains('http')) {
        return CachedNetworkImage(
          imageUrl: imageUrl!,
          errorWidget: (context, url, error) => _buildDefaultProfileImage(),
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          fit: BoxFit.cover,
        );
      } else {
        // Fallback to default if URL is invalid
        return _buildDefaultProfileImage();
      }
    } else {
      // Fallback to default profile image
      return _buildDefaultProfileImage();
    }
  }

  Widget _buildDefaultProfileImage() {
    final defaultImage =
        isCompanyLogo ? defaultCompanyLogo : defaultProfileImage;

    return Image.asset(
      defaultImage,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // If default image asset fails, show a plain icon
        return Container(
          color: Colors.grey.shade200,
          child: Icon(
            isCompanyLogo ? Icons.business : Icons.person,
            color: isCompanyLogo ? Colors.blueGrey : Colors.blue,
            size: 40,
          ),
        );
      },
    );
  }
}
