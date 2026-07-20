class TrustpinCli < Formula
  desc "TrustPin CLI for certificate pinning management"
  homepage "https://github.com/trustpin-cloud/cloud-console-cli"
  version "5.0.2"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v5.0.2/trustpin-cli-macos-x64"
      sha256 "f4ff138fb7e85b9afe6493be4a6bb82183489e5e99732ca65d75707268a0921c"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v5.0.2/trustpin-cli-macos-arm64"
      sha256 "ecfd26513e72cf99df00a7656ffb84398096d45ed05c7439989e88cc1bfc304c"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v5.0.2/trustpin-cli-linux-x64"
      sha256 "a960fff5897e77329101b2620fbe0ac2040415a331dddd1578fdf3f2de452029"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v5.0.2/trustpin-cli-linux-arm64"
      sha256 "afa6c2f6d23592babdcc6c57c03e2d2004e0a1add357b304895b6521f8aa6906"
    end
  end

  def install
    os = OS.mac? ? "macos" : "linux"
    arch = Hardware::CPU.intel? ? "x64" : "arm64"
    binary_name = "trustpin-cli-#{os}-#{arch}"

    # Ensure the binary has execute permissions
    chmod 0755, binary_name

    bin.install binary_name => "trustpin-cli"
  end

  test do
    system "#{bin}/trustpin-cli", "--version"
  end
end
