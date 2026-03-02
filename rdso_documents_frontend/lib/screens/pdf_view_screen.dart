import 'package:flutter/material.dart';
import 'package:ux4g/ux4g.dart';

class PdfViewScreen extends StatelessWidget {
  const PdfViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Handling generic or map arguments
    final arg = ModalRoute.of(context)?.settings.arguments;
    String name = 'Document';
    String version = 'Current';

    if (arg is Map) {
      name = arg['name'] ?? name;
      version = arg['version'] ?? version;
    }

    return Ux4gScaffold(
      backgroundColor: Ux4gColors.gray100,
      appBar: Ux4gAppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: Ux4gTypography.sizeBody1, fontWeight: Ux4gTypography.weightBold),
            ),
            Text(
              '(\$version)',
              style: const TextStyle(fontSize: Ux4gTypography.sizeSmall, fontWeight: Ux4gTypography.weightRegular, color: Ux4gColors.gray600),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.picture_as_pdf, size: 80, color: Ux4gColors.gray400),
            const SizedBox(height: Ux4gSpacing.md),
            Text(
              'PDF Canvas Placeholder\\n(\$name)',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Ux4gColors.gray500,
                fontSize: Ux4gTypography.sizeH5,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(Ux4gSpacing.md),
        decoration: const BoxDecoration(
          color: Ux4gColors.white,
          border: Border(top: BorderSide(color: Ux4gColors.borderColor)),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Ux4gButton(
                  onPressed: () {},
                  variant: Ux4gButtonVariant.primary,
                  style: Ux4gButtonStyle.outline,
                  icon: const Icon(Icons.feedback),
                  child: const Text('Add Feedback'),
                ),
              ),
              const SizedBox(width: Ux4gSpacing.md),
              Expanded(
                child: Ux4gButton(
                  onPressed: () {},
                  variant: Ux4gButtonVariant.primary,
                  icon: const Icon(Icons.download),
                  child: const Text('Download'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
