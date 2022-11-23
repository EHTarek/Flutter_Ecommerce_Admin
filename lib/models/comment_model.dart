const String collectionComments = 'comments';
const String commentFieldCommentId = 'ratingId';
const String commentFieldUserId = 'userId';
const String commentFieldProductId = 'productId';
const String commentFieldComment = 'comment';
const String commentFieldApproved = 'approved';

class CommentModel {
  String commentId;
  String userId;
  String productId;
  String comment;
  bool approved;

  CommentModel({
    required this.commentId,
    required this.userId,
    required this.productId,
    required this.comment,
    this.approved = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      commentFieldCommentId: commentId,
      commentFieldUserId: userId,
      commentFieldProductId: productId,
      commentFieldComment: comment,
      commentFieldApproved: approved,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) => CommentModel(
        commentId: map[commentFieldCommentId],
        userId: map[commentFieldUserId],
        productId: map[commentFieldProductId],
        comment: map[commentFieldComment],
        approved: map[commentFieldApproved],
      );
}
