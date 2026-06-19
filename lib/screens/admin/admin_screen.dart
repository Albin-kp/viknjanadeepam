import 'package:flutter/material.dart';

import '../../models/magazine_volume.dart';
import '../../services/catalog_service.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final _service = CatalogService();
  bool _loading = true;
  String? _error;
  List<MagazineVolume> _volumes = const [];

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    if (!CatalogService.isConfigured || !_service.isSignedIn) {
      setState(() => _loading = false);
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final volumes = await _service.fetchAdminVolumes();
      if (!mounted) return;
      setState(() => _volumes = volumes);
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!CatalogService.isConfigured) {
      return const _AdminSetupScreen();
    }
    if (!_service.isSignedIn) {
      return _AdminLoginScreen(onSignedIn: _refresh);
    }
    return Scaffold(
      backgroundColor: const Color(0xFF101316),
      body: SafeArea(
        child: Row(
          children: [
            if (MediaQuery.sizeOf(context).width >= 860)
              _AdminSidebar(
                email: _service.currentEmail,
                onAdd: () => _editVolume(),
                onSignOut: _signOut,
              ),
            Expanded(
              child: Column(
                children: [
                  _AdminHeader(
                    onAdd: () => _editVolume(),
                    onRefresh: _refresh,
                    onSignOut: _signOut,
                  ),
                  Expanded(child: _buildBody()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return _AdminMessage(
        icon: Icons.error_outline_rounded,
        title: 'Could not load volumes',
        body: _error!,
        actionLabel: 'Try again',
        onAction: _refresh,
      );
    }
    if (_volumes.isEmpty) {
      return _AdminMessage(
        icon: Icons.auto_stories_outlined,
        title: 'No volumes yet',
        body: 'Create the first Malayalam magazine volume.',
        actionLabel: 'Add volume',
        onAction: () => _editVolume(),
      );
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 760;
        if (!wide) {
          return ListView.separated(
            padding: const EdgeInsets.all(18),
            itemCount: _volumes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) => _VolumeAdminCard(
              volume: _volumes[index],
              onEdit: () => _editVolume(_volumes[index]),
              onDelete: () => _deleteVolume(_volumes[index]),
            ),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1F24),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: .06)),
            ),
            child: Column(
              children: [
                const _TableHeading(),
                for (final volume in _volumes)
                  _VolumeAdminRow(
                    volume: volume,
                    onEdit: () => _editVolume(volume),
                    onDelete: () => _deleteVolume(volume),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _editVolume([MagazineVolume? volume]) async {
    final saved = await showDialog<MagazineVolume>(
      context: context,
      barrierDismissible: false,
      builder: (context) => _VolumeEditorDialog(
        initial: volume,
        onSave: _service.saveVolume,
      ),
    );
    if (saved != null) await _refresh();
  }

  Future<void> _deleteVolume(MagazineVolume volume) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete volume?'),
        content: Text('“${volume.title}” will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || volume.id == null) return;
    await _service.deleteVolume(volume.id!);
    await _refresh();
  }

  Future<void> _signOut() async {
    await _service.signOut();
    if (mounted) setState(() {});
  }
}

class _AdminSetupScreen extends StatelessWidget {
  const _AdminSetupScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101316),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1F24),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.admin_panel_settings_outlined,
                    color: Color(0xFFC7A35B),
                    size: 42,
                  ),
                  SizedBox(height: 18),
                  Text(
                    'Admin setup required',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'Create the Supabase project, run supabase/schema.sql, add your administrator, and configure the GitHub secrets SUPABASE_URL and SUPABASE_PUBLISHABLE_KEY.',
                    style: TextStyle(
                      color: Color(0xFFAFB5BC),
                      fontSize: 16,
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminLoginScreen extends StatefulWidget {
  const _AdminLoginScreen({required this.onSignedIn});

  final Future<void> Function() onSignedIn;

  @override
  State<_AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<_AdminLoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await CatalogService().signIn(
        email: _email.text.trim(),
        password: _password.text,
      );
      await widget.onSignedIn();
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'The email or password is incorrect.');
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101316),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1F24),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: .06)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.local_fire_department_rounded,
                    color: Color(0xFFC7A35B),
                    size: 44,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'വിക്ഞാനദീപം',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'MAGAZINE ADMINISTRATION',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF8C949D),
                      fontSize: 10,
                      letterSpacing: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),
                  _AdminTextField(
                    controller: _email,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 14),
                  _AdminTextField(
                    controller: _password,
                    label: 'Password',
                    obscureText: true,
                    onSubmitted: (_) => _submit(),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      style: const TextStyle(color: Color(0xFFFF8B85)),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    child: FilledButton(
                      onPressed: _submitting ? null : _submit,
                      child: Text(_submitting ? 'Signing in…' : 'Sign in'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminSidebar extends StatelessWidget {
  const _AdminSidebar({
    required this.email,
    required this.onAdd,
    required this.onSignOut,
  });

  final String? email;
  final VoidCallback onAdd;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 248,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF15191D),
        border: Border(
          right: BorderSide(color: Colors.white.withValues(alpha: .06)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'വിക്ഞാനദീപം',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'HERITAGE MAGAZINE ADMIN',
            style: TextStyle(
              color: Color(0xFFC7A35B),
              fontSize: 9,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 38),
          const _SidebarItem(
            icon: Icons.auto_stories_rounded,
            label: 'Volumes',
            selected: true,
          ),
          _SidebarItem(
            icon: Icons.add_circle_outline_rounded,
            label: 'New volume',
            onTap: onAdd,
          ),
          const Spacer(),
          Text(
            email ?? '',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF8C949D), fontSize: 12),
          ),
          const SizedBox(height: 8),
          _SidebarItem(
            icon: Icons.logout_rounded,
            label: 'Sign out',
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    this.selected = false,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected ? const Color(0xFF253344) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          onTap: onTap,
          leading: Icon(
            icon,
            color: selected ? const Color(0xFF74B8F1) : const Color(0xFF9AA2AA),
          ),
          title: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : const Color(0xFFC1C6CB),
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminHeader extends StatelessWidget {
  const _AdminHeader({
    required this.onAdd,
    required this.onRefresh,
    required this.onSignOut,
  });

  final VoidCallback onAdd;
  final VoidCallback onRefresh;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 860;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 20, 18),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: .06)),
        ),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Magazine volumes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Create, edit, and publish Malayalam editions.',
                  style: TextStyle(color: Color(0xFF8C949D)),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Refresh',
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh_rounded),
            color: Colors.white,
          ),
          if (compact)
            IconButton(
              tooltip: 'Sign out',
              onPressed: onSignOut,
              icon: const Icon(Icons.logout_rounded),
              color: Colors.white,
            ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: Text(compact ? 'Add' : 'Add volume'),
          ),
        ],
      ),
    );
  }
}

