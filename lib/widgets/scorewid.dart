import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../controllers/max_value_input_formatter.dart';

class SubjectCard extends StatefulWidget {
  final String title;
  final int max;
  final IconData icon;
  final RxString value;

  const SubjectCard({
    super.key,
    required this.title,
    required this.max,
    required this.icon,
    required this.value,
  });

  @override
  State<SubjectCard> createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.value.value);

    controller.addListener(() {
      widget.value.value = controller.text;
    });
  }

  @override
  void didUpdateWidget(covariant SubjectCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (controller.text != widget.value.value) {
      controller.text = widget.value.value;
      controller.selection = TextSelection.collapsed(
        offset: controller.text.length,
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),

        // ✅ CARD SHADOW
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(widget.icon, color: Colors.blue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontFamily: 'Teacher',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Max: ${widget.max}',
            style: const TextStyle(
              color: Colors.blueGrey,
              fontFamily: 'Teacher',
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              MaxValueInputFormatter(widget.max),
            ],
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}
