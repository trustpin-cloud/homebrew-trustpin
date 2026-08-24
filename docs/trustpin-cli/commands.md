---
layout: default
title: Command Reference
---

# Command Reference

[Home](index.md) · **Commands** · [Automation & CI/CD](automation.md) · [Troubleshooting](troubleshooting.md)

```
trustpin-cli
├── configure                  Configure API credentials
├── user
│   └── info                   Show current user and organizations
├── projects
│   ├── list                   List projects
│   ├── get                    Show project details
│   ├── config                 Get configuration as JWS payload (JSON)
│   ├── upsert                 Add or update a certificate pin
│   ├── cleanup                Remove expired certificate pins
│   ├── sign                   Sign and publish configuration as JWS
│   ├── refresh-certs          Fetches updated certificate pins for a domain
│   └── jws                    Fetch the published JWS from the CDN
└── domains
    └── certificates           Look up certificates and pins for a domain
```

### Global flags

Available on every command:

| Flag | Description |
|---|---|
| `--verbose` | Verbose output: config file location, API URLs, HTTP status codes |
| `--debug` | Debug output |
| `--log-http` | Log HTTP requests and responses |
| `--version` | Print the CLI version |

Most commands also accept `--output json` for machine-readable output (see [Automation & CI/CD](automation.md)).

---

## configure

Configure the CLI with your TrustPin API credentials. Runs interactively when flags are omitted.

```bash
trustpin-cli configure [--api-base-url <url>] [--api-token <token>]
```

```text
$ trustpin-cli configure
API Base URL (https://api.trustpin.cloud): https://api.trustpin.cloud
API Token: tp_your_token_here
Configuration saved successfully!
```

