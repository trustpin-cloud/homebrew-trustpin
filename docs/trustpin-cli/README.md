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

#### macOS
```bash
# Intel Macs
curl -L https://github.com/trustpin-cloud/cloud-console-cli/releases/latest/download/trustpin-cli-macos-x64 -o trustpin-cli
chmod +x trustpin-cli
sudo mv trustpin-cli /usr/local/bin/

# Apple Silicon Macs
curl -L https://github.com/trustpin-cloud/cloud-console-cli/releases/latest/download/trustpin-cli-macos-arm64 -o trustpin-cli
chmod +x trustpin-cli
sudo mv trustpin-cli /usr/local/bin/
```

#### Linux
```bash
# x64
curl -L https://github.com/trustpin-cloud/cloud-console-cli/releases/latest/download/trustpin-cli-linux-x64 -o trustpin-cli
chmod +x trustpin-cli
sudo mv trustpin-cli /usr/local/bin/

# ARM64
curl -L https://github.com/trustpin-cloud/cloud-console-cli/releases/latest/download/trustpin-cli-linux-arm64 -o trustpin-cli
chmod +x trustpin-cli
sudo mv trustpin-cli /usr/local/bin/
```

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

## Commands

### Configuration

#### `configure`
Configure the CLI with your TrustPin credentials.

```bash
trustpin-cli configure [--api-base-url <url>] [--api-token <token>]
```

**Interactive Example**:
```bash
$ trustpin-cli configure
API Base URL (https://api.trustpin.cloud): https://api.trustpin.cloud
API Token: tp_your_token_here
 Configuration saved successfully!
```

### User Management

#### `user info`
Get current user information and organization details.

```bash
trustpin-cli user info [--output json]
```

**Examples**:
```bash
# Human-readable format
$ trustpin-cli user info
═══ User Information ═══
ID: 7bb1bbbd-b7fc-4e1a-893a-026d92c6356f
Name: TrustPin
Email: info@trustpin.cloud

── Organizations ──
• Personal Organization (fb52418e-b5ae-4bff-b973-6da9ae07ba00)

# JSON format
$ trustpin-cli user info --output json
{
  "status": "success",
  "operation": "user-info",
  "data": {
    "user": {
      "id": "7bb1bbbd-b7fc-4e1a-893a-026d92c6356f",
      "name": "TrustPin",
      "email": "info@trustpin.cloud"
    },
    "organizations": [
      {
        "id": "fb52418e-b5ae-4bff-b973-6da9ae07ba00",
        "name": "Personal Organization"
      }
    ]
  }
}
```

### Project Management

#### `projects list`
List all projects in your organization.

```bash
trustpin-cli projects list [--output json]
```

**Examples**:
```bash
# Human-readable format
$ trustpin-cli projects list
═══ Projects (2) ═══

── TrustPin Mobile App ──
  ID: df9964a9-66bf-4673-9743-adee9ce6213e
  Type: Managed CDN with Cloud Keys
  Organization: Personal Organization (fb52418e-b5ae-4bff-b973-6da9ae07ba00)
  Created: 2025-07-10T16:58:11.093900Z
  Updated: 2025-07-18T08:43:11.140066Z
  Configuration Published: 2025-07-18T07:42:29.125714Z
  Domains: 4

# JSON format for automation
$ trustpin-cli projects list --output json | jq '.data.projects[].name'
"TrustPin Mobile App"
"API Gateway"
```

#### `projects get`
Get detailed information about a specific project.

```bash
trustpin-cli projects get <organization-id> <project-id> [--output json]
```

