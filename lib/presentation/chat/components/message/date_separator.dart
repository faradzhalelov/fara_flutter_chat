// lib/presentation/chat/components/date_separator.dart
import 'package:fara_chat/app/theme/text_styles.dart';
import 'package:fara_chat/core/utils/extensions/date_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSeparator extends StatelessWidget {

  const DateSeparator({
    required this.date, super.key,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Colors.grey.shade300,
              thickness: 0.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              _formatDate(date),
              style: AppTextStyles.extraSmall.copyWith(color:Colors.grey.shade500),
            
            ),
          ),
          Expanded(
            child: Divider(
              color: Colors.grey.shade300,
              thickness: 0.5,
            ),
          ),
        ],
      ),
    );

  String _formatDate(DateTime date) {
    
    if (date.isToday()) {
      return 'Сегодня';
    } else if (date.isYesterday()) {
      return 'Вчера';
    } else {
      // Format like "27.01.22" as shown in the design
      return DateFormat('dd.MM.yy').format(date);
    }
  }
}