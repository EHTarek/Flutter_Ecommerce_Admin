const String imageFieldProductId = 'productId';
const String imageFieldProductTitle = 'title';
const String imageFieldProductImageDownloadUrl = 'imageDownloadUrl';

class ImageModel {
  String? productId;
  String title;
  String imageDownloadUrl;

  ImageModel({
    this.productId,
    required this.title,
    required this.imageDownloadUrl,
  });

  Map<String, dynamic> toMap() => <String, dynamic>{
        imageFieldProductId: productId,
        imageFieldProductTitle: title,
        imageFieldProductImageDownloadUrl: imageDownloadUrl,
      };

  factory ImageModel.fromMap(Map<String, dynamic> map) => ImageModel(
        productId: map[imageFieldProductId],
        title: map[imageFieldProductTitle],
        imageDownloadUrl: map[imageFieldProductImageDownloadUrl],
      );
}
