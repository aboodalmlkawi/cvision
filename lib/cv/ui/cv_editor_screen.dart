import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cvision/cv/data/models/cv_model.dart';
import 'package:cvision/cv/logic/cv_controller.dart';
import 'package:cvision/core/ui/glass_widgets.dart';

class CVEditorScreen extends ConsumerStatefulWidget {
  final CVModel? cvToEdit;
  final String? templateId;

  const CVEditorScreen({super.key, this.cvToEdit, this.templateId});

  @override
  ConsumerState<CVEditorScreen> createState() => _CVEditorScreenState();
}

class _CVEditorScreenState extends ConsumerState<CVEditorScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TabController _tabController;
  late String _currentTemplateId;

  late TextEditingController _fullNameController;
  late TextEditingController _jobTitleController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _summaryController;
  late TextEditingController _linkedinController;

  List<Experience> _experiences = [];
  List<Education> _educations = [];
  List<String> _skills = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _currentTemplateId = (widget.cvToEdit?.templateId ?? widget.templateId ?? 'modern').trim().toLowerCase();

    _fullNameController = TextEditingController(text: widget.cvToEdit?.personalInfo.fullName ?? "");
    _jobTitleController = TextEditingController(text: widget.cvToEdit?.personalInfo.jobTitle ?? "");
    _emailController = TextEditingController(text: widget.cvToEdit?.personalInfo.email ?? "");
    _phoneController = TextEditingController(text: widget.cvToEdit?.personalInfo.phone ?? "");
    _summaryController = TextEditingController(text: widget.cvToEdit?.personalInfo.summary ?? "");
    _linkedinController = TextEditingController(text: widget.cvToEdit?.personalInfo.linkedin ?? "");

    _experiences = List.from(widget.cvToEdit?.experience ?? []);
    _educations = List.from(widget.cvToEdit?.education ?? []);
    _skills = List.from(widget.cvToEdit?.skills ?? []);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fullNameController.dispose();
    _jobTitleController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _summaryController.dispose();
    _linkedinController.dispose();
    super.dispose();
  }

  Future<void> _saveCV() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login required", style: TextStyle(fontFamily: 'Cairo'))));
      return;
    }

    final newCV = CVModel(
      id: widget.cvToEdit?.id ?? const Uuid().v4(),
      userId: user.uid,
      templateId: _currentTemplateId,
      title: _fullNameController.text.isEmpty ? "My CV" : "${_fullNameController.text} CV",
      personalInfo: PersonalInfo(
        fullName: _fullNameController.text.trim(),
        jobTitle: _jobTitleController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        summary: _summaryController.text.trim(),
        linkedin: _linkedinController.text.trim(),
        photoUrl: widget.cvToEdit?.personalInfo.photoUrl,
      ),
      education: _educations,
      experience: _experiences,
      skills: _skills,
      languages: widget.cvToEdit?.languages ?? [],
      createdAt: widget.cvToEdit?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    try {
      await ref.read(cvControllerProvider.notifier).saveCV(newCV);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor: Colors.green, content: Text("Saved! ✅")));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.cvToEdit != null ? "Edit CV" : "New $_currentTemplateId CV", style: const TextStyle(fontFamily: 'Cairo', color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
              icon: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Colors.purpleAccent, shape: BoxShape.circle), child: const Icon(Icons.check, size: 20, color: Colors.white)),
              onPressed: _saveCV
          ),
          const SizedBox(width: 10),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.purpleAccent,
          tabs: const [Tab(text: "INFO"), Tab(text: "EXP"), Tab(text: "EDU"), Tab(text: "SKILLS")],
        ),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: AnimatedBackgroundEditor()),
          Form(
            key: _formKey,
            child: TabBarView(
              controller: _tabController,
              children: [_buildPersonalInfoTab(), _buildExperienceTab(), _buildEducationTab(), _buildSkillsTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 180, 20, 100),
      children: [
        GlassTextField(label: "Full Name", controller: _fullNameController, icon: Icons.person),
        GlassTextField(label: "Job Title", controller: _jobTitleController, icon: Icons.work),
        GlassTextField(label: "Email", controller: _emailController, icon: Icons.email, keyboardType: TextInputType.emailAddress),
        GlassTextField(label: "Phone", controller: _phoneController, icon: Icons.phone, keyboardType: TextInputType.phone),
        GlassTextField(label: "LinkedIn", controller: _linkedinController, icon: Icons.link),
        GlassTextField(label: "Summary", controller: _summaryController, maxLines: 5),
      ],
    );
  }

  Widget _buildExperienceTab() => _buildListSection(_experiences, _addExperienceDialog, "Add Experience");
  Widget _buildEducationTab() => _buildListSection(_educations, _addEducationDialog, "Add Education");

  Widget _buildListSection(List items, VoidCallback onAdd, String label) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 180, 20, 20),
            itemCount: items.length,
            itemBuilder: (ctx, i) => GlassContainer(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              child: ListTile(
                title: Text(items[i] is Experience ? items[i].jobTitle : items[i].schoolName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent), onPressed: () => setState(() => items.removeAt(i))),
              ),
            ),
          ),
        ),
        Padding(padding: const EdgeInsets.all(20), child: ElevatedButton(onPressed: onAdd, style: ElevatedButton.styleFrom(backgroundColor: Colors.purpleAccent, minimumSize: const Size(double.infinity, 50)), child: Text(label, style: const TextStyle(color: Colors.white)))),
      ],
    );
  }

  Widget _buildSkillsTab() {
    final skillController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 180, 20, 20),
      child: Column(
        children: [
          Row(children: [
            Expanded(child: GlassTextField(label: "Skill", controller: skillController)),
            IconButton(icon: const Icon(Icons.add_circle, color: Colors.purpleAccent, size: 40), onPressed: () { if (skillController.text.isNotEmpty) setState(() => _skills.add(skillController.text.trim())); skillController.clear(); })
          ]),
          Expanded(child: Wrap(spacing: 10, children: _skills.map((s) => Chip(
            label: Text(s, style: const TextStyle(color: Colors.white)),
            backgroundColor: Colors.purpleAccent.withOpacity(0.2),
            onDeleted: () => setState(() => _skills.remove(s)),
            // ✅ تم تصحيح هنا: استخدام side بدلاً من border
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: Colors.purpleAccent)),
          )).toList())),
        ],
      ),
    );
  }

  void _showGlassDialog(String title, List<Widget> children, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C).withOpacity(0.9),
        // ✅ تم تصحيح هنا: استخدام side بدلاً من border
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.white10)),
        title: Text(title, style: const TextStyle(color: Colors.white, fontFamily: 'Cairo')),
        content: Column(mainAxisSize: MainAxisSize.min, children: children),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")), ElevatedButton(onPressed: onConfirm, child: const Text("Add"))],
      ),
    );
  }

  void _addExperienceDialog() {
    final comp = TextEditingController(), job = TextEditingController();
    _showGlassDialog("Experience", [GlassTextField(label: "Company", controller: comp), GlassTextField(label: "Job", controller: job)], () {
      setState(() => _experiences.add(Experience(companyName: comp.text, jobTitle: job.text, description: "", startDate: "", endDate: "")));
      Navigator.pop(context);
    });
  }

  void _addEducationDialog() {
    final school = TextEditingController(), deg = TextEditingController();
    _showGlassDialog("Education", [GlassTextField(label: "School", controller: school), GlassTextField(label: "Degree", controller: deg)], () {
      setState(() => _educations.add(Education(schoolName: school.text, degree: deg.text, startDate: "", endDate: "")));
      Navigator.pop(context);
    });
  }
}

class AnimatedBackgroundEditor extends StatelessWidget {
  const AnimatedBackgroundEditor({super.key});
  @override
  Widget build(BuildContext context) => Container(decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF1A1A1D), Color(0xFF2A2A35)], begin: Alignment.topLeft, end: Alignment.bottomRight)));
}