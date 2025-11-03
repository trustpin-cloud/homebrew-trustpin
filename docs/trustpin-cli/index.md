---
layout: default
title: Home
---

# TrustPin CLI

A powerful command-line interface for TrustPin certificate pinning management. Manage your certificate pinning configurations, sign JWS payloads, and deploy secure mobile applications with confidence.

## Features

- 🔐 **Secure Configuration Management**: Store API credentials securely
- 👤 **User Management**: Get user information and organization details
- 📁 **Project Management**: List, view, and manage TrustPin projects
- 🔑 **Certificate Signing**: Sign and publish certificate pinning configurations
- 📊 **Machine-Readable Output**: JSON output for CI/CD integration
- 🔧 **Cross-Platform**: Native binaries for macOS and Linux (Intel & ARM)
- 🚀 **AWS CLI-style**: Familiar command structure and error handling

## Installation

### Homebrew (Recommended)

```bash
# Add TrustPin tap
brew tap trustpin-cloud/trustpin-cli

# Install TrustPin CLI
brew install trustpin-cli
```

### GitHub Releases

Download the latest release from the [GitHub Releases](https://github.com/trustpin-cloud/cloud-console-cli/releases) page.

## Quick Start

1. **Configure the CLI**:
   ```bash
   trustpin-cli configure
   ```

2. **Get user information**:
   ```bash
   trustpin-cli user info
   ```

3. **List your projects**:
   ```bash
   trustpin-cli projects list
   ```

## Documentation

For complete documentation, please see the [README](https://github.com/trustpin-cloud/cloud-console-cli/blob/main/README.md).

## Support

For issues and questions:
- Create an issue in the [GitHub repository](https://github.com/trustpin-cloud/cloud-console-cli/issues)
- Check the documentation at [docs.trustpin.cloud](https://docs.trustpin.cloud)
- Contact support at [support@trustpin.cloud](mailto:support@trustpin.cloud)
