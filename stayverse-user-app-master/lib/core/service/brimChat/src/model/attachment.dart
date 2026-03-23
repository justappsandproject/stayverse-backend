import 'dart:io';

class Attachment {
  final String? url;
  final String? name;
  final String? type;
  final int? size;
  final String? id;
  final File? file;

  Attachment({
    this.url,
    this.name,
    this.type,
    this.size,
    this.id,
    this.file,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment(
      url: json['url'] as String?,
      name: json['name'] as String?,
      type: json['type'] as String?,
      size: json['size'] as int?,
      id: json['id'] as String?,
      // Note: file cannot be deserialized from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'name': name,
      'type': type,
      'size': size,
      'id': id,
      // Note: file is not included in JSON serialization
    };
  }

  // Helper method to create attachment from file
  static Attachment fromFile(File file) {
    return Attachment(
      file: file,
      name: file.path.split('/').last,
      size: file.lengthSync(),
      type: _getFileType(file.path),
    );
  }

  // Helper method to determine file type from extension
  static String? _getFileType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case 'txt':
        return 'text/plain';
      case 'mp4':
        return 'video/mp4';
      case 'mp3':
        return 'audio/mpeg';
      default:
        return 'application/octet-stream';
    }
  }

  // Helper method to check if attachment is an image
  bool get isImage {
    return type?.startsWith('image/') ?? false;
  }

  // Helper method to check if attachment is a video
  bool get isVideo {
    return type?.startsWith('video/') ?? false;
  }

  // Helper method to check if attachment is an audio file
  bool get isAudio {
    return type?.startsWith('audio/') ?? false;
  }

  // Helper method to get human readable file size
  String get formattedSize {
    if (size == null) return 'Unknown size';
    
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = 0;
    double fileSize = size!.toDouble();
    
    while (fileSize >= 1024 && i < suffixes.length - 1) {
      fileSize /= 1024;
      i++;
    }
    
    return '${fileSize.toStringAsFixed(1)} ${suffixes[i]}';
  }

  @override
  String toString() {
    return 'Attachment(id: $id, name: $name, type: $type, size: $size, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Attachment &&
        other.id == id &&
        other.name == name &&
        other.type == type &&
        other.size == size &&
        other.url == url;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        type.hashCode ^
        size.hashCode ^
        url.hashCode;
  }
}