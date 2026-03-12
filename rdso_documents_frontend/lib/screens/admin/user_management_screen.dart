import 'package:flutter/material.dart';
import 'package:ux4g/ux4g.dart';
import '../../models/user.dart';
import '../../services/admin_service.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> with SingleTickerProviderStateMixin {
  final AdminService _adminService = AdminService();
  late TabController _tabController;
  List<User> _users = [];
  bool _isLoading = true;
  String? _activeFilter;

  final _filters = [null, 'pending', 'accepted', 'rejected'];
  final _filterLabels = ['All', 'Pending', 'Accepted', 'Rejected'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _activeFilter = _filters[_tabController.index];
        _loadUsers();
      }
    });
    _loadUsers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    final users = await _adminService.getRegistrations(filter: _activeFilter);
    if (!mounted) return;
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  Future<void> _updateStatus(User user, String newStatus) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${newStatus == 'accepted' ? 'Accept' : 'Reject'} User'),
        content: Text('Change ${user.hrmsId} status to "$newStatus"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: newStatus == 'accepted' ? Colors.green : Colors.red,
            ),
            child: Text(newStatus == 'accepted' ? 'Accept' : 'Reject'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final result = await _adminService.updateUserStatus(user.hrmsId, newStatus);
    if (!mounted) return;

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${user.hrmsId} has been $newStatus')),
      );
      _loadUsers();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update user status')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Ux4gScaffold(
      backgroundColor: Ux4gColors.gray100,
      appBar: Ux4gAppBar(
        title: const Text('User Management'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Ux4gColors.primary,
          unselectedLabelColor: Ux4gColors.gray600,
          indicatorColor: Ux4gColors.primary,
          tabs: _filterLabels.map((l) => Tab(text: l)).toList(),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.people_outline, size: 64, color: Ux4gColors.gray400),
                      const SizedBox(height: Ux4gSpacing.md),
                      Text(
                        'No ${_activeFilter ?? ''} users found',
                        style: const TextStyle(color: Ux4gColors.gray500),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadUsers,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(Ux4gSpacing.md),
                    itemCount: _users.length,
                    separatorBuilder: (_, __) => const SizedBox(height: Ux4gSpacing.sm),
                    itemBuilder: (context, index) => _buildUserCard(_users[index]),
                  ),
                ),
    );
  }

  Widget _buildUserCard(User user) {
    final statusColor = switch (user.userStatus) {
      'accepted' => Ux4gColors.success,
      'rejected' => Ux4gColors.danger,
      _ => Ux4gColors.warning,
    };

    return Ux4gCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: statusColor.withValues(alpha: 0.15),
                child: Icon(Icons.person, color: statusColor),
              ),
              const SizedBox(width: Ux4gSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.hrmsId,
                      style: const TextStyle(
                        fontWeight: Ux4gTypography.weightBold,
                        fontSize: Ux4gTypography.sizeBody1,
                      ),
                    ),
                    if (user.email != null)
                      Text(user.email!, style: const TextStyle(color: Ux4gColors.gray600, fontSize: Ux4gTypography.sizeSmall)),
                    if (user.phoneNumber != null)
                      Text(user.phoneNumber!, style: const TextStyle(color: Ux4gColors.gray600, fontSize: Ux4gTypography.sizeSmall)),
                  ],
                ),
              ),
              Ux4gBadge(
                label: user.userStatus.toUpperCase(),
                variant: switch (user.userStatus) {
                  'accepted' => Ux4gAlertVariant.success,
                  'rejected' => Ux4gAlertVariant.danger,
                  _ => Ux4gAlertVariant.warning,
                },
              ),
            ],
          ),
          if (user.userStatus == 'pending') ...[
            const SizedBox(height: Ux4gSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Ux4gButton(
                  onPressed: () => _updateStatus(user, 'rejected'),
                  variant: Ux4gButtonVariant.danger,
                  style: Ux4gButtonStyle.outline,
                  size: Ux4gButtonSize.sm,
                  icon: const Icon(Icons.close, size: 16),
                  child: const Text('Reject'),
                ),
                const SizedBox(width: Ux4gSpacing.sm),
                Ux4gButton(
                  onPressed: () => _updateStatus(user, 'accepted'),
                  variant: Ux4gButtonVariant.success,
                  size: Ux4gButtonSize.sm,
                  icon: const Icon(Icons.check, size: 16),
                  child: const Text('Accept'),
                ),
              ],
            ),
          ],
          if (user.userStatus == 'accepted') ...[
            const SizedBox(height: Ux4gSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Ux4gButton(
                  onPressed: () => _updateStatus(user, 'rejected'),
                  variant: Ux4gButtonVariant.danger,
                  style: Ux4gButtonStyle.outline,
                  size: Ux4gButtonSize.sm,
                  icon: const Icon(Icons.block, size: 16),
                  child: const Text('Revoke'),
                ),
              ],
            ),
          ],
          if (user.userStatus == 'rejected') ...[
            const SizedBox(height: Ux4gSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Ux4gButton(
                  onPressed: () => _updateStatus(user, 'accepted'),
                  variant: Ux4gButtonVariant.success,
                  style: Ux4gButtonStyle.outline,
                  size: Ux4gButtonSize.sm,
                  icon: const Icon(Icons.restore, size: 16),
                  child: const Text('Re-accept'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