Credentials are stored in `~/.trustpin/cli/config.properties`. You can also configure the CLI entirely through environment variables — see [Automation & CI/CD](automation.md#environment-variables).

---

## user info

Show the authenticated user and their organizations. Useful as a quick credentials check, and for finding your organization ID.

```bash
trustpin-cli user info [--output json]
```

```text
$ trustpin-cli user info
═══ User Information ═══
ID: 6f0c1a2b-3d4e-5f60-7182-93a4b5c6d7e8
Name: Jane Developer
Email: jane@example.com

── Organizations ──
• Example Org (0a1b2c3d-4e5f-6071-8293-a4b5c6d7e8f9)
```

---

## projects list

List all projects you have access to, with their IDs, type, domain count, and publish status.

```bash
trustpin-cli projects list [--output json]
```

```bash
# Extract project names for scripting
trustpin-cli projects list --output json | jq -r '.data.projects[].name'
```

---

## projects get

Show detailed information about one project: configuration and published versions, public key, and per-domain pin counts. Warns when the latest configuration version has not been published yet.

```bash
trustpin-cli projects get <organization-id> <project-id> [--output json]
```

```text
$ trustpin-cli projects get 0a1b2c3d-4e5f-6071-8293-a4b5c6d7e8f9 9f8e7d6c-5b4a-3928-1706-f5e4d3c2b1a0
═══ Project Details ═══
Name: Example Mobile App
Type: Managed CDN with Cloud Keys
Configuration Version: 3
Published Version: 2
⚠️  Warning: Latest configuration (v3) is not yet published (v2)
Domains: 2
    • Domain: example.com        (1 pin)
    • Domain: api.example.com    (1 pin)
```

---

## projects config

Print the project's current (stored, not necessarily published) configuration in JWS payload format. Output is always JSON.

```bash
trustpin-cli projects config <organization-id> <project-id>
```

---

## projects upsert

Add a certificate pin to a domain in a project, or update an existing pin's expiration. If the domain does not exist in the project yet, it is added.

```bash
trustpin-cli projects upsert <organization-id> <project-id> \
  --domain <fqdn> \
  --pin <type>:<value> \
  [--expires <ISO8601-datetime>] \
  [--dry-run] \
  [--output json]
```

| Flag | Description |
|---|---|
| `--domain` | Domain name (FQDN) — required |
| `--pin` | Pin as `<type>:<value>` — required |
| `--expires` | Pin expiration (ISO 8601, e.g. `2026-04-13T08:37:02Z`) |
| `--dry-run` | Show the request that would be sent without submitting it |

**Pin types**

| Type | Meaning |
|---|---|
| `spki-sha256` | SPKI SHA-256 fingerprint (recommended) |
| `spki-sha512` | SPKI SHA-512 fingerprint |
| `sha256` | Certificate SHA-256 fingerprint |
| `sha512` | Certificate SHA-512 fingerprint |

SPKI pins are recommended because they pin the public key rather than a specific certificate, so they survive certificate renewals that reuse the same key pair.

```bash
$ trustpin-cli projects upsert $ORG_ID $PROJECT_ID \
    --domain api.example.com \
    --pin spki-sha256:oxVSdCLgthL3M5Vnnzepq8WWlkUfRPYkpjLpm+wn+1o= \
    --expires 2026-04-13T08:37:02Z
✓ Domain: api.example.com
  • Added pin: spki-sha256:oxVSdCLgth... (expires 2026-04-13T08:37:02Z)

✓ Project updated successfully
  Configuration version: 5 → 6
  ⚠️  Remember to sign and publish: trustpin-cli projects sign ...
```

> **Note:** `upsert` updates the stored configuration only. Changes are not live until you run [`projects sign`](#projects-sign).

Combine with `domains certificates` to pin a discovered certificate in one step:

```bash
SPKI=$(trustpin-cli domains certificates api.example.com --output json | \
  jq -r '.data.certificates[0].spkiSha256')

trustpin-cli projects upsert $ORG_ID $PROJECT_ID \
  --domain api.example.com \
  --pin spki-sha256:$SPKI \
  --expires 2026-04-13T08:37:02Z
```

---

## projects cleanup

Remove already-expired certificate pins from every domain in a project.

```bash
trustpin-cli projects cleanup <organization-id> <project-id> [--dry-run] [--output json]
```

- Only pins whose expiration is set **and in the past** are removed; pins without an expiry are kept.
- Domains are never removed — a domain left with zero pins remains in the project.
- The configuration version is incremented only when at least one pin is removed, and the operation is idempotent.
- Use `--dry-run` to see how many pins would be removed without changing anything, and add `--verbose` for a per-domain breakdown.

```text
$ trustpin-cli projects cleanup $ORG_ID $PROJECT_ID --dry-run
Dry run: 2 expired pin(s) would be removed (no changes made)

  Run without --dry-run to remove them: trustpin-cli projects cleanup ...

$ trustpin-cli projects cleanup $ORG_ID $PROJECT_ID
Removed 2 expired pin(s)

  ⚠️  Remember to sign and publish: trustpin-cli projects sign ...
```

> **Note:** like `upsert`, `cleanup` updates the stored configuration only — run [`projects sign`](#projects-sign) afterwards to publish.

---

## projects refresh-certs

Refresh the certificate pins for **one domain** from the certificates TrustPin can currently see.

```bash
trustpin-cli projects refresh-certs <organization-id> <project-id> \
  --domain <fqdn> [--remove-expired] [--dry-run] [--output json]
```

| Flag | Description |
|---|---|
| `--domain` | Domain name (FQDN) to refresh — **required** |
| `--remove-expired` | Also drop pins **for this domain** whose expiry is in the past |
| `--dry-run` | Show the PATCH request without submitting it |

Where `upsert` requires you to supply a pin by hand, `refresh-certs` looks the certificates up for you: the **live** certificate presented in a TLS handshake, plus every unexpired issuance found in the public **Certificate Transparency** logs. If the domain is not yet in the project, it is added.

- Pins are written as **SPKI SHA-256** — the digest that survives a renewal reusing the same key, and the only one available for CT entries recorded as precertificates.
- **Existing pins are never discarded.** A certificate that is already pinned has its expiry refreshed rather than being pinned twice, including when the existing pin was added by `upsert` using a different digest type. A pin the lookup did not return is left alone.
- **If the lookup fails or returns no certificates, nothing changes at all** — including expired-pin removal — so a transient DNS or TLS failure can never strip a domain's pins.
- Re-running the command when nothing has changed sends no request, so the configuration version is not bumped for no reason.

```text
$ trustpin-cli projects refresh-certs $ORG_ID $PROJECT_ID --domain api.example.com
Domain: api.example.com
  7 certificate(s) returned by TrustPin

  + Added   spki-sha256:heXXXV6YUWtMPE... (expires 2027-01-14T00:00:00Z)
  ~ Updated spki-sha256:Ab12Cd34Ef56Gh... (expiry 2026-07-01T00:00:00Z -> 2027-03-02T00:00:00Z)
  = 4 pin(s) already up to date

Project updated successfully
  Configuration version: 12 -> 13
  Remember to sign and publish: trustpin-cli projects sign ...
```

> **Note:** `--remove-expired` is scoped to the domain you name. To sweep expired pins across **every** domain in the project, use [`projects cleanup`](#projects-cleanup) instead.

> **Note:** like `upsert` and `cleanup`, `refresh-certs` updates the stored configuration only — run [`projects sign`](#projects-sign) afterwards to publish.

---

## projects sign

Sign the project's current configuration as a JWS and publish it to the TrustPin CDN. This is what makes staged changes live for your apps.

```bash
trustpin-cli projects sign <organization-id> <project-id> \
  [--private-key <path>] [--password <password>] [--output json]
```

| Flag | Description |
|---|---|
| `-k, --private-key` | Path to a PEM private key file — required for BYOK projects |
| `-p, --password` | Master password for private key decryption (prompted interactively if omitted) |
| `--dry-run` | Sign and verify locally without publishing — nothing is uploaded |

### Rehearsing with `--dry-run`

`--dry-run` performs every step of a real run — loads the configuration, reads and decrypts the private key, checks it against the project's public key, signs the payload and verifies the resulting signature — and then stops before the upload. Nothing about the project changes.

That makes it the way to confirm a key file and master password are correct, **and that they belong to this project**, before committing to a publish. A mismatched key still fails with `INVALID_KEY_PAIR`; a wrong password still fails with `INCORRECT_PASSWORD`.

```text
$ trustpin-cli projects sign $ORG_ID $PROJECT_ID --private-key key.pem --dry-run
[1/4] Getting project information
[2/4] Loading project configuration
[3/4] Preparing private key
  Key pair validation successful
[4/4] Creating and signing JWT
  JWS signature verified successfully
  Dry run: signature verified locally, nothing was uploaded
Dry run successful - nothing was published

═══ Dry Run Summary ═══
  Project: my-app
  Signature Valid: Yes
  Key Source: BYOK
  Published: No (dry run)
  Domains: 2
```

A dry run reports **four** steps rather than five, because the upload step does not happen.

### Seeing the signed JWS

Both `--dry-run` and `--verbose` print the signed token, so you can inspect or verify it yourself:

```text
═══ Signed JWS ═══
  Header: eyJhbGciOiJFUzI1NiIsImtpZCI6...
  Payload: eyJkb21haW5zIjpbeyJkb21haW4i (354 chars)
  Signature: uwgnUpsq42OXoTnS2ZfY9fmeDI0y...
  Length: 533 chars

eyJhbGciOiJFUzI1NiIs....eyJkb21haW5zIjpb....uwgnUpsq42OXoTnS2Zf
```

The full compact serialization is printed on its own line so it can be copied or piped into a verifier. In `--output json` the same value appears as `data.jws`. It is only included when asked for, because it is long — it is not a secret, since the identical token is served from the public CDN once published.


**Cloud-managed keys** — for projects of type *Managed CDN with Cloud Keys*, no key file is needed; you'll be prompted for your master password:

```text
$ trustpin-cli projects sign $ORG_ID $PROJECT_ID
Master password: ****
[1/5] Getting project information
[2/5] Loading project configuration
[3/5] Preparing private key
[4/5] Creating and signing JWT
[5/5] Uploading signed configuration
Configuration published successfully!
```

**Bring Your Own Key (BYOK)** — for BYOK projects, supply your private key:

```bash
trustpin-cli projects sign $ORG_ID $PROJECT_ID --private-key ./my-private-key.pem
```

---

## projects jws

Fetch the currently **published** JWS configuration from the CDN — the exact payload your mobile apps are fetching.

```bash
trustpin-cli projects jws <organization-id> <project-id> \
  [--verify] [--decode] [--output-file <path>]
```

| Flag | Description |
|---|---|
| `--verify` | Verify the JWS signature using the public key from the CDN |
| `--decode` | Decode and display the JWS header and payload |
| `--output-file` | Save the raw JWS to a file |

```text
$ trustpin-cli projects jws $ORG_ID $PROJECT_ID --decode
JWS Header:
  Algorithm: ES256
  Type: JWT

Payload:
  Spec: v1.0.0
  Version: 3
  Issued At: 2026-06-11T13:24:44Z
  Domains: 1
    - api.example.com (2 pins)

Current DB Version: 3
Published Version: 3

Published version is up to date
```

Use cases:

- **Verify what's live** — check the configuration currently served to production apps
- **Validate signing** — confirm that `projects sign` actually published
- **Debug pinning issues** — compare what the app fetches with what you expect
- **Testing & auditing** — save the JWS for local testing (`--output-file`) or compliance archives

---

## domains certificates

Look up all known SSL/TLS certificates for a domain: the live certificate plus any discovered via Certificate Transparency logs. Every certificate is reported with all four pin formats, its validity window, subject alternative names, key and signature details, CAA issuer, and CT log information — ready to use with `projects upsert`, or applied automatically by [`projects refresh-certs`](#projects-refresh-certs).

```bash
trustpin-cli domains certificates <domain-name> [--output json]
```

Each entry is labelled with where it was observed — `(live)` for the certificate the server actually presents in a TLS handshake, `(Certificate Transparency)` for one found in the public logs — and a summary line counts each.

```text
$ trustpin-cli domains certificates api.example.com

═══ Certificates for api.example.com ═══
  Total certificates: 2
  Sources: 1 live, 1 from Certificate Transparency

── Certificate 1 (live) ──
  Common Name: api.example.com
  Issuer: CN=R11,O=Let's Encrypt,C=US
  Subject Alt Names: api.example.com, www.example.com
  Valid From: 2026-03-01T00:00:00Z
  Expires At: 2026-12-31T23:59:59Z
  Public Key: EC 256 bits
  Signature Algorithm: SHA256-RSA
  SHA-256: heXXXV6YUWtMPE/dUyZ6ESBpkOibPSeHseRAnp4dQJg=
  SPKI SHA-256: oxVSdCLgthL3M5Vnnzepq8WWlkUfRPYkpjLpm+wn+1o=
  CAA Issuer: letsencrypt.org
  CT SCT Logs: 2

── Certificate 2 (Certificate Transparency) ──
  Common Name: api.example.com
  Issuer: CN=R10,O=Let's Encrypt,C=US
  Expires At: 2027-01-31T23:59:59Z
  SHA-256: (not available for this record)
  SHA-512: (not available for this record)
  SPKI SHA-256: fFq2hLnpGYtMuP8wR3vKdN7xZaQcEj5TbVm1oXsY9Uk=
```

Two things worth knowing when reading the output:

- **`(not available for this record)` is expected, not an error.** A CT log entry that holds only the *precertificate* has no usable certificate digest — a precertificate's hash never matches what a server sends, so the API withholds it rather than offering an unpinnable value. The **SPKI** digest is shared between a certificate and its precertificate, which is why it is always present and why it is the pin TrustPin recommends.
- **`Valid From` may be flagged `(not yet valid)`.** A certificate issued ahead of its deployment can be pinned before the server starts serving it, so it is shown rather than hidden.

`--output json` returns every field of the API response verbatim, including `source`, `subjectAlternativeNames`, `notBefore`, `keyAlgorithm`, `keySize` and `signatureAlgorithm`.
