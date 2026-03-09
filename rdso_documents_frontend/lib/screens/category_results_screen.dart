import 'package:flutter/material.dart';
import 'package:ux4g/ux4g.dart';
import '../services/document_service.dart';
import '../models/document.dart';

class CategoryResultsScreen extends StatefulWidget {
  const CategoryResultsScreen({super.key});

  @override
  State<CategoryResultsScreen> createState() => _CategoryResultsScreenState();
}

class _CategoryResultsScreenState extends State<CategoryResultsScreen> {
  final DocumentService _documentService = DocumentService();
  List<Document> _documents = [];
  bool _isLoading = true;
  String _title = 'Results';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _title = ModalRoute.of(context)?.settings.arguments as String? ?? 'Results';
    _loadDocuments();
  }

  Future<void> _loadDocuments() async {
    setState(() => _isLoading = true);

    List<Document> docs;
    if (_title.startsWith('Search: ')) {
      final query = _title.substring(8);
      docs = await _documentService.searchDocuments(query);
    } else if (_title == 'All Documents') {
      docs = await _documentService.getDocuments();
    } else {
      docs = await _documentService.getDocumentsByCategory(_title);
    }

    if (!mounted) return;
    setState(() {
      _documents = docs;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Ux4gScaffold(
      appBar: Ux4gAppBar(
        title: Text(_title),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _documents.isEmpty
              ? const Center(child: Text('No documents found'))
              : ListView.separated(
                  padding: const EdgeInsets.all(Ux4gSpacing.md),
                  itemCount: _documents.length,
                  separatorBuilder: (context, index) => const SizedBox(height: Ux4gSpacing.md),
                  itemBuilder: (context, index) {
                    final doc = _documents[index];
                    final isArchive = doc.version.toLowerCase() == 'archive';
                    return Ux4gCard(
                      padding: const EdgeInsets.all(Ux4gSpacing.md),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doc.name,
                                  style: const TextStyle(
                                    fontWeight: Ux4gTypography.weightBold,
                                    fontSize: Ux4gTypography.sizeBody1,
                                  ),
                                ),
                                const SizedBox(height: Ux4gSpacing.xs),
                                Text(
                                  'Drawing No: ${doc.documentId}',
                                  style: const TextStyle(
                                    color: Ux4gColors.gray600,
                                    fontSize: Ux4gTypography.sizeSmall,
                                  ),
                                ),
                                const SizedBox(height: Ux4gSpacing.xs),
                                Ux4gBadge(
                                  label: isArchive ? 'Archive' : doc.version,
                                  variant: isArchive ? Ux4gAlertVariant.warning : Ux4gAlertVariant.success,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Ux4gIconButton(
                                icon: const Icon(Icons.visibility),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/pdf', arguments: {
                                    'name': doc.name,
                                    'version': doc.version,
                                    'documentId': doc.documentId,
                                  });
                                },
                                variant: Ux4gButtonVariant.primary,
                                style: Ux4gButtonStyle.ghost,
                              ),
                              const SizedBox(height: Ux4gSpacing.xs),
                              Ux4gIconButton(
                                icon: const Icon(Icons.download),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('PDF download not yet available')),
                                  );
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
