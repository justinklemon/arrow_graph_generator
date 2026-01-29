enum ArrowDirection {up, down, left, right}

/// Return the opposite of the direction
extension ArrowDirectionExtension on ArrowDirection {
  ArrowDirection get reversed {
    switch (this) {
      case ArrowDirection.up:
        return ArrowDirection.down;
      case ArrowDirection.down:
        return ArrowDirection.up;
      case ArrowDirection.left:
        return ArrowDirection.right;
      case ArrowDirection.right:
        return ArrowDirection.left;
    }
  }
}
