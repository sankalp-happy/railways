import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ux4g/ux4g.dart';
import '../../services/admin_crawler_service.dart';

class CrawlerScreen extends StatefulWidget {
  const CrawlerScreen({super.key});

  @override
  State<CrawlerScreen> createState() => _CrawlerScreenState();
}

class _CrawlerScreenState extends State<CrawlerScreen> {
  final AdminCrawlerService _crawlerService = AdminCrawlerService();
  final ScrollController _logScrollController = ScrollController();
  Map<String, dynamic>? _status;
  bool _isLoading = false;
  String? _message;
  bool _isError = false;
  bool _showLogs = false;
  final List<String> _logLines = [];
  int _logOffset = 0;
  Timer? _logPollTimer;
  bool _crawlerRunning = false;

  @override
  void initState() {
    super.initState();
    _refreshStatus();
  }

  @override
  void dispose() {
    _logPollTimer?.cancel();
    _logScrollController.dispose();
    super.dispose();
  }

  Future<void> _refreshStatus() async {
    setState(() => _isLoading = true);
    final status = await _crawlerService.getCrawlerStatus();
    if (!mounted) return;
    setState(() {
      _status = status;
      _isLoading = false;
      _crawlerRunning = status['running'] == true;
    });
    if (_crawlerRunning) _startLogPolling();
  }

  void _startLogPolling() {
    _logPollTimer?.cancel();
    _logPollTimer = Timer.periodic(const Duration(seconds: 2), (_) => _fetchLogs());
    _fetchLogs();
  }

  void _stopLogPolling() {
    _logPollTimer?.cancel();
    _logPollTimer = null;
  }

