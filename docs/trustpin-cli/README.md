# TrustPin CLI

A powerful command-line interface for TrustPin certificate pinning management. Manage your certificate pinning configurations, sign JWS payloads, and deploy secure mobile applications with confidence.

## Features

- 🔐 **Secure Configuration Management**: Store API credentials securely
- 👤 **User Management**: Get user information and organization details
- 📁 **Project Management**: List, view, and manage TrustPin projects
- 🌐 **Domain Certificate Lookup**: Discover SSL/TLS certificates and pins for any domain
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

#### `projects upsert`
Add or update a certificate pin for a domain in a project.

```bash
trustpin-cli projects upsert <organization-id> <project-id> \
  --domain <domain-name> \
  --pin <type>:<value> \
  [--expires <ISO8601-datetime>] \
  [--dry-run] \
  [--verbose] \
  [--output json]
```

**Pin Types**:
- `sha256` - Certificate SHA-256 fingerprint
- `sha512` - Certificate SHA-512 fingerprint
- `spki-sha256` - SPKI SHA-256 fingerprint (recommended)
- `spki-sha512` - SPKI SHA-512 fingerprint

**Examples**:
```bash
# Add SPKI SHA-256 pin to existing domain
$ trustpin-cli projects upsert fb52418e-b5ae-4bff-b973-6da9ae07ba00 df9964a9-66bf-4673-9743-adee9ce6213e \
  --domain api.trustpin.cloud \
  --pin spki-sha256:heXXXV6YUWtMPE/dUyZ6ESBpkOibPSeHseRAnp4dQJg= \
  --expires 2025-09-02T05:43:19Z
✓ Domain: api.trustpin.cloud
  • Added pin: spki-sha256:heXXXV6YUW... (expires 2025-09-02T05:43:19Z)

✓ Project updated successfully
  Configuration version: 5 → 6
  ⚠️  Remember to sign and publish: trustpin-cli projects sign fb52418e-b5ae-4bff-b973-6da9ae07ba00 df9964a9-66bf-4673-9743-adee9ce6213e

# Update existing pin expiration
$ trustpin-cli projects upsert fb52418e-b5ae-4bff-b973-6da9ae07ba00 df9964a9-66bf-4673-9743-adee9ce6213e \
  --domain api.trustpin.cloud \
  --pin spki-sha256:heXXXV6YUWtMPE/dUyZ6ESBpkOibPSeHseRAnp4dQJg= \
  --expires 2026-01-15T00:00:00Z
✓ Domain: api.trustpin.cloud
  • Updated pin: spki-sha256:heXXXV6YUW...
    Expiration updated (expires 2026-01-15T00:00:00Z)

# Dry run (show what would be sent without submitting)
$ trustpin-cli projects upsert fb52418e-b5ae-4bff-b973-6da9ae07ba00 df9964a9-66bf-4673-9743-adee9ce6213e \
  --domain cdn.trustpin.cloud \
  --pin sha256:ABC123... \
  --dry-run
[DRY RUN] PATCH /projects/tprn::project::fb52418e::df9964a9/domains

Request body:
{
  "domains": [
    {
      "domain": "api.trustpin.cloud",
      "pins": [ ... ]
    },
    {
      "domain": "cdn.trustpin.cloud",
      "pins": [ ... ]
    }
  ]
}

✓ Dry run completed. No changes submitted.

# Verbose output for debugging
$ trustpin-cli projects upsert fb52418e-b5ae-4bff-b973-6da9ae07ba00 df9964a9-66bf-4673-9743-adee9ce6213e \
  --domain api.trustpin.cloud \
  --pin spki-sha256:ABC123... \
  --verbose
ℹ️  Validating inputs...
ℹ️  Domain: api.trustpin.cloud (valid FQDN)
ℹ️  Pin type: spki-sha256
ℹ️  Pin value: ABC123... (44 chars, valid base64)

ℹ️  Fetching project...
ℹ️  Project fetched: TrustPin Mobile App (version 5)
ℹ️  Domain found: api.trustpin.cloud (3 existing pins)
ℹ️  Pin not found. Adding new pin...
...
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

#### `projects jws`
Fetch the published JWS configuration from CDN.

This command retrieves the currently published certificate pinning configuration that mobile applications are fetching. Use this to verify what configuration is currently published, debug mobile app pinning issues, or validate that `sign` successfully published the configuration.

```bash
trustpin-cli projects jws <organization-id> <project-id> [--verify] [--decode] [--output-file <path>]
```

**Options**:
- `--verify` - Verify JWS signature using public key from CDN
- `--decode` - Decode and display JWS header and payload
- `--output-file <path>` - Save JWS to file

**Examples**:
```bash
# Fetch raw JWS (default - outputs to stdout)
$ trustpin-cli projects jws fb52418e-b5ae-4bff-b973-6da9ae07ba00 df9964a9-66bf-4673-9743-adee9ce6213e
eyJhbGciOiJFUzI1NiIsImtpZCI6InRwcm46OnByb2plY3Q6OmZiNTI0MThlLWI1YWUtNGJmZi1iOTczLTZkYTlhZTA3YmEwMDo6OWNhYWVhMGEtMDEzZS00ZTdiLTgwZWEtY2VlNmJmYjUyYjM2LWtleSIsInR5cCI6IkpXVCJ9.eyJkb21haW5zIjpbeyJkb21haW4iOiJnb29nbGUuY29tIiwibGFzdF91cGRhdGVkIjoxNzcwNzk4NTY1LCJwaW5zIjpbeyJleHBpcmVzX2F0IjoxNzc2MDY5NDIyLCJzcGtpX3NoYTI1NiI6Im94VlNkQ0xndGhMM001Vm5uemVwcThXV2xrVWZSUFlrcGpMcG0rd24rMW89Iiwic3BraV9zaGE1MTIiOiJKcnV4ZFdlOTZiL1V1enVzbDNaUlRRZjIzYit2WldPOHdLR2E1NWRsMXRYcUhJeng2a0N1ZGtwMXlKOUVnUnhWaGl5SC9oeDRsNDVRODdNQ3NoUnNwQT09In0seyJzaGEyNTYiOiIwSllveGJCV0N5ZUVsemV5ZUZ3cis0MUFreTlZaHVId2lZbjBrbDdxcGI0PSJ9XX1dLCJpYXQiOjE3NzA3OTg2ODQsIm5iZiI6MTc3MDc5ODY4NCwic3BlYyI6InYxLjAuMCIsInZlcnNpb24iOjN9.ec7NYhkKtrzlaHvOvASUuaZgcaXOz3Ha8EXL3lmSTMZV8hlCNSAdS1GZLRCSxLOPVFXj4otwUsl4a8PGo-OW3A

