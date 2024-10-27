import 'package:certificate/components/pdf_viewer.dart';
import 'package:certificate/components/sidebar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Row(
        children: [
          PdfViewer(),
          Sidebar(),
        ],
      ),
    );
  }
}
