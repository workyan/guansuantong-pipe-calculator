import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

guard CommandLine.arguments.count > 1 else {
  fputs("Usage: strip_png_alpha.swift <png> [...]\n", stderr)
  exit(64)
}

for path in CommandLine.arguments.dropFirst() {
  let url = URL(fileURLWithPath: path)
  guard
    let source = CGImageSourceCreateWithURL(url as CFURL, nil),
    let image = CGImageSourceCreateImageAtIndex(source, 0, nil),
    let colorSpace = CGColorSpace(name: CGColorSpace.sRGB),
    let context = CGContext(
      data: nil,
      width: image.width,
      height: image.height,
      bitsPerComponent: 8,
      bytesPerRow: image.width * 4,
      space: colorSpace,
      bitmapInfo:
        CGImageAlphaInfo.noneSkipLast.rawValue
        | CGBitmapInfo.byteOrder32Big.rawValue
    )
  else {
    fputs("Unable to decode \(path)\n", stderr)
    exit(65)
  }

  context.setFillColor(CGColor(gray: 1, alpha: 1))
  context.fill(CGRect(x: 0, y: 0, width: image.width, height: image.height))
  context.draw(image, in: CGRect(x: 0, y: 0, width: image.width, height: image.height))

  guard
    let flattened = context.makeImage(),
    let destination = CGImageDestinationCreateWithURL(
      url as CFURL,
      UTType.png.identifier as CFString,
      1,
      nil
    )
  else {
    fputs("Unable to encode \(path)\n", stderr)
    exit(66)
  }

  CGImageDestinationAddImage(destination, flattened, nil)
  guard CGImageDestinationFinalize(destination) else {
    fputs("Unable to save \(path)\n", stderr)
    exit(67)
  }
}
