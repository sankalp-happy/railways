import 'package:flutter/material.dart';
import 'package:ux4g/ux4g.dart';
import '../services/notification_service.dart';
import '../models/audit_log.dart';
import '../utils/date_utils.dart' as app_dates;

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notificationService = NotificationService();
  List<AuditLog> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    final notifications = await _notificationService.getNotifications();
    if (!mounted) return;
    setState(() {
      _notifications = notifications;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Ux4gScaffold(
      appBar: Ux4gAppBar(
        title: const Text('Notifications'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? const Center(child: Text('No notifications'))
              : ListView.separated(
                  padding: const EdgeInsets.all(Ux4gSpacing.md),
                  itemCount: _notifications.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final log = _notifications[index];
                    final isNew = index < 3;
                    final docName = log.metadata['name'] ?? log.targetId;

                    return Semantics(
                      label: '${log.actionLabel} for $docName, ${app_dates.formatTimeAgo(log.createdAt)}',
                      child: ExcludeSemantics(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: Ux4gSpacing.sm),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: isNew
                                    ? Ux4gColors.primary.withValues(alpha: 0.1)
                                    : Ux4gColors.gray100,
                                child: Icon(
                                  _iconForAction(log.action),
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
                                            text: '${log.actionLabel} ',
                                            style: const TextStyle(fontWeight: Ux4gTypography.weightBold),
                                          ),
                                          TextSpan(text: 'for "$docName"'),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: Ux4gSpacing.xs),
                                    Text(
                                      app_dates.formatTimeAgo(log.createdAt),
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
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  IconData _iconForAction(String action) {
    switch (action) {
      case 'document_create':
        return Icons.new_releases;
      case 'document_available':
        return Icons.new_releases;
      case 'document_view':
        return Icons.visibility;
      case 'post_create':
        return Icons.chat;
      default:
        return Icons.update;
    }
  }
}