# Verify JWS signature
$ trustpin-cli projects jws fb52418e-b5ae-4bff-b973-6da9ae07ba00 df9964a9-66bf-4673-9743-adee9ce6213e --verify --verbose
ℹ️  Fetching project information...
ℹ️  Project: TrustPin Mobile App
ℹ️  Fetching JWS from CDN: https://cdn.trustpin.cloud/...
ℹ️  JWS fetched successfully (772 bytes)
ℹ️  Fetching public key from CDN: https://cdn.trustpin.cloud/...
ℹ️  Public key fetched (188 bytes)
ℹ️  JWS signature verified successfully
eyJhbGciOiJFUzI1NiIsImtpZCI6InRwcm46OnByb2plY3Q6OmZiNTI0MThlLWI1YWUtNGJmZi1iOTczLTZkYTlhZTA3YmEwMDo6OWNhYWVhMGEtMDEzZS00ZTdiLTgwZWEtY2VlNmJmYjUyYjM2LWtleSIsInR5cCI6IkpXVCJ9...

# Decode and display JWS payload
$ trustpin-cli projects jws fb52418e-b5ae-4bff-b973-6da9ae07ba00 df9964a9-66bf-4673-9743-adee9ce6213e --decode
JWS Header:
  Algorithm: ES256
  Type: JWT
  Key ID: tprn::project::fb52418e-b5ae-4bff-b973-6da9ae07ba00::9caaea0a-013e-4e7b-80ea-cee6bfb52b36-key