**Examples**:
```bash
# Get project details
$ trustpin-cli projects get fb52418e-b5ae-4bff-b973-6da9ae07ba00 df9964a9-66bf-4673-9743-adee9ce6213e

═══ Project Details ═══
Name: TrustPin Mobile App
ID: df9964a9-66bf-4673-9743-adee9ce6213e
Type: Managed CDN with Cloud Keys
Organization: Personal Organization (fb52418e-b5ae-4bff-b973-6da9ae07ba00)
Created: 2025-07-10T16:58:11.093900Z
Updated: 2025-07-18T08:43:11.140066Z
Configuration Version: 3
Published Version: 2
⚠️  Warning: Latest configuration (v3) is not yet published (v2)
Public Key: MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEyQ04pTptzBAqo8q6mhwvvwdJSnoxDpvhwir9SVNAscNTNAApbuaKaEA6Ua5zTfknWPjMONc9XJeDOb4ExUj8dQ==
Domains: 4
    • Domain: trustpin.cloud
      Updated: 2025-07-18T08:43:11.140066Z
      Certificate Pins: 1
    • Domain: api.trustpin.cloud
      Updated: 2025-07-18T08:43:11.140066Z
      Certificate Pins: 1
```

#### `projects config`
Get project configuration in JWS payload format (JSON only).

```bash
trustpin-cli projects config <organization-id> <project-id>
```

**Example**:
```bash
# Get configuration payload for signing
$ trustpin-cli projects config fb52418e-b5ae-4bff-b973-6da9ae07ba00 df9964a9-66bf-4673-9743-adee9ce6213e
{
  "status": "success",
  "operation": "projects-config",
  "data": {
    "project": {
      "id": "df9964a9-66bf-4673-9743-adee9ce6213e",
      "organization_id": "fb52418e-b5ae-4bff-b973-6da9ae07ba00"
    },
    "config": {
      "version": 3,
      "domains": [
        {
          "domain": "trustpin.cloud",
          "last_updated": "2025-07-18T08:43:11Z",
          "pins": [
            {
              "algorithm": "sha256",
              "pin": "heXXXV6YUWtMPE/dUyZ6ESBpkOibPSeHseRAnp4dQJg=",
              "expires_at": "2025-09-02T05:43:19Z"
            }
          ]
        }
      ]
    }
  }
}
```

#### `projects sign`
Sign project configuration and publish as JWS.

```bash
trustpin-cli projects sign <organization-id> <project-id> [--private-key <path>] [--password <password>]
```

**Examples**:
```bash
# Sign with cloud-managed keys
$ trustpin-cli projects sign fb52418e-b5ae-4bff-b973-6da9ae07ba00 df9964a9-66bf-4673-9743-adee9ce6213e
Master password: ****
[1/5] Getting project information
  Project: TrustPin Mobile App (Managed CDN with Cloud Keys)
[2/5] Loading project configuration
  Configuration loaded with 4 domains
[3/5] Preparing private key
  Using cloud-managed private key
[4/5] Creating and signing JWT
  JWT signed successfully
[5/5] Uploading signed configuration
 Configuration published successfully!

# Sign with bring-your-own-key (BYOK)
$ trustpin-cli projects sign fb52418e-b5ae-4bff-b973-6da9ae07ba00 99acf096-79b9-4fa6-a115-14b35b224839 --private-key ./my-private-key.pem
Master password: ****
[1/5] Getting project information
  Project: BYOK Project (Managed CDN with Bring Your Own Keys)
[2/5] Loading project configuration
[3/5] Preparing private key
  Reading private key from file: ./my-private-key.pem
[4/5] Creating and signing JWT
[5/5] Uploading signed configuration
 Configuration published successfully!
```

## Output Formats

The CLI supports multiple output formats:

### Human-Readable (Default)
Perfect for interactive use with progress indicators, colors, and formatted output.

### JSON
Machine-readable format for automation and CI/CD integration.

```bash
# Get JSON output
trustpin-cli user info --output json

# Use with jq for parsing
trustpin-cli projects list --output json | jq '.data.projects[].name'

# Check command success in scripts
trustpin-cli user info --output json | jq -r '.status'
```

## Configuration

The CLI stores configuration in `~/.trustpin/cli/config.properties`:

```properties
TRUSTPIN_API_BASE_URL=https://api.trustpin.cloud
TRUSTPIN_API_TOKEN=tp_your_token_here
```

### Environment Variables

You can also use environment variables:

