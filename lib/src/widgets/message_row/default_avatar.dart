part of '../../../dash_chat_2.dart';

/// {@category Default widgets}
class DefaultAvatar extends StatelessWidget {
  const DefaultAvatar({
    required this.user,
    this.fallbackImage,
    this.size = 35,
    this.getChatUser,
    this.onPressAvatar,
    this.onLongPressAvatar,
  });

  /// The URL of the user's profile picture
  final String user;

  /// Size of the avatar
  final double size;

  final ImageProvider? fallbackImage;

  final Future<ChatUser> Function(String uid)? getChatUser;

  /// Function to call when the user long press on the avatar
  final void Function(String userUi)? onLongPressAvatar;

  /// Function to call when the user press on the avatar
  final void Function(String userUi)? onPressAvatar;

  /// Get the initials of the user
  String getInitials(ChatUser chatUser) {
    return (chatUser.firstName?.isEmpty ?? true ? '' : chatUser.firstName![0]) +
        (chatUser.lastName?.isEmpty ?? true ? '' : chatUser.lastName![0]);
  }

  Future<ChatUser> get future async =>
      await getChatUser?.call(user) ?? ChatUser(id: user);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ChatUser>(
        future: future,
        builder: (context, snapshot) {
          final chatUser = snapshot.data ?? ChatUser(id: '');

          return GestureDetector(
            onTap: onPressAvatar != null ? () => onPressAvatar!(user) : null,
            onLongPress: onLongPressAvatar != null
                ? () => onLongPressAvatar!(user)
                : null,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: SizedBox(
                height: size,
                width: size,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Container(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        child: getInitials(chatUser).isNotEmpty
                            ? Center(
                                child: Text(
                                  getInitials(chatUser),
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontSize: size * 0.35,
                                  ),
                                ),
                              )
                            : Image(
                                image: fallbackImage ??
                                    const AssetImage(
                                      'assets/profile_placeholder.png',
                                      package: 'dash_chat_2',
                                    ),
                              ),
                      ),
                    ),
                    if (chatUser.profileImage != null &&
                        chatUser.profileImage!.isNotEmpty)
                      Center(
                        child: ClipOval(
                          child: FadeInImage(
                            width: size,
                            height: size,
                            fit: BoxFit.cover,
                            image: getImageProvider(chatUser.profileImage!),
                            placeholder: fallbackImage ??
                                const AssetImage(
                                  'assets/profile_placeholder.png',
                                  package: 'dash_chat_2',
                                ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
