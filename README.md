# OFT System Repository

This repository contains the system-level requirements for the OFT project.

## Project Structure

The OFT project follows a simplified multi-repo structure:

```
oft-system/                  # System requirements repository
├── requirements.md          # System requirements with OFT syntax
├── daemon.ps1               # Local verification script
└── .github/workflows/       # CI/CD configuration

oft-ios/                     # iOS component repository
├── requirements.md          # iOS requirements
├── src/                     # Implementation
└── tests/                   # Tests

oft-android/                 # Android component repository  
├── requirements.md          # Android requirements
├── src/                     # Implementation
└── test/                    # Tests
```

## Requirements

System requirements are defined in `requirements.md` using the [OpenFastTrace](https://github.com/itsallcode/openfasttrace) syntax.

OpenFastTrace (OFT) enables requirements traceability throughout a multi-repository project. Each requirement is written with specific syntax tags that OFT can parse to generate a traceability matrix.

## How Requirements are Defined

OFT uses a specific syntax for defining requirements:

```markdown
[req~requirement-id~version]
The requirement text that describes what must be implemented.
```

For example:
```markdown
[req~sys.string-return~1]
All platforms must be capable of returning the string "foo" when asked.
```

## How Traceability Works

1. **System Requirements**: Defined in `requirements.md` with the `[req~...]` syntax.

2. **Component Requirements**: Each platform (iOS, Android) defines requirements that cover system requirements using the `[covers~...]` syntax. 

3. **Implementation & Tests**: Code and tests are tagged with `[impl->req~...]` and `[utest->req~...]` to trace coverage.

4. **Verification**: OFT automatically generates a traceability matrix showing which requirements are fully covered.

## OpenFastTrace CI Integration

Our GitHub Actions workflows:

1. Run OpenFastTrace to analyze each component repository
2. Generate verification artifacts as Markdown reports
3. Combine component reports with system requirements
4. Create a comprehensive verification matrix

## Running the Verification Daemon

To check the current verification status:

```powershell
# From the oft-system directory
./daemon.ps1
```

This will:
1. Pull the latest verification matrix from GitHub Actions
2. Display the coverage report
3. Optionally run a local OFT analysis

## Installing OpenFastTrace

```bash
# Install OFT locally
pip install openfasttrace

# Run basic analysis
oft import -i .
oft report
```

For more advanced usage, see the [OpenFastTrace documentation](https://github.com/itsallcode/openfasttrace). 