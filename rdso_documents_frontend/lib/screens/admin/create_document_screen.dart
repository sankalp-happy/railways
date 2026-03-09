import 'package:flutter/material.dart';
import 'package:ux4g/ux4g.dart';
import '../../services/document_service.dart';
import '../../models/category.dart';

class CreateDocumentScreen extends StatefulWidget {
  const CreateDocumentScreen({super.key});

  @override
  State<CreateDocumentScreen> createState() => _CreateDocumentScreenState();
}

class _CreateDocumentScreenState extends State<CreateDocumentScreen> {
  final _documentIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _versionController = TextEditingController();
  final _linkController = TextEditingController();
  final _internalLinkController = TextEditingController();
  final _categoryController = TextEditingController();
  final List<String> _selectedCategories = [];
  bool _isLoading = false;

  List<Category> _availableCategories = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)?.settings.arguments;
    if (arg is List<Category> && _availableCategories.isEmpty) {
      _availableCategories = arg;
    }
  }

  void _addCategory() {
    final name = _categoryController.text.trim();
    if (name.isEmpty) return;
    if (!_selectedCategories.contains(name)) {
      setState(() => _selectedCategories.add(name));
    }
    _categoryController.clear();
  }

  Future<void> _submit() async {
    final docId = _documentIdController.text.trim();
    final name = _nameController.text.trim();
    final version = _versionController.text.trim();
    final link = _linkController.text.trim();
    final internalLink = _internalLinkController.text.trim();

    if (docId.isEmpty || name.isEmpty || version.isEmpty || link.isEmpty || internalLink.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final doc = await DocumentService().createDocument(
      documentId: docId,
      name: name,
      version: version,
      link: link,
      internalLink: internalLink,
      categoryNames: _selectedCategories,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (doc != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Document "${doc.name}" created successfully')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create document. Check for duplicate IDs.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Ux4gScaffold(
      backgroundColor: Ux4gColors.gray100,
      appBar: Ux4gAppBar(title: const Text('Create Document')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Ux4gSpacing.lg),
        child: Ux4gCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'New Document',
                style: TextStyle(fontSize: Ux4gTypography.sizeH4, fontWeight: Ux4gTypography.weightSemiBold),
              ),
              const SizedBox(height: Ux4gSpacing.lg),
              Ux4gTextField(
                controller: _documentIdController,
                label: 'Document ID *',
                hint: 'e.g., RDSO-RS-004',
                prefixIcon: const Icon(Icons.tag),
              ),
              const SizedBox(height: Ux4gSpacing.md),
              Ux4gTextField(
                controller: _nameController,
                label: 'Document Name *',
                hint: 'Full name of the document',
                prefixIcon: const Icon(Icons.description),
              ),
              const SizedBox(height: Ux4gSpacing.md),
              Ux4gTextField(
                controller: _versionController,
                label: 'Version *',
                hint: 'e.g., 1.0',
                prefixIcon: const Icon(Icons.history),
              ),
              const SizedBox(height: Ux4gSpacing.md),
              Ux4gTextField(
                controller: _linkController,
                label: 'External Link *',
                hint: 'https://...',
                prefixIcon: const Icon(Icons.link),
              ),
              const SizedBox(height: Ux4gSpacing.md),
              Ux4gTextField(
                controller: _internalLinkController,
                label: 'Internal Link *',
                hint: 'http://127.0.0.1:8000/api/documents/.../pdf/',
                prefixIcon: const Icon(Icons.link),
              ),
              const SizedBox(height: Ux4gSpacing.lg),
              const Text(
                'Categories',
                style: TextStyle(fontWeight: Ux4gTypography.weightSemiBold, fontSize: Ux4gTypography.sizeBody1),
              ),
              const SizedBox(height: Ux4gSpacing.sm),
              if (_selectedCategories.isNotEmpty)
                Wrap(
                  spacing: Ux4gSpacing.xs,
                  runSpacing: Ux4gSpacing.xs,
                  children: _selectedCategories.map((cat) => Chip(
                    label: Text(cat),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () => setState(() => _selectedCategories.remove(cat)),
                  )).toList(),
                ),
              const SizedBox(height: Ux4gSpacing.sm),
              Row(
                children: [
                  Expanded(
                    child: Autocomplete<String>(
                      optionsBuilder: (textEditingValue) {
                        if (textEditingValue.text.isEmpty) return const Iterable<String>.empty();
                        final query = textEditingValue.text.toLowerCase();
                        return _availableCategories
                            .map((c) => c.name)
                            .where((n) => n.toLowerCase().contains(query) && !_selectedCategories.contains(n));
                      },
                      fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
                        _categoryController.text = controller.text;
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            hintText: 'Type category name or add new',
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          onChanged: (v) => _categoryController.text = v,
                          onSubmitted: (_) {
                            _categoryController.text = controller.text;
                            _addCategory();
                            controller.clear();
                          },
                        );
                      },
                      onSelected: (selection) {
                        if (!_selectedCategories.contains(selection)) {
                          setState(() => _selectedCategories.add(selection));
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: Ux4gSpacing.sm),
                  IconButton(
                    onPressed: _addCategory,
                    icon: const Icon(Icons.add_circle, color: Ux4gColors.primary),
                    tooltip: 'Add category',
                  ),
                ],
              ),
              const SizedBox(height: Ux4gSpacing.xxl),
              Ux4gButton(
                onPressed: _isLoading ? null : _submit,
                isFullWidth: true,
                size: Ux4gButtonSize.lg,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Ux4gColors.white),
                      )
                    : const Text('Create Document'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