class _TableHeading extends StatelessWidget {
  const _TableHeading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(18, 14, 18, 12),
      child: Row(
        children: [
          SizedBox(width: 52),
          SizedBox(width: 16),
          Expanded(flex: 4, child: Text('VOLUME')),
          Expanded(child: Text('YEAR')),
          Expanded(child: Text('STATUS')),
          Expanded(child: Text('UPDATED')),
          SizedBox(width: 92),
        ],
      ),
    );
  }
}

class _VolumeAdminRow extends StatelessWidget {
  const _VolumeAdminRow({
    required this.volume,
    required this.onEdit,
    required this.onDelete,
  });

  final MagazineVolume volume;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: .06)),
        ),
      ),
      child: Row(
        children: [
          const _CoverThumb(),
          const SizedBox(width: 16),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  volume.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Volume ${volume.number}',
                  style: const TextStyle(color: Color(0xFF8C949D)),
                ),
              ],
            ),
          ),
          Expanded(
            child: Text(
              '${volume.year}',
              style: const TextStyle(color: Color(0xFFD0D4D8)),
            ),
          ),
          Expanded(child: _StatusBadge(published: volume.published)),
          Expanded(
            child: Text(
              _date(volume.updatedAt),
              style: const TextStyle(color: Color(0xFF8C949D)),
            ),
          ),
          SizedBox(
            width: 92,
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Edit',
                  onPressed: onEdit,
                  icon: const Icon(Icons.edit_outlined),
                  color: Colors.white,
                ),
                IconButton(
                  tooltip: 'Delete',
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded),
                  color: const Color(0xFFFF8B85),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _VolumeAdminCard extends StatelessWidget {
  const _VolumeAdminCard({
    required this.volume,
    required this.onEdit,
    required this.onDelete,
  });

  final MagazineVolume volume;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1F24),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const _CoverThumb(),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  volume.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${volume.year} · Volume ${volume.number}',
                  style: const TextStyle(color: Color(0xFF8C949D)),
                ),
                const SizedBox(height: 8),
                _StatusBadge(published: volume.published),
              ],
            ),
          ),
          IconButton(onPressed: onEdit, icon: const Icon(Icons.edit_outlined)),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded),
            color: const Color(0xFFFF8B85),
          ),
        ],
      ),
    );
  }
}

