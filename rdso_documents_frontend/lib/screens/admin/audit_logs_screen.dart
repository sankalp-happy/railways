import 'package:flutter/material.dart';
import 'package:ux4g/ux4g.dart';
import '../../models/audit_log.dart';
import '../../services/admin_service.dart';
import '../../utils/date_utils.dart' as app_dates;

class AuditLogsScreen extends StatefulWidget {
  const AuditLogsScreen({super.key});

  @override
  State<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends State<AuditLogsScreen> with SingleTickerProviderStateMixin {
  final AdminService _adminService = AdminService();
  late TabController _tabController;
  List<AuditLog> _documentLogs = [];
  List<AuditLog> _userLogs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLogs();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadLogs() async {
    setState(() => _isLoading = true);
    final results = await Future.wait([
      _adminService.getDocumentLogs(),
      _adminService.getUserLogs(),
    ]);
    if (!mounted) return;
    setState(() {
      _documentLogs = results[0];
      _userLogs = results[1];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Ux4gScaffold(
      backgroundColor: Ux4gColors.gray100,
      appBar: Ux4gAppBar(
        title: const Text('Audit Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLogs,
            tooltip: 'Refresh',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Ux4gColors.primary,
          unselectedLabelColor: Ux4gColors.gray600,
          indicatorColor: Ux4gColors.primary,
          tabs: [
            Tab(text: 'Documents (${_documentLogs.length})'),
            Tab(text: 'Users (${_userLogs.length})'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildLogList(_documentLogs),
                _buildLogList(_userLogs),
              ],
            ),
    );
  }

  Widget _buildLogList(List<AuditLog> logs) {
    if (logs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Ux4gColors.gray400),
            SizedBox(height: Ux4gSpacing.md),
            Text('No logs found', style: TextStyle(color: Ux4gColors.gray500)),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadLogs,
      child: ListView.separated(
        padding: const EdgeInsets.all(Ux4gSpacing.md),
        itemCount: logs.length,
        separatorBuilder: (_, __) => const SizedBox(height: Ux4gSpacing.xs),
        itemBuilder: (context, index) => _buildLogCard(logs[index]),
      ),
    );
  }

  Widget _buildLogCard(AuditLog log) {
    final icon = switch (log.action) {
      'user_login' => Icons.login,
      'user_status_change' => Icons.admin_panel_settings,
      'document_create' => Icons.note_add,
      'document_view' => Icons.visibility,
      'post_create' => Icons.comment,
      'batch_action' => Icons.playlist_add_check,
      _ => Icons.info_outline,
    };

    final color = switch (log.action) {
      'user_login' => Ux4gColors.info,
      'user_status_change' => Ux4gColors.warning,
      'document_create' => Ux4gColors.success,
      'document_view' => Ux4gColors.primary,
      'post_create' => Colors.teal,
      'batch_action' => Colors.deepPurple,
      _ => Ux4gColors.gray600,
    };

    return Ux4gCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withValues(alpha: 0.12),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: Ux4gSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      log.actionLabel,
                      style: const TextStyle(
                        fontWeight: Ux4gTypography.weightSemiBold,
                        fontSize: Ux4gTypography.sizeBody2,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatDateTime(log.createdAt),
                      style: const TextStyle(color: Ux4gColors.gray500, fontSize: Ux4gTypography.sizeSmall),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'By: ${log.userHrmsId ?? "System"}',
                  style: const TextStyle(fontSize: Ux4gTypography.sizeSmall, color: Ux4gColors.gray600),
                ),
                if (log.targetId.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Target: ${log.targetType} / ${log.targetId}',
                    style: const TextStyle(fontSize: Ux4gTypography.sizeSmall, color: Ux4gColors.gray600),
                  ),
                ],
                if (log.metadata.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(Ux4gSpacing.xs),
                    decoration: BoxDecoration(
                      color: Ux4gColors.gray100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      log.metadata.entries.map((e) => '${e.key}: ${e.value}').join(', '),
                      style: const TextStyle(fontSize: 11, color: Ux4gColors.gray600, fontFamily: 'monospace'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    return app_dates.formatDate(dt);
  }
}
