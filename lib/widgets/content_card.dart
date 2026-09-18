import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/content_item.dart';

class ContentCard extends StatelessWidget {
  final ContentItem item;
  final VoidCallback onTap;

  const ContentCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  String get poster {
    if (item.poster.isNotEmpty) {
      return item.poster;
    }

    return 'https://img.omdbapi.com/?i=${item.id}&apikey=trilogy';
  }

  @override
  Widget build(BuildContext context) {
    final smallTextColor =
        Theme.of(context).textTheme.bodySmall?.color;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: CachedNetworkImage(
                    imageUrl: poster,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) {
                      return Container(
                        color: const Color(0xff1e1e24),
                        child: const Center(
                          child: Text(
                            '🎬',
                            style: TextStyle(fontSize: 32),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Positioned(
                  top: 7,
                  right: 7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.78),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: Color(0xffffc107),
                          size: 13,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          item.rating,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 7),

          Text(
            item.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            '${item.year} • ${item.category}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              color: smallTextColor?.withValues(alpha: 0.65),
            ),
          ),
        ],
      ),
    );
  }
}