class _CoverThumb extends StatelessWidget {
  const _CoverThumb();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: Image.asset(
        'assets/images/heritage-cover.png',
        width: 52,
        height: 72,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.published});

  final bool published;

  @override
  Widget build(BuildContext context) {
    final color = published ? const Color(0xFF66D29B) : const Color(0xFFE2B66B);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .13),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          published ? 'Published' : 'Draft',
          style: TextStyle(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _AdminMessage extends StatelessWidget {
  const _AdminMessage({
    required this.icon,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFFC7A35B), size: 48),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF9DA4AB)),
            ),
            const SizedBox(height: 20),
            FilledButton(onPressed: onAction, child: Text(actionLabel)),
          ],
        ),
      ),
    );
  }
}

class _VolumeEditorDialog extends StatefulWidget {
  const _VolumeEditorDialog({
    required this.initial,
    required this.onSave,
  });

  final MagazineVolume? initial;
  final Future<MagazineVolume> Function(MagazineVolume volume) onSave;

  @override
  State<_VolumeEditorDialog> createState() => _VolumeEditorDialogState();
}

class _VolumeEditorDialogState extends State<_VolumeEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _subtitle;
  late final TextEditingController _description;
  late final TextEditingController _year;
  late final TextEditingController _number;
  late final TextEditingController _minutes;
  late List<_ChapterFields> _chapters;
  late bool _published;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final volume = widget.initial;
    _title = TextEditingController(text: volume?.title ?? '');
    _subtitle = TextEditingController(text: volume?.subtitle ?? '');
    _description = TextEditingController(text: volume?.description ?? '');
    _year = TextEditingController(
      text: (volume?.year ?? DateTime.now().year).toString(),
    );
    _number = TextEditingController(text: volume?.number.toString() ?? '');
    _minutes =
        TextEditingController(text: (volume?.readingMinutes ?? 30).toString());
    _published = volume?.published ?? false;
    _chapters = (volume?.chapters ?? const <MagazineChapter>[])
        .map(_ChapterFields.fromChapter)
        .toList();
    if (_chapters.isEmpty) _chapters.add(_ChapterFields.empty());
  }

  @override
  void dispose() {
    _title.dispose();
    _subtitle.dispose();
    _description.dispose();
    _year.dispose();
    _number.dispose();
    _minutes.dispose();
    for (final chapter in _chapters) {
      chapter.dispose();
    }
    super.dispose();
  }

  Future<void> _save({bool? publish}) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
      if (publish != null) _published = publish;
    });
    try {
      final volume = MagazineVolume(
        id: widget.initial?.id,
        year: int.parse(_year.text.trim()),
        number: int.parse(_number.text.trim()),
        title: _title.text.trim(),
        subtitle: _subtitle.text.trim(),
        description: _description.text.trim(),
        readingMinutes: int.parse(_minutes.text.trim()),
        chapters: _chapters.map((chapter) => chapter.toChapter()).toList(),
        published: _published,
      );
      final saved = await widget.onSave(volume);
      if (mounted) Navigator.pop(context, saved);
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF171C21),
      insetPadding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 920, maxHeight: 780),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 14, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.initial == null ? 'Add volume' : 'Edit volume',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _saving ? null : () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(24),
                  children: [
                    Wrap(
                      spacing: 14,
                      runSpacing: 14,
                      children: [
                        SizedBox(
                          width: 170,
                          child: _AdminTextField(
                            controller: _year,
                            label: 'Year',
                            keyboardType: TextInputType.number,
                            validator: _requiredNumber,
                          ),
                        ),
                        SizedBox(
                          width: 170,
                          child: _AdminTextField(
                            controller: _number,
                            label: 'Volume number',
                            keyboardType: TextInputType.number,
                            validator: _requiredNumber,
                          ),
                        ),
                        SizedBox(
                          width: 190,
                          child: _AdminTextField(
                            controller: _minutes,
                            label: 'Reading minutes',
                            keyboardType: TextInputType.number,
                            validator: _requiredNumber,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _AdminTextField(
                      controller: _title,
                      label: 'Malayalam volume title',
                      validator: _requiredText,
                    ),
                    const SizedBox(height: 14),
                    _AdminTextField(
                      controller: _subtitle,
                      label: 'Malayalam subtitle',
                    ),
                    const SizedBox(height: 14),
                    _AdminTextField(
                      controller: _description,
                      label: 'Malayalam description',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 26),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Chapters',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => setState(
                            () => _chapters.add(_ChapterFields.empty()),
                          ),
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Add chapter'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    for (var index = 0; index < _chapters.length; index++)
                      _ChapterEditor(
                        index: index,
                        fields: _chapters[index],
                        canDelete: _chapters.length > 1,
                        onDelete: () {
                          setState(() {
                            final removed = _chapters.removeAt(index);
                            removed.dispose();
                          });
                        },
                      ),
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Color(0xFFFF8B85)),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  Switch(
                    value: _published,
                    onChanged: _saving
                        ? null
                        : (value) => setState(() => _published = value),
                  ),
                  Text(
                    _published ? 'Published' : 'Draft',
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _saving ? null : () => _save(publish: false),
                    child: const Text('Save draft'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: _saving ? null : () => _save(publish: true),
                    icon: const Icon(Icons.publish_rounded),
                    label: Text(_saving ? 'Saving…' : 'Publish'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChapterEditor extends StatelessWidget {
  const _ChapterEditor({
    required this.index,
    required this.fields,
    required this.canDelete,
    required this.onDelete,
  });

  final int index;
  final _ChapterFields fields;
  final bool canDelete;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF20262C),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Chapter ${index + 1}',
                  style: const TextStyle(
                    color: Color(0xFFC7A35B),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (canDelete)
                IconButton(
                  tooltip: 'Remove chapter',
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded),
                  color: const Color(0xFFFF8B85),
                ),
            ],
          ),
          const SizedBox(height: 8),
          _AdminTextField(
            controller: fields.kicker,
            label: 'Chapter label',
          ),
          const SizedBox(height: 12),
          _AdminTextField(
            controller: fields.title,
            label: 'Malayalam chapter title',
            validator: _requiredText,
          ),
          const SizedBox(height: 12),
          _AdminTextField(
            controller: fields.paragraphs,
            label: 'Malayalam content',
            helperText: 'Separate paragraphs with a blank line.',
            maxLines: 10,
            validator: _requiredText,
          ),
        ],
      ),
    );
  }
}