```bash
export TRUSTPIN_API_BASE_URL=https://api.trustpin.cloud
export TRUSTPIN_API_TOKEN=tp_your_token_here
```

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Deploy Certificate Pinning
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Install TrustPin CLI
        run: |
          curl -L https://github.com/trustpin-cloud/cloud-console-cli/releases/latest/download/trustpin-cli-linux-x64 -o trustpin-cli
          chmod +x trustpin-cli
          sudo mv trustpin-cli /usr/local/bin/
      
      - name: Sign and publish configuration
        env:
          TRUSTPIN_API_TOKEN: ${{ secrets.TRUSTPIN_API_TOKEN }}
        run: |
          trustpin-cli projects sign ${{ vars.ORG_ID }} ${{ vars.PROJECT_ID }} --password ${{ secrets.MASTER_PASSWORD }}
```

### Exit Codes

The CLI uses standard exit codes for automation:

- `0` - Success
- `1` - Configuration error
- `2` - API error
- `3` - Authentication error
- `4-10` - Various operation-specific errors
- `99` - Unexpected error

## Advanced Usage

### Batch Operations

```bash
# List all projects and get their IDs
PROJECT_IDS=$(trustpin-cli projects list --output json | jq -r '.data.projects[].id')

# Get details for each project
for id in $PROJECT_IDS; do
  trustpin-cli projects get $ORG_ID $id --output json | jq '.data.project.name'
done
```

### Configuration Validation

```bash
# Check if configuration is valid
if trustpin-cli user info --output json | jq -e '.status == "success"' > /dev/null; then
  echo " Configuration is valid"
else
  echo " Configuration is invalid"
  exit 1
fi
```

## Troubleshooting

### Common Issues

1. **Configuration Not Found**
   ```bash
   # Reconfigure the CLI
   trustpin-cli configure

   # Check where config is located (with verbose)
   trustpin-cli user info --verbose
   ```

2. **Invalid API Token**
   ```bash
   # Check token format (should start with tp_)
   trustpin-cli configure --api-token tp_your_new_token
   ```

3. **Network Issues**
   ```bash
   # Use verbose mode to see HTTP status codes and errors
   trustpin-cli projects list --verbose

   # Test connectivity
   curl -H "Authorization: Bearer $TRUSTPIN_API_TOKEN" https://api.trustpin.cloud/users
   ```

4. **HTTP Errors (401, 403, 404, 500, etc.)**
   ```bash
   # Use verbose mode to see detailed error information
   trustpin-cli projects get <org-id> <project-id> --verbose
   # Output will show:
   # ❌ HTTP Error: GET https://api.trustpin.cloud/projects/...
   #    Status: 404 Not Found
   ```

5. **Permission Denied**
   ```bash
   # Make sure binary is executable
   chmod +x trustpin-cli
   ```

### Debug Mode

```bash
# Enable debug output
trustpin-cli --debug user info

# Enable HTTP request logging
trustpin-cli --log-http projects list

# Enable verbose output (shows config file, API URLs, HTTP status codes)
trustpin-cli --verbose projects list
```

**Verbose Mode Example Output:**
```bash
$ trustpin-cli projects list --verbose
ℹ️  Checking configuration...
ℹ️  Config file: /Users/user/.trustpin/cli/config.properties
ℹ️  Configuration is valid
ℹ️  Using API Base URL: https://api.trustpin.cloud
ℹ️  Making request: GET https://api.trustpin.cloud/projects
ℹ️  Using API Token: tp_4ioRUFH...SQ==
✅ HTTP Success: GET https://api.trustpin.cloud/projects (200)
```

## Support

For issues and questions:
- Create an issue in the [GitHub repository](https://github.com/trustpin-cloud/cloud-console-cli/issues)
- Check the documentation at [docs.trustpin.cloud](https://docs.trustpin.cloud)
- Contact support at [support@trustpin.cloud](mailto:support@trustpin.cloud)

## License

This project is licensed under the TrustPin Binary License Agreement - see the [LICENSE](LICENSE) file for details.

---