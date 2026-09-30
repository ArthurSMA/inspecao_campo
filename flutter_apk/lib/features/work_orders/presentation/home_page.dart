import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Column(children: [HeaderWidget()])),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu_rounded,
              size: 32,
              color: Colors.black87,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),

          const Expanded(
            child: Text(
              'Inspeção de Campo',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF004B93),
              ),
            ),
          ),

          const Icon(
            Icons.person_rounded, 
            size: 32,
          ),
        ],
      ),
    );
  }
}

class CardsWidget extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
