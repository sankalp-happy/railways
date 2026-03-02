import 'package:flutter/material.dart';
import 'package:ux4g/ux4g.dart';

Ux4gSidebar buildAppDrawer(BuildContext context) {
  return Ux4gSidebar(
      header: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: Ux4gSpacing.lg, vertical: Ux4gSpacing.xl),
        color: Ux4gColors.primary.withValues(alpha: 0.1),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Ux4gColors.primary,
              child: Icon(Icons.person, color: Ux4gColors.white),
            ),
            const SizedBox(width: Ux4gSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'HRMS ID: 12345678',
                  style: TextStyle(
                    fontWeight: Ux4gTypography.weightBold,
                    fontSize: Ux4gTypography.sizeBody1,
                  ),
                ),
                Text(
                  'RDSO Employee',
                  style: TextStyle(
                    color: Ux4gColors.gray600,
                    fontSize: Ux4gTypography.sizeSmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      footer: Padding(
        padding: const EdgeInsets.all(Ux4gSpacing.md),
        child: Ux4gButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
          variant: Ux4gButtonVariant.danger,
          style: Ux4gButtonStyle.outline,
          isFullWidth: true,
          icon: const Icon(Icons.logout),
          child: const Text('Logout'),
        ),
      ),
      children: [
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: const Icon(Icons.architecture, color: Ux4gColors.gray600),
            title: const Text('Bridges & Structures',
                style: TextStyle(fontSize: Ux4gTypography.sizeBody1)),
            childrenPadding: const EdgeInsets.only(left: Ux4gSpacing.xl),
            children: [
              Ux4gSidebarItem(
                title: 'Current',
                icon: const Icon(Icons.file_copy),
                onTap: () {
                  Navigator.pushNamed(context, '/results', arguments: 'Bridges & Structures - Current');
                },
              ),
              Ux4gSidebarItem(
                title: 'Archive',
                icon: const Icon(Icons.archive),
                onTap: () {
                  Navigator.pushNamed(context, '/results', arguments: 'Bridges & Structures - Archive');
                },
              ),
            ],
          ),
        ),
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: const Icon(Icons.train, color: Ux4gColors.gray600),
            title: const Text('Track Design',
                style: TextStyle(fontSize: Ux4gTypography.sizeBody1)),
            childrenPadding: const EdgeInsets.only(left: Ux4gSpacing.xl),
            children: [
              Ux4gSidebarItem(
                title: 'Current',
                icon: const Icon(Icons.file_copy),
                onTap: () {
                  Navigator.pushNamed(context, '/results', arguments: 'Track Design - Current');
                },
              ),
            ],
          ),
        ),
        Ux4gSidebarItem(
          title: 'All Documents',
          icon: const Icon(Icons.folder),
          onTap: () {
            Navigator.pushNamed(context, '/results', arguments: 'All Documents');
          },
        ),
      ],
    );
}
