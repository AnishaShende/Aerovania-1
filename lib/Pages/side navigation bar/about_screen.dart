import 'package:aerovania_app_1/Pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  void initState() {
    super.initState();
  }

  final _controller = SidebarXController(selectedIndex: 5, extended: true);
  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        drawer: ExampleSidebarX(controller: _controller),
        backgroundColor: const Color(0xffbfe0f8),
        appBar: AppBar(
          title: const Text(
            "About",
            style: TextStyle(
                color: Colors.black, fontSize: 25, fontWeight: FontWeight.w500),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 1,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'About Us',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Aerovania Innovations dynamically works on the scientific research and development of reliable products in Aerospace industry. We are working on futuristic projects related to hybrid vehicles, security systems and drone advancements. We are also looking forward for emerging as a trustworthy and efficient partner for all Aerospace Enterprises across the world.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Meet our Expert Team',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTeamMember(
                    name: 'Smitesh Chinchore',
                    title: 'Co-Founder & Cheif Technology Officer',
                    imageUrl: 'assets/images/applogo.png',
                  ),
                  _buildTeamMember(
                    name: 'Gaurav Rahangdale',
                    title: 'Co-Founder & Cheif Marketing Officer',
                    imageUrl: 'assets/images/applogo.png',
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTeamMember(
                    name: 'Nitesh Khajuria',
                    title: 'Co-Founder & Cheif Finance Officer',
                    imageUrl: 'assets/images/applogo.png',
                  ),
                  _buildTeamMember(
                    name: 'Himanshu Tripathi',
                    title: 'Co-Founder & Cheif Operating Officer',
                    imageUrl: 'assets/images/applogo.png',
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'For press inquiries or general questions, please contact us at https://aerovania.com/.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMember({
    required String name,
    required String title,
    required String imageUrl,
  }) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          radius: 30,
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
