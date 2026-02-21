import 'package:flutter/material.dart';
import 'package:ux4g/ux4g.dart';
import '../widgets/app_drawer.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Ux4gScaffold(
      sidebar: buildAppDrawer(context),
      appBar: Ux4gAppBar(
        title: const Text(
          'Home Dashboard',
          style: TextStyle(
            fontSize: Ux4gTypography.sizeH4,
            fontWeight: Ux4gTypography.weightBold,
            color: Ux4gColors.black,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Ux4gSpacing.sm),
            child: IconButton(
              icon: const Icon(Icons.notifications),
              color: Ux4gColors.primary,
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Full-width search bar
          Container(
            padding: const EdgeInsets.all(Ux4gSpacing.md),
            color: Ux4gColors.white,
            child: Ux4gTextField(
              hint: 'Search documents by name, drawing no...',
              prefixIcon: const Icon(Icons.search),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  Navigator.pushNamed(context, '/results', arguments: 'Search: $value');
                }
              },
            ),
          ),
          const Divider(height: 1),
          // Scrollable vertical list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(Ux4gSpacing.md),
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: Ux4gSpacing.sm, left: Ux4gSpacing.xs),
                  child: Text(
                    'Recently Viewed',
                    style: TextStyle(
                      fontSize: Ux4gTypography.sizeH5,
                      fontWeight: Ux4gTypography.weightSemiBold,
                    ),
                  ),
                ),
                _buildDocumentCard(
                    context, 'Standard Span Drawing', 'RDSO/B&S/2023/12', 'v2.1', '2 days ago'),
                const SizedBox(height: Ux4gSpacing.sm),
                _buildDocumentCard(
                    context, 'Track Tolerances Specs', 'RDSO/T/2021/04', 'v1.0', '1 week ago'),
                const SizedBox(height: Ux4gSpacing.sm),
                _buildDocumentCard(
                    context, 'Signaling Relay Manual', 'RDSO/Sig/1999/11', 'Archive', '2 weeks ago'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(
      BuildContext context, String name, String number, String version, String date) {
    return Ux4gCard(
      onTap: () {
        Navigator.pushNamed(context, '/pdf', arguments: {'name': name, 'version': version});
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.picture_as_pdf, color: Ux4gColors.danger, size: 40),
          const SizedBox(width: Ux4gSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: Ux4gTypography.weightSemiBold,
                    fontSize: Ux4gTypography.sizeBody1,
                  ),
                ),
                const SizedBox(height: Ux4gSpacing.xxs),
                Text(
                  'Drawing No: $number',
                  style: const TextStyle(
                    color: Ux4gColors.gray600,
                    fontSize: Ux4gTypography.sizeSmall,
                  ),
                ),
                const SizedBox(height: Ux4gSpacing.xs),
                Row(
                  children: [
                    Ux4gBadge(
                      label: version,
                      variant: version == 'Archive' ? Ux4gAlertVariant.warning : Ux4gAlertVariant.success,
                    ),
                    const Spacer(),
                    Text(
                      date,
                      style: const TextStyle(
                        color: Ux4gColors.gray500,
                        fontSize: Ux4gTypography.sizeSmall,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
