class TrustpinCli < Formula
  desc "TrustPin CLI for certificate pinning management"
  homepage "https://trustpin.cloud"
  version "7.0.0"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v7.0.0/trustpin-cli-macos-x64"
      sha256 "7f037e7a3e0be8034f5b86132e99d342782b1d734b3c0a0aefbaad17ec00920f"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v7.0.0/trustpin-cli-macos-arm64"
      sha256 "0c10e79c150b7858e652867fc0035f26bc3fcbcbe4ae3e1e8dab4d8e405b91c2"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v7.0.0/trustpin-cli-linux-x64"
      sha256 "c0620be18b0f2df6b2b77c3dbc5f15e5b18b8fe4af2c8680f733f3666aa45836"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v7.0.0/trustpin-cli-linux-arm64"
      sha256 "872d61feaa06a1fb74737c4977eb100119290916e3613a2efdc19968fe0b931e"
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
