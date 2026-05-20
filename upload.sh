#!/bin/bash

# Upload script for Credit Card Guardrails Agent
# This script initializes Git, creates a GitHub repository, and pushes the code

set -e  # Exit on error

REPO_NAME="wxo-credit-card-guardrails"
REPO_DESCRIPTION="watsonx Orchestrate agent demonstrating security guardrails through credit card number redaction"

echo "=========================================="
echo "GitHub Repository Upload Script"
echo "=========================================="
echo ""
echo "Repository: $REPO_NAME"
echo "Description: $REPO_DESCRIPTION"
echo ""

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ Error: GitHub CLI (gh) not found."
    echo "   Install from: https://cli.github.com/"
    echo ""
    echo "   macOS: brew install gh"
    echo "   Linux: See https://github.com/cli/cli/blob/trunk/docs/install_linux.md"
    exit 1
fi

echo "✓ GitHub CLI found"
echo ""

# Check if already authenticated
echo "🔐 Checking GitHub authentication..."
if gh auth status &> /dev/null; then
    echo "✓ Already authenticated with GitHub"
    gh auth status
else
    echo "⚠️  Not authenticated with GitHub"
    echo ""
    echo "Starting GitHub authentication..."
    echo "Please follow the prompts to authenticate."
    echo ""
    
    # Authenticate with GitHub
    gh auth login
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✓ Successfully authenticated with GitHub"
    else
        echo ""
        echo "❌ Authentication failed"
        exit 1
    fi
fi

echo ""
echo "=========================================="
echo "Initializing Git Repository"
echo "=========================================="
echo ""

# Check if already a git repository
if [ -d .git ]; then
    echo "⚠️  Git repository already exists"
    read -p "Do you want to reinitialize? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf .git
        git init
        echo "✓ Git repository reinitialized"
    else
        echo "✓ Using existing Git repository"
    fi
else
    git init
    echo "✓ Git repository initialized"
fi

echo ""

# Configure git if needed
if [ -z "$(git config user.name)" ]; then
    echo "⚠️  Git user.name not configured"
    read -p "Enter your name: " git_name
    git config user.name "$git_name"
    echo "✓ Git user.name configured"
fi

if [ -z "$(git config user.email)" ]; then
    echo "⚠️  Git user.email not configured"
    read -p "Enter your email: " git_email
    git config user.email "$git_email"
    echo "✓ Git user.email configured"
fi

echo ""
echo "=========================================="
echo "Staging Files"
echo "=========================================="
echo ""

# Add all files
git add .

echo "✓ Files staged"
echo ""

# Show what will be committed
echo "Files to be committed:"
git status --short
echo ""

# Commit
echo "📝 Creating commit..."
git commit -m "Initial commit: Credit Card Guardrails Agent

- Pre-invoke guardrail plugin for credit card redaction
- Billing address update tool
- Credit card agent configuration
- Complete documentation and deployment scripts"

if [ $? -eq 0 ]; then
    echo "✓ Commit created successfully"
else
    echo "❌ Commit failed"
    exit 1
fi

echo ""
echo "=========================================="
echo "Creating GitHub Repository"
echo "=========================================="
echo ""

# Check if repository already exists
if gh repo view "$REPO_NAME" &> /dev/null; then
    echo "⚠️  Repository '$REPO_NAME' already exists on GitHub"
    read -p "Do you want to use the existing repository? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Aborted. Please choose a different repository name."
        exit 1
    fi
    echo "✓ Using existing repository"
else
    # Create repository
    echo "Creating repository '$REPO_NAME'..."
    gh repo create "$REPO_NAME" --public --description "$REPO_DESCRIPTION" --source=. --remote=origin
    
    if [ $? -eq 0 ]; then
        echo "✓ Repository created successfully"
    else
        echo "❌ Failed to create repository"
        exit 1
    fi
fi

echo ""
echo "=========================================="
echo "Pushing to GitHub"
echo "=========================================="
echo ""

# Rename branch to main if needed
current_branch=$(git branch --show-current)
if [ "$current_branch" != "main" ]; then
    echo "Renaming branch to 'main'..."
    git branch -M main
    echo "✓ Branch renamed to main"
fi

# Push to GitHub
echo "Pushing to GitHub..."
git push -u origin main --force

if [ $? -eq 0 ]; then
    echo "✓ Successfully pushed to GitHub"
else
    echo "❌ Push failed"
    exit 1
fi

echo ""
echo "=========================================="
echo "✅ Upload Complete!"
echo "=========================================="
echo ""
echo "Your repository is now available at:"
gh repo view --web --json url -q .url
echo ""
echo "Next steps:"
echo "  1. View your repository: gh repo view --web"
echo "  2. Clone on another machine: gh repo clone $REPO_NAME"
echo "  3. Share with others: $(gh repo view --json url -q .url)"
echo ""

# Made with Bob