  Future<void> _fetchLogs() async {
    final result = await _crawlerService.getCrawlerLogs(since: _logOffset);
    if (!mounted) return;
    final lines = (result['lines'] as List?)?.cast<String>() ?? [];
    final running = result['running'] == true;
    if (lines.isNotEmpty || running != _crawlerRunning) {
      setState(() {
        _logLines.addAll(lines);
        _logOffset = result['offset'] as int? ?? _logOffset;
        _crawlerRunning = running;
      });
      // Auto-scroll to bottom
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_logScrollController.hasClients) {
          _logScrollController.animateTo(
            _logScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });
    }
    if (!running) {
      _stopLogPolling();
      _refreshStatus();
    }
  }

  Future<void> _runCrawler() async {
    setState(() {
      _message = null;
      _isError = false;
      _logLines.clear();
      _logOffset = 0;
      _showLogs = true;
    });
    final result = await _crawlerService.runCrawler();
    if (!mounted) return;
    final started = result['status'] == 'started' || result['status'] == 'already_running';
    setState(() {
      _message = started ? 'Crawler started' : (result['error'] ?? 'Failed to start');
      _isError = !started;
      _crawlerRunning = started;
    });
    if (started) _startLogPolling();
  }

  Future<void> _importCatalog() async {
    setState(() {
      _message = null;
      _isError = false;
    });
    final result = await _crawlerService.importCatalog();
    if (!mounted) return;
    setState(() {
      _message = result['output'] ?? result['message'] ?? 'Done';
      _isError = result['status'] != 'ok';
    });
    _refreshStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Ux4gScaffold(
      appBar: Ux4gAppBar(
        title: const Text('RDSO Crawler'),
        actions: [
          if (_logLines.isNotEmpty || _crawlerRunning)
            IconButton(
              icon: Icon(_showLogs ? Icons.terminal : Icons.terminal),
              tooltip: _showLogs ? 'Hide logs' : 'Show logs',
              color: _showLogs ? Ux4gColors.primary : null,
              onPressed: () => setState(() => _showLogs = !_showLogs),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh status',
            onPressed: _refreshStatus,
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: _showLogs ? 1 : 1,
            child: _buildMainPanel(),
          ),
          if (_showLogs) ...[
            const VerticalDivider(width: 1),
            Expanded(
              flex: 1,
              child: _buildLogPanel(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMainPanel() {
    if (_isLoading && _status == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Ux4gSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_message != null)
            Padding(
              padding: const EdgeInsets.only(bottom: Ux4gSpacing.md),
              child: Ux4gAlert(
                variant: _isError ? Ux4gAlertVariant.danger : Ux4gAlertVariant.success,
                message: _message!,
              ),
            ),
          Ux4gCard(
            padding: const EdgeInsets.all(Ux4gSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Crawler Status',
                      style: TextStyle(
                        fontSize: Ux4gTypography.sizeH5,
                        fontWeight: Ux4gTypography.weightBold,
                      ),
                    ),
                    if (_crawlerRunning) ...[
                      const SizedBox(width: Ux4gSpacing.sm),
                      const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                      const SizedBox(width: Ux4gSpacing.xs),
                      const Text('Running', style: TextStyle(color: Ux4gColors.primary, fontSize: Ux4gTypography.sizeSmall)),
                    ],
                  ],
                ),
                const SizedBox(height: Ux4gSpacing.md),
                if (_status != null) ...[
                  _statusRow('Total files', '${_status!['total_files'] ?? '—'}'),
                  _statusRow('Total drawings', '${_status!['total_drawings'] ?? '—'}'),
                  _statusRow('Total categories', '${_status!['total_categories'] ?? '—'}'),
                  _statusRow('Total subheads', '${_status!['total_subheads'] ?? '—'}'),
                  _statusRow('Last crawled', '${_status!['last_run'] ?? '—'}'),
                ] else
                  const Text('No status available.', style: TextStyle(color: Ux4gColors.gray500)),
              ],
            ),
          ),
          const SizedBox(height: Ux4gSpacing.xl),
          Ux4gCard(
            padding: const EdgeInsets.all(Ux4gSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Actions',
                  style: TextStyle(fontSize: Ux4gTypography.sizeH5, fontWeight: Ux4gTypography.weightBold),
                ),
                const SizedBox(height: Ux4gSpacing.sm),
                const Text(
                  'Run the RDSO crawler to download new drawings, then import the catalog into the database.',
                  style: TextStyle(color: Ux4gColors.gray600, fontSize: Ux4gTypography.sizeBody2),
                ),
                const SizedBox(height: Ux4gSpacing.lg),
                Row(
                  children: [
                    Expanded(
                      child: Ux4gButton(
                        onPressed: _crawlerRunning ? null : _runCrawler,
                        variant: Ux4gButtonVariant.primary,
                        icon: const Icon(Icons.cloud_download),
                        child: Text(_crawlerRunning ? 'Running...' : 'Run Crawler'),
                      ),
                    ),
                    const SizedBox(width: Ux4gSpacing.md),
                    Expanded(
                      child: Ux4gButton(
                        onPressed: _crawlerRunning ? null : _importCatalog,
                        variant: Ux4gButtonVariant.success,
                        icon: const Icon(Icons.upload_file),
                        child: const Text('Import Catalog'),
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

  Widget _buildLogPanel() {
    return Container(
      color: const Color(0xFF1E1E1E),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Ux4gSpacing.md, vertical: Ux4gSpacing.sm),
            color: const Color(0xFF252526),
            child: Row(
              children: [
                const Icon(Icons.terminal, color: Colors.white70, size: 16),
                const SizedBox(width: Ux4gSpacing.xs),
                const Text(
                  'Crawler Logs',
                  style: TextStyle(color: Colors.white70, fontSize: Ux4gTypography.sizeSmall, fontWeight: Ux4gTypography.weightSemiBold),
                ),
                const Spacer(),
                if (_crawlerRunning)
                  const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 1.5, color: Colors.green)),
                const SizedBox(width: Ux4gSpacing.xs),
                Text(
                  '${_logLines.length} lines',
                  style: const TextStyle(color: Colors.white38, fontSize: Ux4gTypography.sizeSmall),
                ),
              ],
            ),
          ),
          Expanded(
            child: _logLines.isEmpty
                ? const Center(
                    child: Text(
                      'No log output yet.\nStart the crawler to see logs here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white38),
                    ),
                  )
                : ListView.builder(
                    controller: _logScrollController,
                    padding: const EdgeInsets.all(Ux4gSpacing.sm),
                    itemCount: _logLines.length,
                    itemBuilder: (context, index) {
                      final line = _logLines[index];
                      final isError = line.contains('ERR') || line.contains('Error') || line.contains('error');
                      final isWarn = line.contains('WARN') || line.contains('Warning');
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          line,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 12,
                            color: isError
                                ? const Color(0xFFF48771)
                                : isWarn
                                    ? const Color(0xFFCCA700)
                                    : const Color(0xFFCCCCCC),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _statusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Ux4gSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Ux4gColors.gray600)),
          Text(value, style: const TextStyle(fontWeight: Ux4gTypography.weightSemiBold)),
        ],
      ),
    );
  }
}
