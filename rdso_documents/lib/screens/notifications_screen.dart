import 'package:flutter/material.dart';
import 'package:ux4g/ux4g.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Ux4gScaffold(
      appBar: Ux4gAppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(Ux4gSpacing.md),
        itemCount: 5,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final isNew = index < 2;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: Ux4gSpacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: isNew 
                      ? Ux4gColors.primary.withValues(alpha: 0.1) 
                      : Ux4gColors.gray100,
                  child: Icon(
                    isNew ? Icons.new_releases : Icons.update,
                    color: isNew ? Ux4gColors.primary : Ux4gColors.gray600,
                  ),
                ),
                const SizedBox(width: Ux4gSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Ux4gColors.black,
                            fontSize: Ux4gTypography.sizeBody1,
                          ),
                          children: [
                            TextSpan(
                              text: isNew ? 'New file added ' : 'Document revised ',
                              style: const TextStyle(fontWeight: Ux4gTypography.weightBold),
                            ),
                            TextSpan(
                              text: 'for "Standard Span Drawing $index"',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Ux4gSpacing.xs),
                      Text(
                        '\${index + 1} hours ago',
                        style: const TextStyle(
                          color: Ux4gColors.gray500,
                          fontSize: Ux4gTypography.sizeSmall,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
