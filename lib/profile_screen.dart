import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sign_in_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  /// 🔹 Load name saved specifically for this user
  Future<void> _loadUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('name_${user.email}') ?? "User";
    });
  }

  /// 🔹 Save name locally for this user's email
  Future<void> _saveUserName(String name) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name_${user.email}', name);
    setState(() => _userName = name);
  }

  /// 🔹 Dialog for changing name
  void _editNameDialog() {
    final controller = TextEditingController(text: _userName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Change Your Name"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: "Enter new name",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                _saveUserName(newName);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Name updated successfully")),
                );
              }
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 1,
      ),
      body: user == null
          ? _buildGuestView(context)
          : _buildProfileView(context, user),
    );
  }

  /// 🧑‍💼 Signed-in User View
  Widget _buildProfileView(BuildContext context, User user) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Profile Header
        Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: user.photoURL != null
                  ? NetworkImage(user.photoURL!)
                  : const AssetImage('assets/images/profile_placeholder.png')
              as ImageProvider,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _userName ?? "User",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: _editNameDialog,
                      ),
                    ],
                  ),
                  Text(
                    user.email ?? "No Email Found",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Options List
        _buildOption(context,
            icon: Icons.shopping_bag_outlined, title: 'My Orders', onTap: () {}),
        _buildOption(context,
            icon: Icons.location_on_outlined,
            title: 'Address Book',
            onTap: () {}),
        _buildOption(context,
            icon: Icons.payment_outlined,
            title: 'Payment Methods',
            onTap: () {}),
        _buildOption(context,
            icon: Icons.favorite_border, title: 'Wishlist', onTap: () {}),
        _buildOption(context,
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            onTap: () {}),
        _buildOption(context,
            icon: Icons.support_agent_outlined,
            title: 'Contact Support',
            onTap: () {}),
        _buildOption(context,
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            )),
        const Divider(height: 32),

        // Sign Out Button
        ElevatedButton.icon(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Logged out successfully')),
            );
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SignInScreen()),
              );
            }
          },
          icon: const Icon(Icons.logout),
          label: const Text('Sign Out'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            minimumSize: const Size.fromHeight(50),
          ),
        ),
      ],
    );
  }

  /// 🚪 Guest View (for non-logged-in users)
  Widget _buildGuestView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_outline, size: 80, color: Colors.grey),
            const SizedBox(height: 20),
            const Text("You are not signed in",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("Sign in to manage your profile and orders.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignInScreen()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              ),
              child: const Text("Sign In",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  /// Common Option Tile
  Widget _buildOption(BuildContext context,
      {required IconData icon,
        required String title,
        required VoidCallback onTap}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
          title: Text(title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}
