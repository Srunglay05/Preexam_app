import 'package:flutter/material.dart';

class PromoCard extends StatelessWidget {
  const PromoCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(color: Colors.black, thickness: 1),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Improve your self-study\nby using Prexam",
                  style: TextStyle(
                    fontSize: 26,
                    fontFamily: 'Teacher',
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Flexible(
                child: Image.asset(
                  "assets/images/logoA.png",
                  height: 150,
                  fit: BoxFit.contain, // removed width
                ),
              ),
            ],
          ),
          const Divider(color: Colors.black, thickness: 1),
        ],
      ),
    );
  }
}
