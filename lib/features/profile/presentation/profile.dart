import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade800,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/avatar.png',
                  fit: BoxFit.cover,
                  width: 100, // width should be 2 * radius
                  height: 100, // height should be 2 * radius
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Username
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            // Email
            const Text(
              'john.doe@example.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),
            // Profile Options
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text(
                'Account Settings',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Navigate to Account Settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment, color: Colors.white),
              title: const Text(
                'Payment Methods',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Navigate to Payment Methods
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications, color: Colors.white),
              title: const Text(
                'Notification Settings',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Navigate to Notification Settings
              },
            ),
            ListTile(
              leading: const Icon(Icons.help, color: Colors.white),
              title: const Text(
                'Help & Support',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Navigate to Help & Support
              },
            ),
            const Spacer(),
            // Logout Button
            ElevatedButton(
              onPressed: () {
                // Handle logout
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red, // Text color
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
