import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cvision/core/constants/colors.dart';
import 'package:cvision/core/localization/app_localizations.dart';
import 'package:cvision/core/ui/skeleton_card.dart';
import 'package:cvision/home/ui/home_bottom_bar.dart';
import 'package:cvision/settings/ui/settings_screen.dart';
import 'package:cvision/home/ui/profile_screen.dart';
import 'package:cvision/home/logic/home_controller.dart';
import 'package:cvision/home/ui/cv_card_widget.dart';
import 'package:cvision/home/ui/empty_state.dart';
import 'package:cvision/cv/ui/template_selection_screen.dart';
import 'package:cvision/cv/ui/cv_editor_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  bool _isSearching = false;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final List<Widget> _pages = [
      _buildHomeView(user),
      const TemplateSelectionScreen(),
      const ProfileScreen(),
      const SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const Positioned.fill(child: AnimatedBackground()),
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
        ],
      ),

      appBar: _currentIndex == 0 ? _buildHomeAppBar(user) : null,
      bottomNavigationBar: HomeBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (index != 0) {
              _isSearching = false;
              _searchQuery = "";
              _searchController.clear();
              FocusScope.of(context).unfocus();
            }
          });
        },
        onAddPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CVEditorScreen(),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildHomeAppBar(User? user) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 80,
      title: _isSearching
          ? FadeIn(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white10)
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            style: const TextStyle(color: Colors.white, fontFamily: 'Cairo'),
            decoration: const InputDecoration(
              hintText: "Search your CVs...",
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.white38, fontFamily: 'Cairo'),
              icon: Icon(Icons.search, color: Colors.white38),
            ),
            onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
          ),
        ),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Welcome Back 👋",
              style: TextStyle(fontSize: 14, color: Colors.white70, fontFamily: 'Cairo')),
          const SizedBox(height: 4),
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.white, Color(0xFF64B5F6)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds),
            child: Text(
              user?.displayName ?? "User",
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Cairo'
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
          ),
          onPressed: () => setState(() {
            _isSearching = !_isSearching;
            if (!_isSearching) {
              _searchQuery = "";
              _searchController.clear();
            }
          }),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  Widget _buildHomeView(User? user) {
    final cvsAsync = ref.watch(homeCVsProvider);
    return cvsAsync.when(
      data: (cvs) {
        final filteredCvs = cvs.where((cv) => cv.title.toLowerCase().contains(_searchQuery) || cv.personalInfo.fullName.toLowerCase().contains(_searchQuery)).toList();
        if (cvs.isEmpty) {
          return Center(
            child: EmptyState(
                onCreate: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CVEditorScreen())
                )
            ),
          );
        }
        if (filteredCvs.isEmpty && _isSearching) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search_off, size: 80, color: Colors.white10),
                const SizedBox(height: 20),
                Text(
                  "No results found for '$_searchQuery'",
                  style: const TextStyle(color: Colors.white54, fontFamily: 'Cairo'),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 120, 20, 100),
          itemCount: filteredCvs.length,
          itemBuilder: (context, index) => FadeInUp(
            duration: const Duration(milliseconds: 500),
            delay: Duration(milliseconds: index * 100),
            child: CVCardWidget(cv: filteredCvs[index]),
          ),
        );
      },
      loading: () => ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 120, 20, 100),
        itemCount: 3,
        separatorBuilder: (ctx, index) => const SizedBox(height: 15),
        itemBuilder: (ctx, index) => const SkeletonCard(),
      ),
      error: (err, stack) => Center(
          child: Text("Error: $err", style: const TextStyle(color: Colors.red))
      ),
    );
  }
}

class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _topAlignment;
  late Animation<Alignment> _bottomAlignment;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 15))..repeat(reverse: true);

    _topAlignment = TweenSequence<Alignment>([
      TweenSequenceItem(tween: Tween(begin: Alignment.topLeft, end: Alignment.topRight), weight: 1),
      TweenSequenceItem(tween: Tween(begin: Alignment.topRight, end: Alignment.bottomRight), weight: 1),
      TweenSequenceItem(tween: Tween(begin: Alignment.bottomRight, end: Alignment.bottomLeft), weight: 1),
      TweenSequenceItem(tween: Tween(begin: Alignment.bottomLeft, end: Alignment.topLeft), weight: 1),
    ]).animate(_controller);

    _bottomAlignment = TweenSequence<Alignment>([
      TweenSequenceItem(tween: Tween(begin: Alignment.bottomRight, end: Alignment.bottomLeft), weight: 1),
      TweenSequenceItem(tween: Tween(begin: Alignment.bottomLeft, end: Alignment.topLeft), weight: 1),
      TweenSequenceItem(tween: Tween(begin: Alignment.topLeft, end: Alignment.topRight), weight: 1),
      TweenSequenceItem(tween: Tween(begin: Alignment.topRight, end: Alignment.bottomRight), weight: 1),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: const [Color(0xFF1E1E2C), Color(0xFF23233E)],
              begin: _topAlignment.value,
              end: _bottomAlignment.value,
            ),
          ),
        );
      },
    );
  }
}