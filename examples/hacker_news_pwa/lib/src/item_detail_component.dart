import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../hacker_news_service.dart';
import 'comment_component.dart';
import 'item_component.dart';

/// Recursively populates comment count for all comments.
///
/// The number of replies to a comment, including the comment itself, are stored
/// in 'comments_count' for each comment.
int countComments(Map comment) {
  final List replies = comment['comments'];
  var numComments = 1;
  for (final Map reply in replies) {
    numComments += countComments(reply);
  }
  return comment['comments_count'] = numComments;
}

@Component(
  selector: 'item-detail',
  templateUrl: 'item_detail_component.html',
  styleUrls: const ['item_detail_component.css'],
  directives: const [CommentComponent, ItemComponent, NgFor, NgIf],
)
class ItemDetailComponent implements OnActivate {
  final HackerNewsService _hackerNewsService;

  Map item;

  ItemDetailComponent(this._hackerNewsService);

  @override
  Future<void> onActivate(_, RouterState current) {
    final id = current.parameters['id'];
    return _hackerNewsService.getItem(id).then((item) {
      final List comments = item['comments'];
      for (final Map comment in comments) {
        countComments(comment);
      }
    });
  }
}