Payload:
  Spec: v1.0.0
  Version: 3
  Issued At: 2025-12-11T13:24:44Z
  Not Before: 2025-12-11T13:24:44Z
  Domains: 1
    - google.com (2 pins)

Project: TrustPin Mobile App
Current DB Version: 3
Published Version: 3

✅ Published version is up to date

# Save JWS to file
$ trustpin-cli projects jws fb52418e-b5ae-4bff-b973-6da9ae07ba00 df9964a9-66bf-4673-9743-adee9ce6213e --output-file config.jws --verbose
ℹ️  Fetching project information...
ℹ️  Project: TrustPin Mobile App
ℹ️  Fetching JWS from CDN: https://cdn.trustpin.cloud/...
ℹ️  JWS fetched successfully (772 bytes)
✅ JWS saved to: config.jws

# Pipe to mobile app simulator for testing
$ trustpin-cli projects jws fb52418e-b5ae-4bff-b973-6da9ae07ba00 df9964a9-66bf-4673-9743-adee9ce6213e | ./test-mobile-app
```

**Use Cases**:
- **Verify published configuration**: Check what configuration is currently live in production
- **Debug mobile app issues**: Compare what the app is fetching vs what you expect
- **Validate signing**: Confirm that `sign` command successfully published the configuration
- **Testing**: Download JWS for local testing with mobile app simulators
- **Auditing**: Archive JWS configurations for compliance and audit trails

### Domain Management

#### `domains certificates`
Look up all known SSL/TLS certificates for a domain, including the live certificate and any certificates discovered via Certificate Transparency logs.

Use this to find certificate pins before adding them to a project with `projects upsert`.

```bash
trustpin-cli domains certificates <domain-name> [--output json]
```

**Examples**:
```bash
# Human-readable format
$ trustpin-cli domains certificates api.example.com

═══ Certificates for api.example.com ═══
  Total certificates: 2

── Certificate 1 ──
  Common Name: api.example.com
  Issuer: Let's Encrypt Authority X3
  SHA-256: heXXXV6YUWtMPE/dUyZ6ESBpkOibPSeHseRAnp4dQJg=
  SHA-512: JruxdWe96b/Uuzusl3ZRTQf23b+vZWO8wKGa55dl1tXq...
  SPKI SHA-256: oxVSdCLgthL3M5Vnnzepq8WWlkUfRPYkpjLpm+wn+1o=
  SPKI SHA-512: abc123def456...
  Expires At: 2026-04-13T08:37:02Z
  CAA Issuer: letsencrypt.org
  CT Issuer CN: Let's Encrypt Authority X3
  CT SCT Logs: 2

── Certificate 2 ──
  Common Name: *.example.com
  Issuer: DigiCert SHA2 Extended Validation Server CA
  ...

# JSON format for automation
$ trustpin-cli domains certificates api.example.com --output json
{
  "status": "success",
  "operation": "domains-certificates",
  "data": {
    "domain": "api.example.com",
    "certificates": [
      {
        "domain": "api.example.com",
        "commonName": "api.example.com",
        "issuer": "Let's Encrypt Authority X3",
        "sha256": "heXXXV6YUWtMPE/dUyZ6ESBpkOibPSeHseRAnp4dQJg=",
        "sha512": "...",
        "spkiSha256": "oxVSdCLgthL3M5Vnnzepq8WWlkUfRPYkpjLpm+wn+1o=",
        "spkiSha512": "...",
        "expiresAt": "2026-04-13T08:37:02Z",
        "transparencyInfo": {
          "sct_log_ids": ["log-id-1", "log-id-2"],
          "issuer_cn": "Let's Encrypt Authority X3"
        },
        "caaIssuer": "letsencrypt.org"
      }
    ]
  }
}

# Use with upsert to pin a discovered certificate
SPKI=$(trustpin-cli domains certificates api.example.com --output json | \
  jq -r '.data.certificates[0].spkiSha256')
