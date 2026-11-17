class TrustpinCli < Formula
  desc "TrustPin CLI for certificate pinning management"
  homepage "https://trustpin.cloud"
  version "7.1.0"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v7.1.0/trustpin-cli-macos-x64"
      sha256 "37e27cd3e6a38e49a9f3c07fa55aec7688e8429ff8cc99e933a841426412383b"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v7.1.0/trustpin-cli-macos-arm64"
      sha256 "b0de376e6352a14c6beda3acbef80314ea0e3c44607438341b26cc22f5045020"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v7.1.0/trustpin-cli-linux-x64"
      sha256 "3b4fdfa6b55f6206905415e38f43dad6927c63e58c83db098c6051aa2f2e1114"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v7.1.0/trustpin-cli-linux-arm64"
      sha256 "cd66c1c5af8401b4b40246c6fc1fbea75d35a9c3b4d0acfbf4d46e96a66b55af"
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
