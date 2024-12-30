class StatusPost {
  // Constructor
  StatusPost({
    required this.id,
    required this.name,
    required this.image,
    required this.content,
  });

  // Fields
  final int? id;
  final String? name;
  final String? image;
  final String? content;
  factory StatusPost.fromJson(Map<String, dynamic>json){
    return StatusPost(
      id: json["id"],
      name:json["name"],
      image:json["image"],
      content:json["content"],
    );
  }
  // Phương thức chuyển đổi thành JSON để gửi lên server
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'content': content,
    };
  }
}