trustpin-cli projects upsert $ORG_ID $PROJECT_ID \
  --domain api.example.com \
  --pin spki-sha256:$SPKI \
  --expires 2026-04-13T08:37:02Z
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

      - name: Extract certificate pins
        id: pins
        run: |
          # Extract SPKI SHA-256 from certificate
          SPKI_PIN=$(openssl x509 -in cert.pem -pubkey -noout | \
            openssl pkey -pubin -outform der | \
            openssl dgst -sha256 -binary | \
            base64)

          # Get expiration date
          EXPIRES=$(openssl x509 -in cert.pem -noout -enddate | \
            cut -d= -f2 | \
            xargs -I{} date -d "{}" -u +%Y-%m-%dT%H:%M:%SZ)

          echo "spki_pin=$SPKI_PIN" >> $GITHUB_OUTPUT
          echo "expires=$EXPIRES" >> $GITHUB_OUTPUT

      - name: Update certificate pin
        env:
          TRUSTPIN_API_TOKEN: ${{ secrets.TRUSTPIN_API_TOKEN }}
        run: |
          trustpin-cli projects upsert \
            ${{ vars.ORG_ID }} ${{ vars.PROJECT_ID }} \
            --domain api.example.com \
            --pin spki-sha256:${{ steps.pins.outputs.spki_pin }} \
            --expires ${{ steps.pins.outputs.expires }} \
            --output json

      - name: Sign and publish configuration
        env:
          TRUSTPIN_API_TOKEN: ${{ secrets.TRUSTPIN_API_TOKEN }}
        run: |
          trustpin-cli projects sign \
            ${{ vars.ORG_ID }} ${{ vars.PROJECT_ID }} \
            --password ${{ secrets.MASTER_PASSWORD }}
```

### AWS: Automated Certificate Pinning on ACM Renewal

When AWS Certificate Manager (ACM) automatically renews a certificate, this workflow detects the renewal via EventBridge, extracts the new certificate's pins, upserts them into TrustPin, and signs/publishes the configuration using a BYOK private key stored in AWS Secrets Manager.

#### Architecture

```
ACM Certificate Renewal
        │
        ▼
  EventBridge Rule ──▶ Lambda Function
  (ACM Action event)       │
                           ├── 1. Get certificate from ACM (aws sdk)
                           ├── 2. Extract SPKI pin (openssl)
                           ├── 3. Upsert pin (trustpin-cli projects upsert)
                           ├── 4. Fetch BYOK key from Secrets Manager
                           └── 5. Sign & publish (trustpin-cli projects sign --private-key)
```

**Prerequisites**:
- ACM certificate with automatic renewal enabled
- TrustPin project configured with BYOK (Bring Your Own Key)
- BYOK private key stored in AWS Secrets Manager
- TrustPin API token stored in AWS Secrets Manager

#### SAM Template (`template.yaml`)

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Transform: AWS::Serverless-2016-10-31
Description: >
  Automated TrustPin certificate pin updates on ACM certificate renewal.
  Detects ACM renewals via EventBridge, extracts pins, and publishes
  signed configuration using BYOK.

Parameters:
  TrustPinOrgId:
    Type: String
    Description: TrustPin organization ID
  TrustPinProjectId:
    Type: String
    Description: TrustPin project ID
  AcmCertificateArn:
    Type: String
    Description: ARN of the ACM certificate to monitor
  Domain:
    Type: String
    Description: Domain name associated with the certificate (e.g., api.example.com)
  TrustPinApiTokenSecretArn:
    Type: String
    Description: ARN of the Secrets Manager secret containing the TrustPin API token
  ByokPrivateKeySecretArn:
    Type: String
    Description: ARN of the Secrets Manager secret containing the BYOK private key (PEM)

Resources:
  # EventBridge rule: triggers on ACM certificate renewal
  AcmRenewalRule:
    Type: AWS::Events::Rule
    Properties:
      Description: Triggers on ACM certificate renewal completion
      EventPattern:
        source:
          - aws.acm
        detail-type:
          - "ACM Certificate Action"
        detail:
          ActionType:
            - RENEWAL
          CertificateArn:
            - !Ref AcmCertificateArn
      State: ENABLED
      Targets:
        - Id: TrustPinPinUpdater
          Arn: !GetAtt PinUpdaterFunction.Arn

  # Permission for EventBridge to invoke the Lambda
  AcmRenewalPermission:
    Type: AWS::Lambda::Permission
    Properties:
      FunctionName: !Ref PinUpdaterFunction
      Action: lambda:InvokeFunction
      Principal: events.amazonaws.com
      SourceArn: !GetAtt AcmRenewalRule.Arn

  # Lambda function: updates TrustPin pins on renewal
  PinUpdaterFunction:
    Type: AWS::Serverless::Function
    Properties:
      FunctionName: trustpin-acm-pin-updater
      Runtime: provided.al2023
      Handler: bootstrap
      Timeout: 120
      MemorySize: 256
      Architectures:
        - x86_64
      Environment:
        Variables:
          TRUSTPIN_ORG_ID: !Ref TrustPinOrgId
          TRUSTPIN_PROJECT_ID: !Ref TrustPinProjectId
          DOMAIN: !Ref Domain
          ACM_CERTIFICATE_ARN: !Ref AcmCertificateArn
          API_TOKEN_SECRET_ARN: !Ref TrustPinApiTokenSecretArn
          BYOK_KEY_SECRET_ARN: !Ref ByokPrivateKeySecretArn
      Policies:
        - Version: '2012-10-17'
          Statement:
            # Read the ACM certificate
            - Effect: Allow
              Action:
                - acm:GetCertificate
                - acm:DescribeCertificate
              Resource: !Ref AcmCertificateArn
            # Read secrets (API token + BYOK private key)
            - Effect: Allow
              Action:
                - secretsmanager:GetSecretValue
              Resource:
                - !Ref TrustPinApiTokenSecretArn
                - !Ref ByokPrivateKeySecretArn
```

