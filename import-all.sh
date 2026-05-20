#!/bin/bash

# Import script for Credit Card Guardrails Agent
# This script imports all tools and agents into watsonx Orchestrate

set -e  # Exit on error

echo "=========================================="
echo "Credit Card Guardrails Agent - Import"
echo "=========================================="
echo ""

# Check if wxo CLI is available
if ! command -v wxo &> /dev/null; then
    echo "❌ Error: wxo CLI not found. Please install IBM watsonx Orchestrate ADK."
    echo "   Install with: pip install ibm-watsonx-orchestrate"
    exit 1
fi

echo "✓ wxo CLI found"
echo ""

# Import tools first (plugins and regular tools)
echo "📦 Importing tools..."
echo ""

echo "  → Importing guardrail pre-invoke plugin..."
wxo tool import --kind python --path tools/guardrail_cc_preinvoke.py
if [ $? -eq 0 ]; then
    echo "    ✓ guardrail_cc_preinvoke imported successfully"
else
    echo "    ❌ Failed to import guardrail_cc_preinvoke"
    exit 1
fi
echo ""

echo "  → Importing update billing address tool..."
wxo tool import --kind python --path tools/update_billing_address.py
if [ $? -eq 0 ]; then
    echo "    ✓ update_billing_address imported successfully"
else
    echo "    ❌ Failed to import update_billing_address"
    exit 1
fi
echo ""

# Import agents
echo "🤖 Importing agents..."
echo ""

echo "  → Importing credit card agent..."
wxo agent import --path agents/credit_card_agent.yaml
if [ $? -eq 0 ]; then
    echo "    ✓ credit_card_agent imported successfully"
else
    echo "    ❌ Failed to import credit_card_agent"
    exit 1
fi
echo ""

echo "=========================================="
echo "✅ Import completed successfully!"
echo "=========================================="
echo ""
echo "Next steps:"
echo "  1. Test the agent in watsonx Orchestrate"
echo "  2. Try: 'I need to update my billing address for card 1234 5678 9012 3456'"
echo "  3. Verify the credit card number is redacted to: **** **** **** 3456"
echo ""

# Made with Bob
