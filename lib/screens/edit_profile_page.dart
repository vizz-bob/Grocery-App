import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

import '../theme/bhejdu_colors.dart';
import '../widgets/top_app_bar.dart';

class EditProfilePage extends StatefulWidget {
  final Map userData;

  const EditProfilePage({
    required this.userData,
    super.key,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController phoneCtrl;

  File? imageFile;
  bool isLoading = false;

  int? userId;

  @override
  void initState() {
    super.initState();
    loadUserId();

    nameCtrl = TextEditingController(text: widget.userData["name"] ?? "");
    emailCtrl = TextEditingController(text: widget.userData["email"] ?? "");
    phoneCtrl = TextEditingController(text: widget.userData["mobile"] ?? "");
  }

  /// FETCH LOGGED-IN USER ID
  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt("user_id");
  }

  /// PICK IMAGE
  Future pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        imageFile = File(picked.path);
      });
    }
  }

  /// UPDATE PROFILE API
  Future updateProfile() async {
    setState(() => isLoading = true);

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(
        "https://darkslategrey-chicken-274271.hostingersite.com/api/update_profile_with_image.php",
      ),
    );

    request.fields["id"] = userId.toString();
    request.fields["name"] = nameCtrl.text.trim();
    request.fields["email"] = emailCtrl.text.trim();
    request.fields["mobile"] = phoneCtrl.text.trim();

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath("image", imageFile!.path),
      );
    }

    final response = await request.send();

    setState(() => isLoading = false);

    if (response.statusCode == 200 && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile Updated Successfully!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Update failed!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BhejduColors.bgLight,
      body: Column(
        children: [
          BhejduAppBar(
            title: "Edit Profile",
            showBack: true,
            onBackTap: () => Navigator.pop(context),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  /// PROFILE IMAGE
                  GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: BhejduColors.primaryBlueLight,
                      backgroundImage: imageFile != null
                          ? FileImage(imageFile!)
                          : widget.userData["profile_image"] != null &&
                          widget.userData["profile_image"] != ""
                          ? NetworkImage(
                        "https://darkslategrey-chicken-274271.hostingersite.com/uploads/${widget.userData["profile_image"]}",
                      ) as ImageProvider
                          : null,
                      child: imageFile == null &&
                          (widget.userData["profile_image"] == null ||
                              widget.userData["profile_image"] == "")
                          ? const Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: Colors.blue,
                      )
                          : null,
                    ),
                  ),

                  const SizedBox(height: 25),

                  /// INPUT FIELDS
                  buildInput("Full Name", nameCtrl, Icons.person),
                  const SizedBox(height: 15),

                  buildInput("Email Address", emailCtrl, Icons.email),
                  const SizedBox(height: 15),

                  buildInput("Phone Number", phoneCtrl, Icons.phone),

                  const SizedBox(height: 30),

                  /// SAVE BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BhejduColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text(
                        "Save Changes",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// CUSTOM TEXT FIELD WIDGET
  Widget buildInput(
      String label,
      TextEditingController controller,
      IconData icon, {
        int maxLines = 1,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: BhejduColors.textDark,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: BhejduColors.borderLight),
          ),
          child: Row(
            children: [
              Icon(icon, color: BhejduColors.primaryBlue, size: 22),
              const SizedBox(width: 12),

              Expanded(
                child: TextField(
                  controller: controller,
                  maxLines: maxLines,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