#### Lambda Handler Script (`handler.sh`)

The Lambda uses a custom runtime (`provided.al2023`) to run a shell script with the TrustPin CLI binary bundled in the deployment package.

```bash
#!/bin/bash
set -euo pipefail

# --- Custom Lambda Runtime Loop ---
# Polls the Lambda Runtime API for invocation events and processes them.
RUNTIME_API="http://${AWS_LAMBDA_RUNTIME_API}/2018-06-01/runtime"

while true; do
  # Get next event
  HEADERS=$(mktemp)
  EVENT=$(curl -sS -D "$HEADERS" "${RUNTIME_API}/invocation/next")
  REQUEST_ID=$(grep -i "Lambda-Runtime-Aws-Request-Id" "$HEADERS" | tr -d '\r' | cut -d' ' -f2)

  # Process the event
  RESPONSE=$(process_event "$EVENT" 2>&1) && STATUS="success" || STATUS="error"

  if [ "$STATUS" = "success" ]; then
    curl -sS -X POST "${RUNTIME_API}/invocation/${REQUEST_ID}/response" \
      -d "{\"status\": \"success\", \"message\": \"$RESPONSE\"}"
  else
    curl -sS -X POST "${RUNTIME_API}/invocation/${REQUEST_ID}/error" \
      -d "{\"errorType\": \"PinUpdateError\", \"errorMessage\": \"$RESPONSE\"}"
  fi

  rm -f "$HEADERS"
done

process_event() {
  local EVENT="$1"
  local CERT_ARN="$ACM_CERTIFICATE_ARN"

  echo "Processing ACM renewal for certificate: $CERT_ARN"

  # Step 1: Retrieve TrustPin API token from Secrets Manager
  export TRUSTPIN_API_TOKEN=$(aws secretsmanager get-secret-value \
    --secret-id "$API_TOKEN_SECRET_ARN" \
    --query 'SecretString' --output text)

  # Step 2: Retrieve BYOK private key from Secrets Manager
  PRIVATE_KEY_FILE=$(mktemp /tmp/byok-key-XXXXXX.pem)
  aws secretsmanager get-secret-value \
    --secret-id "$BYOK_KEY_SECRET_ARN" \
    --query 'SecretString' --output text > "$PRIVATE_KEY_FILE"
  chmod 600 "$PRIVATE_KEY_FILE"

  # Step 3: Export the renewed certificate from ACM
  CERT_FILE=$(mktemp /tmp/cert-XXXXXX.pem)
  aws acm get-certificate \
    --certificate-arn "$CERT_ARN" \
    --query 'Certificate' --output text > "$CERT_FILE"

  # Step 4: Extract SPKI SHA-256 pin and expiration from the certificate
  SPKI_SHA256=$(openssl x509 -in "$CERT_FILE" -pubkey -noout | \
    openssl pkey -pubin -outform der | \
    openssl dgst -sha256 -binary | \
    base64)

  EXPIRES=$(openssl x509 -in "$CERT_FILE" -noout -enddate | \
    cut -d= -f2 | \
    xargs -I{} date -d "{}" -u +%Y-%m-%dT%H:%M:%SZ)

  echo "Extracted SPKI SHA-256: ${SPKI_SHA256:0:20}..."
  echo "Certificate expires: $EXPIRES"

  # Step 5: Upsert the pin into TrustPin
  ./trustpin-cli projects upsert \
    "$TRUSTPIN_ORG_ID" "$TRUSTPIN_PROJECT_ID" \
    --domain "$DOMAIN" \
    --pin "spki-sha256:${SPKI_SHA256}" \
    --expires "$EXPIRES" \
    --output json

  # Step 6: Sign and publish with BYOK private key
  ./trustpin-cli projects sign \
    "$TRUSTPIN_ORG_ID" "$TRUSTPIN_PROJECT_ID" \
    --private-key "$PRIVATE_KEY_FILE"

  # Cleanup sensitive files
  rm -f "$PRIVATE_KEY_FILE" "$CERT_FILE"

  echo "Pin updated and configuration published for $DOMAIN"
}
```

