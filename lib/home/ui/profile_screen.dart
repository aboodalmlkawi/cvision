import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cvision/core/constants/colors.dart';
import 'package:cvision/core/localization/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  String _displayName = "User";
  String _jobTitle = "Software Engineer";
  String _phone = "";
  String _linkedin = "";
  String _github = "";

  bool _isLoading = true;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }
  Future<void> _loadUserProfile() async {
    if (user == null) return;
    setState(() => _displayName = user?.displayName ?? "User");
    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();
      if (doc.exists && mounted) {
        final data = doc.data()!;
        setState(() {
          _jobTitle = data['jobTitle'] ?? "Software Engineer";
          _phone = data['phone'] ?? "";
          _linkedin = data['linkedin'] ?? "";
          _github = data['github'] ?? "";
        });
      }
    } catch (e) {
      debugPrint("Error loading profile: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile(String name, String job, String phone, String linkedin, String github) async {
    if (user == null) return;

    try {
      if (name.isNotEmpty && name != user!.displayName) {
        await user!.updateDisplayName(name);
      }
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'jobTitle': job,
        'phone': phone,
        'linkedin': linkedin,
        'github': github,
        'email': user!.email,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      setState(() {
        _displayName = name;
        _jobTitle = job;
        _phone = phone;
        _linkedin = linkedin;
        _github = github;
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile Updated Successfully! ✅"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error saving: $e"), backgroundColor: Colors.red),
        );
      }
    }
  }
  Future<void> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (image == null) return;
    setState(() => _isUploading = true);
    try {
      final storageRef = FirebaseStorage.instance.ref().child('user_profile_images').child('${user!.uid}.jpg');
      await storageRef.putFile(File(image.path));
      final String downloadUrl = await storageRef.getDownloadURL();
      await user!.updatePhotoURL(downloadUrl);
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'photoUrl': downloadUrl
      }, SetOptions(merge: true));
      setState(() {});
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Photo updated!"), backgroundColor: Colors.green));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    } finally {
      setState(() => _isUploading = false);
    }
  }
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(backgroundColor: AppColors.background, body: Center(child: CircularProgressIndicator(color: AppColors.primaryAccent)));
    }
    final currentUser = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          context.tr('profile') ?? "Profile",
          style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileImage(currentUser?.photoURL),
            const SizedBox(height: 15),
            Text(
              _displayName,
              style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
            ),
            Text(
              currentUser?.email ?? "",
              style: const TextStyle(color: Colors.white54, fontSize: 14, fontFamily: 'Cairo'),
            ),
            Text(
              _jobTitle,
              style: const TextStyle(color: AppColors.primaryAccent, fontSize: 14, fontFamily: 'Cairo'),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_linkedin.isNotEmpty) _buildSocialIcon(FontAwesomeIcons.linkedin, Colors.blue, _linkedin),
                if (_github.isNotEmpty) _buildSocialIcon(FontAwesomeIcons.github, Colors.white, _github),
                if (_phone.isNotEmpty) _buildSocialIcon(Icons.phone, Colors.green, "tel:$_phone"),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(child: _buildStatCard("3", "CVs Created", Icons.description)),
                const SizedBox(width: 15),
                Expanded(child: _buildStatCard("12", "Views", Icons.visibility)),
              ],
            ),
            const SizedBox(height: 30),
            _buildAIButton(),
            const SizedBox(height: 20),
            _buildOptionTile(
              context,
              icon: Icons.edit,
              title: "Edit Personal Info",
              subtitle: "Change name, title, links...",
              onTap: () => _showEditProfileDialog(context),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildSocialIcon(IconData icon, Color color, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
  Widget _buildProfileImage(String? photoUrl) {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryAccent, width: 2),
              boxShadow: [
                BoxShadow(color: AppColors.primaryAccent.withOpacity(0.3), blurRadius: 20, spreadRadius: 5),
              ],
              image: photoUrl != null
                  ? DecorationImage(image: NetworkImage(photoUrl), fit: BoxFit.cover)
                  : null,
            ),
            child: _isUploading
                ? const Center(child: CircularProgressIndicator(color: Colors.white))
                : (photoUrl == null ? const Icon(Icons.person, size: 60, color: Colors.white70) : null),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _isUploading ? null : _pickAndUploadImage,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: AppColors.primaryAccent, shape: BoxShape.circle),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildStatCard(String count, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryAccent, size: 28),
          const SizedBox(height: 10),
          Text(count, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12, fontFamily: 'Cairo')),
        ],
      ),
    );
  }
  Widget _buildAIButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: const Color(0xFF6A11CB).withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 5)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.auto_awesome, color: Colors.white, size: 28),
          SizedBox(width: 15),
          Text("Create CV with AI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Cairo')),
        ],
      ),
    );
  }

  Widget _buildOptionTile(BuildContext context, {required IconData icon, required String title, String? subtitle, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Cairo')),
        subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11, fontFamily: 'Cairo')) : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final nameController = TextEditingController(text: _displayName);
    final jobController = TextEditingController(text: _jobTitle);
    final phoneController = TextEditingController(text: _phone);
    final linkedinController = TextEditingController(text: _linkedin);
    final githubController = TextEditingController(text: _github);

    bool isSavingLocal = false;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (context, setStateDialog) {
              return Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E2C),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: AppColors.primaryAccent.withOpacity(0.5)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20)],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white10))),
                        child: const Text("Update Profile", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Cairo')),
                      ),
                      Flexible(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Basic Info", style: TextStyle(color: AppColors.primaryAccent, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              _buildModernTextField(nameController, "Full Name", Icons.person),
                              const SizedBox(height: 15),
                              _buildModernTextField(jobController, "Job Title", Icons.work),
                              const SizedBox(height: 25),
                              const Text("Contact & Socials", style: TextStyle(color: AppColors.primaryAccent, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              _buildModernTextField(phoneController, "Phone Number", Icons.phone, inputType: TextInputType.phone),
                              const SizedBox(height: 15),
                              _buildModernTextField(linkedinController, "LinkedIn URL", FontAwesomeIcons.linkedin),
                              const SizedBox(height: 15),
                              _buildModernTextField(githubController, "GitHub/Portfolio URL", FontAwesomeIcons.github),
                            ],
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15)),
                                child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: isSavingLocal
                                    ? null
                                    : () async {
                                  setStateDialog(() => isSavingLocal = true);
                                  await _saveProfile(
                                    nameController.text.trim(),
                                    jobController.text.trim(),
                                    phoneController.text.trim(),
                                    linkedinController.text.trim(),
                                    githubController.text.trim(),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryAccent,
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                ),
                                child: isSavingLocal
                                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                    : const Text("Save Changes", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        );
      },
    );
  }

  Widget _buildModernTextField(TextEditingController controller, String label, IconData icon, {TextInputType inputType = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF2A2A35), borderRadius: BorderRadius.circular(15)),
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey, size: 20),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}