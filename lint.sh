#!/bin/bash
set -euo pipefail

# Lua linting script for Neovim configuration

echo "🔍 Running luacheck on Neovim configuration..."
echo "=================================="

luacheck .

echo ""
echo "💡 Quick luacheck commands:"
echo "  luacheck .              # Check all files"
echo "  luacheck init.lua       # Check specific file"
echo "  luacheck --help         # Show help"
echo ""
echo "📝 Config file: .luacheckrc"