#### Deployment

```bash
# 1. Create the deployment package
mkdir -p build
cp handler.sh build/bootstrap
chmod +x build/bootstrap

# Download the TrustPin CLI Linux binary into the package
curl -L https://github.com/trustpin-cloud/cloud-console-cli/releases/latest/download/trustpin-cli-linux-x64 \
  -o build/trustpin-cli
chmod +x build/trustpin-cli

cd build && zip -r ../function.zip . && cd ..

# 2. Store secrets in AWS Secrets Manager
aws secretsmanager create-secret \
  --name trustpin/api-token \
  --secret-string "tp_your_token_here"

aws secretsmanager create-secret \
  --name trustpin/byok-private-key \
  --secret-string file://private-key.pem

# 3. Deploy with SAM
sam deploy \
  --template-file template.yaml \
  --stack-name trustpin-acm-auto-pin \
  --capabilities CAPABILITY_IAM \
  --parameter-overrides \
    TrustPinOrgId=fb52418e-b5ae-4bff-b973-6da9ae07ba00 \
    TrustPinProjectId=9caaea0a-013e-4e7b-80ea-cee6bfb52b36 \
    AcmCertificateArn=arn:aws:acm:us-east-1:123456789012:certificate/abc-def-123 \
    Domain=api.example.com \
    TrustPinApiTokenSecretArn=arn:aws:secretsmanager:us-east-1:123456789012:secret:trustpin/api-token-AbCdEf \
    ByokPrivateKeySecretArn=arn:aws:secretsmanager:us-east-1:123456789012:secret:trustpin/byok-private-key-GhIjKl

# 4. Test with a manual invocation
aws lambda invoke \
  --function-name trustpin-acm-pin-updater \
  --payload '{"detail":{"ActionType":"RENEWAL"}}' \
  response.json && cat response.json
```

**What happens on ACM renewal**:
1. ACM renews the certificate (automatic, managed by AWS)
2. EventBridge detects the `ACM Certificate Action` event with `ActionType: RENEWAL`
3. Lambda is invoked automatically
4. Lambda exports the renewed certificate from ACM via the AWS SDK
5. Extracts the SPKI SHA-256 pin and expiration using `openssl`
6. Upserts the pin into TrustPin with `trustpin-cli projects upsert`
7. Signs and publishes the configuration using the BYOK private key with `trustpin-cli projects sign --private-key`
8. Mobile apps fetch the updated configuration from the CDN on their next refresh

**Important**: ACM generates new key pairs on renewal (key reuse is not supported). This means the SPKI pin **will change** on every renewal. This workflow handles that automatically by upserting the new pin before the old certificate expires. Consider keeping both old and new pins active to allow mobile apps time to fetch the updated configuration.

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