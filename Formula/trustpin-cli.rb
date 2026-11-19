class TrustpinCli < Formula
  desc "TrustPin CLI for certificate pinning management"
  homepage "https://trustpin.cloud"
  version "7.2.0"

  if OS.mac?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v7.2.0/trustpin-cli-macos-x64"
      sha256 "e6c1d4b1d1a420e9d5893f1d173a5e0db2215cc385b7464e5dc6c2cfb4103408"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v7.2.0/trustpin-cli-macos-arm64"
      sha256 "1509d47807b9b255634b15bc92b88ac6c4416826b82630f97c5c1646cef04a48"
    end
  elsif OS.linux?
    if Hardware::CPU.intel?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v7.2.0/trustpin-cli-linux-x64"
      sha256 "b5ffaed0caa491b330826225dc46fb8381de22500fbec385158a8184edf52332"
    elsif Hardware::CPU.arm?
      url "https://github.com/trustpin-cloud/homebrew-trustpin-cli/releases/download/v7.2.0/trustpin-cli-linux-arm64"
      sha256 "0c5a22f165bf5b6ae6e0adcd5a28723ada2ede840cbaee36b2e1d720561cc45e"
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
