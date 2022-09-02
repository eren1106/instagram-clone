import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/color_provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    bool isLiked = widget.snap['likes'].contains(user.uid);
    int likesLen = widget.snap['likes'].length;

    void likeComment() async {
      try {
        await FirestoreMethods().likeComment(
          widget.snap['postId'],
          widget.snap['commentId'],
          user.uid,
          widget.snap['likes'],
        );
        setState(() {
          likesLen += isLiked ? -1 : 1;
          isLiked = !isLiked;
        });
      } catch (e) {
        print(e.toString());
      }
    }

    String convertToAgo(DateTime input) {
      Duration diff = DateTime.now().difference(input);

      if (diff.inDays >= 7) {
        int weeks = (diff.inDays / 7).toInt();
        return '${weeks}w';
      } else if (diff.inDays >= 1) {
        return '${diff.inDays}d';
      } else if (diff.inHours >= 1) {
        return '${diff.inHours}h';
      } else if (diff.inMinutes >= 1) {
        return '${diff.inMinutes}m';
      } else if (diff.inSeconds >= 1) {
        return '${diff.inSeconds}s';
      } else {
        return 'just now';
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              widget.snap['profilePic'],
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' ${widget.snap['text']}',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      children: [
                        Text(
                          convertToAgo(widget.snap['datePublished'].toDate()),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Provider.of<ColorProvider>(context)
                                .secondaryColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            '${likesLen} likes',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Provider.of<ColorProvider>(context)
                                  .secondaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: isLiked
                ? InkWell(
                    onTap: likeComment,
                    child: Icon(
                      Icons.favorite,
                      size: 16,
                      color: Colors.pink,
                    ),
                  )
                : InkWell(
                    onTap: likeComment,
                    child: Icon(
                      Icons.favorite_border_outlined,
                      size: 16,
                      color: Provider.of<ColorProvider>(context).primaryColor,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
