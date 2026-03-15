import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;

  const MovieCard({
    super.key,
    required this.movie,
    required this.onTap,
    this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Poster image
                    movie.posterUrl != null && movie.posterUrl!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: movie.posterUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => _buildPlaceholder(),
                            errorWidget: (context, url, error) => _buildPlaceholder(),
                          )
                        : movie.iconUrl != null && movie.iconUrl!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: movie.iconUrl!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => _buildPlaceholder(),
                                errorWidget: (context, url, error) => _buildPlaceholder(),
                              )
                            : _buildPlaceholder(),
                    
                    // Rating badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.overlayDark,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 12,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              movie.rating ?? 'N/A',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Favorite button
                    if (onFavoriteToggle != null)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: GestureDetector(
                          onTap: onFavoriteToggle,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.overlayDark,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              movie.isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: movie.isFavorite ? AppColors.favoriteColor : Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      )
                    else if (movie.isFavorite)
                      const Positioned(
                        top: 8,
                        left: 8,
                        child: Icon(
                          Icons.favorite,
                          color: AppColors.favoriteColor,
                          size: 20,
                        ),
                      ),
                    
                    // Bottom info overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.8),
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                movie.year ?? '2024',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            if (movie.duration != null)
                              Text(
                                movie.formattedDuration,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            movie.name,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            movie.categoryName,
            style: TextStyle(
              color: AppColors.textTertiary.withOpacity(0.8),
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.backgroundLight,
      child: Center(
        child: Icon(
          Icons.movie,
          color: AppColors.textTertiary.withOpacity(0.3),
          size: 40,
        ),
      ),
    );
  }
}
