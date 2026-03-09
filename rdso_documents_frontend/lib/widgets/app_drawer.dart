import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ux4g/ux4g.dart';
import '../services/auth_service.dart';
import '../models/category.dart';

Ux4gSidebar buildAppDrawer(BuildContext context, {List<Category> categories = const []}) {
  final auth = context.read<AuthService>();
  final user = auth.currentUser;
  final isAdmin = auth.isAdmin;

  return Ux4gSidebar(
      header: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: Ux4gSpacing.lg, vertical: Ux4gSpacing.xl),
        color: Ux4gColors.primary.withValues(alpha: 0.1),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: isAdmin ? Ux4gColors.warning : Ux4gColors.primary,
              child: Icon(
                isAdmin ? Icons.admin_panel_settings : Icons.person,
                color: Ux4gColors.white,
              ),
            ),
            const SizedBox(width: Ux4gSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'HRMS ID: ${user?.hrmsId ?? "—"}',
                  style: const TextStyle(
                    fontWeight: Ux4gTypography.weightBold,
                    fontSize: Ux4gTypography.sizeBody1,
                  ),
                ),
                Text(
                  isAdmin ? 'Administrator' : 'RDSO Employee',
                  style: TextStyle(
                    color: isAdmin ? Ux4gColors.warning : Ux4gColors.gray600,
                    fontSize: Ux4gTypography.sizeSmall,
                    fontWeight: isAdmin ? Ux4gTypography.weightSemiBold : Ux4gTypography.weightRegular,
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
          onPressed: () async {
            await auth.logout();
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, '/login');
            }
          },
          variant: Ux4gButtonVariant.danger,
          style: Ux4gButtonStyle.outline,
          isFullWidth: true,
          icon: const Icon(Icons.logout),
          child: const Text('Logout'),
        ),
      ),
      children: [
        ...categories.map((cat) => Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: Icon(_iconForCategory(cat.name), color: Ux4gColors.gray600),
            title: Text(cat.name,
                style: const TextStyle(fontSize: Ux4gTypography.sizeBody1)),
            childrenPadding: const EdgeInsets.only(left: Ux4gSpacing.xl),
            children: [
              Ux4gSidebarItem(
                title: 'All',
                icon: const Icon(Icons.file_copy),
                onTap: () {
                  Navigator.pushNamed(context, '/results', arguments: cat.name);
                },
              ),
            ],
          ),
        )),
        Ux4gSidebarItem(
          title: 'All Documents',
          icon: const Icon(Icons.folder),
          onTap: () {
            Navigator.pushNamed(context, '/results', arguments: 'All Documents');
          },
        ),
        if (isAdmin) ...[
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Ux4gSpacing.lg, vertical: Ux4gSpacing.xs),
            child: Text(
              'ADMIN',
              style: TextStyle(
                fontSize: Ux4gTypography.sizeSmall,
                fontWeight: Ux4gTypography.weightBold,
                color: Ux4gColors.warning.withValues(alpha: 0.8),
                letterSpacing: 1.2,
              ),
            ),
          ),
          Ux4gSidebarItem(
            title: 'User Management',
            icon: const Icon(Icons.people),
            onTap: () => Navigator.pushNamed(context, '/admin/users'),
          ),
          Ux4gSidebarItem(
            title: 'Create Document',
            icon: const Icon(Icons.note_add),
            onTap: () => Navigator.pushNamed(context, '/admin/create-document', arguments: categories),
          ),
          Ux4gSidebarItem(
            title: 'Audit Logs',
            icon: const Icon(Icons.history),
            onTap: () => Navigator.pushNamed(context, '/admin/logs'),
          ),
        ],
      ],
    );
}

IconData _iconForCategory(String name) {
  final lower = name.toLowerCase();
  if (lower.contains('bridge') || lower.contains('structure')) return Icons.architecture;
  if (lower.contains('track')) return Icons.train;
  if (lower.contains('signal')) return Icons.traffic;
  if (lower.contains('electr')) return Icons.electrical_services;
  if (lower.contains('rolling')) return Icons.directions_railway;
  return Icons.category;
}
