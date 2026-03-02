import 'package:flutter/material.dart';
import 'package:ux4g/ux4g.dart';

class CategoryResultsScreen extends StatelessWidget {
  const CategoryResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String title = ModalRoute.of(context)?.settings.arguments as String? ?? 'Results';

    return Ux4gScaffold(
      appBar: Ux4gAppBar(
        title: Text(title),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(Ux4gSpacing.md),
        itemCount: 5,
        separatorBuilder: (context, index) => const SizedBox(height: Ux4gSpacing.md),
        itemBuilder: (context, index) {
          final isArchive = index == 4;
          return Ux4gCard(
            padding: const EdgeInsets.all(Ux4gSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Document Name $index',
                        style: const TextStyle(
                          fontWeight: Ux4gTypography.weightBold,
                          fontSize: Ux4gTypography.sizeBody1,
                        ),
                      ),
                      const SizedBox(height: Ux4gSpacing.xs),
                      Text(
                        'Drawing No: RDSO/DOC/202$index',
                        style: const TextStyle(
                          color: Ux4gColors.gray600,
                          fontSize: Ux4gTypography.sizeSmall,
                        ),
                      ),
                      const SizedBox(height: Ux4gSpacing.xs),
                      Ux4gBadge(
                        label: isArchive ? 'Archive' : 'Current v1.$index',
                        variant: isArchive ? Ux4gAlertVariant.warning : Ux4gAlertVariant.success,
                      ),
                    ],
                  ),
                ),
                // Action Buttons on Right
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Ux4gIconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: () {
                        Navigator.pushNamed(context, '/pdf', 
                            arguments: {'name': 'Document Name $index', 'version': isArchive ? 'Archive' : 'v1.$index'});
                      },
                      variant: Ux4gButtonVariant.primary,
                      style: Ux4gButtonStyle.ghost,
                    ),
                    const SizedBox(height: Ux4gSpacing.xs),
                    Ux4gIconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () {
                        // Implement download logic
                      },
                      variant: Ux4gButtonVariant.success,
                      style: Ux4gButtonStyle.ghost,
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