class _ChapterFields {
  _ChapterFields({
    required this.kicker,
    required this.title,
    required this.paragraphs,
  });

  factory _ChapterFields.empty() => _ChapterFields(
        kicker: TextEditingController(),
        title: TextEditingController(),
        paragraphs: TextEditingController(),
      );

  factory _ChapterFields.fromChapter(MagazineChapter chapter) => _ChapterFields(
        kicker: TextEditingController(text: chapter.kicker),
        title: TextEditingController(text: chapter.title),
        paragraphs:
            TextEditingController(text: chapter.paragraphs.join('\n\n')),
      );

  final TextEditingController kicker;
  final TextEditingController title;
  final TextEditingController paragraphs;

  MagazineChapter toChapter() => MagazineChapter(
        kicker: kicker.text.trim().isEmpty ? 'Chapter' : kicker.text.trim(),
        title: title.text.trim(),
        paragraphs: paragraphs.text
            .split(RegExp(r'\n\s*\n'))
            .map((text) => text.trim())
            .where((text) => text.isNotEmpty)
            .toList(),
      );

  void dispose() {
    kicker.dispose();
    title.dispose();
    paragraphs.dispose();
  }
}

class _AdminTextField extends StatelessWidget {
  const _AdminTextField({
    required this.controller,
    required this.label,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.helperText,
    this.validator,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;
  final String? helperText;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: obscureText ? 1 : maxLines,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      style: const TextStyle(color: Colors.white, height: 1.45),
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        alignLabelWithHint: maxLines > 1,
        filled: true,
        fillColor: const Color(0xFF11161A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

String? _requiredText(String? value) =>
    value == null || value.trim().isEmpty ? 'Required' : null;

String? _requiredNumber(String? value) {
  final parsed = int.tryParse(value ?? '');
  return parsed == null || parsed <= 0 ? 'Enter a valid number' : null;
}

String _date(DateTime? value) {
  if (value == null) return '—';
  return '${value.day.toString().padLeft(2, '0')}/'
      '${value.month.toString().padLeft(2, '0')}/${value.year}';
}
