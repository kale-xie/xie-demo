import 'package:flutter/material.dart';


class NaviPage extends StatefulWidget {
  const NaviPage({super.key});

  @override
  State<NaviPage> createState() => _NaviPageState();
}

class _NaviPageState extends State<NaviPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(child: Text('你好啊！'),),
    );
  }
}