class Profile {
  final String name;
  final String title;
  final String bio;
  final String avatarPath;
  final List<String> skills;
  final List<SocialLink> socialLinks;

  const Profile({
    required this.name,
    required this.title,
    required this.bio,
    required this.avatarPath,
    required this.skills,
    required this.socialLinks,
  });

  // Factory constructor để tạo profile mẫu
  factory Profile.sample() {
    return Profile(
      name: 'Nguyen Van A',
      title: 'Flutter Developer',
      bio:
          'Passionate mobile developer with 2+ years of experience in Flutter. '
          'Love creating beautiful and functional user interfaces.',
      avatarPath: '', // Sẽ sử dụng default icon khi empty
      skills: [
        'Flutter',
        'Dart',
        'Firebase',
        'State Management',
        'UI/UX Design',
        'Git',
        'JavaScript',
        'Python',
        'Node.js',
        'React',
      ],
      socialLinks: [
        SocialLink(
          name: 'GitHub',
          url: 'https://github.com/username',
          icon: 'github',
        ),
        SocialLink(
          name: 'LinkedIn',
          url: 'https://linkedin.com/in/username',
          icon: 'linkedin',
        ),
        SocialLink(
          name: 'Email',
          url: 'mailto:example@email.com',
          icon: 'email',
        ),
        SocialLink(name: 'Phone', url: 'tel:+84123456789', icon: 'phone'),
        SocialLink(
          name: 'Twitter',
          url: 'https://twitter.com/username',
          icon: 'twitter',
        ),
        SocialLink(
          name: 'Website',
          url: 'https://myportfolio.com',
          icon: 'website',
        ),
      ],
    );
  }

  // Copy with method để tạo profile mới với một số thông tin thay đổi
  Profile copyWith({
    String? name,
    String? title,
    String? bio,
    String? avatarPath,
    List<String>? skills,
    List<SocialLink>? socialLinks,
  }) {
    return Profile(
      name: name ?? this.name,
      title: title ?? this.title,
      bio: bio ?? this.bio,
      avatarPath: avatarPath ?? this.avatarPath,
      skills: skills ?? this.skills,
      socialLinks: socialLinks ?? this.socialLinks,
    );
  }
}

class SocialLink {
  final String name;
  final String url;
  final String icon; // Icon identifier

  const SocialLink({required this.name, required this.url, required this.icon});
}
