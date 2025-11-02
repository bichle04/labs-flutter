import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';
import 'responsive_wrapper.dart';

class SkillsCard extends StatelessWidget {
  final List<String> skills;
  final VoidCallback? onSkillTap;

  const SkillsCard({super.key, required this.skills, this.onSkillTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        _buildSectionHeader(context),

        const SizedBox(height: 16),

        // Skills Cards
        _buildSkillsGrid(context),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.code,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Technical Skills',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const Spacer(),
        Text(
          '${skills.length} skills',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsGrid(BuildContext context) {
    return Card(
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              Theme.of(
                context,
              ).colorScheme.surfaceContainer.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Primary Skills (first 3 skills with enhanced styling)
              if (skills.isNotEmpty) _buildPrimarySkills(context),

              if (skills.length > 3) const SizedBox(height: 16),

              // Secondary Skills (remaining skills as chips)
              if (skills.length > 3) _buildSecondarySkills(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrimarySkills(BuildContext context) {
    final primarySkills = skills.take(3).toList();

    return Column(
      children: [
        Text(
          'Core Skills',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        ResponsiveRow(
          children: primarySkills
              .map((skill) => _buildPrimarySkillCard(context, skill))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildPrimarySkillCard(BuildContext context, String skill) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getSkillIcon(skill),
            size: 16,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(width: 8),
          Text(
            skill,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondarySkills(BuildContext context) {
    final secondarySkills = skills.skip(3).toList();

    return Column(
      children: [
        Divider(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
        const SizedBox(height: 12),
        Text(
          'Additional Skills',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        ResponsiveHelper.isMobile(context)
            ? Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: secondarySkills
                    .map((skill) => _buildSkillChip(context, skill))
                    .toList(),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: ResponsiveHelper.getSkillsColumns(context),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 3.0,
                ),
                itemCount: secondarySkills.length,
                itemBuilder: (context, index) =>
                    _buildSkillChip(context, secondarySkills[index]),
              ),
      ],
    );
  }

  Widget _buildSkillChip(BuildContext context, String skill) {
    return Chip(
      label: Text(skill),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSecondaryContainer,
        fontWeight: FontWeight.w500,
      ),
      side: BorderSide(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  IconData _getSkillIcon(String skill) {
    switch (skill.toLowerCase()) {
      case 'flutter':
        return Icons.flutter_dash;
      case 'dart':
        return Icons.code;
      case 'firebase':
        return Icons.cloud;
      case 'state management':
        return Icons.memory;
      case 'ui/ux design':
        return Icons.design_services;
      case 'git':
        return Icons.source;
      case 'javascript':
        return Icons.javascript;
      case 'react':
        return Icons.web;
      case 'node.js':
        return Icons.dns;
      case 'python':
        return Icons.code;
      case 'java':
        return Icons.coffee;
      default:
        return Icons.star;
    }
  }
}
