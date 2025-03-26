#!/bin/bash

# One-Click Installer for Seismic Devnet Deployment
set -e

# Update & install dependencies
echo "Updating system and installing dependencies..."
apt update && apt install -y curl jq unzip

# Install Rust
echo "Installing Rust..."
curl https://sh.rustup.rs -sSf | sh -s -- -y
source "$HOME/.cargo/env"

# Install sfoundryup
echo "Installing sfoundryup..."
curl -L -H "Accept: application/vnd.github.v3.raw" \
     "https://api.github.com/repos/SeismicSystems/seismic-foundry/contents/sfoundryup/install?ref=seismic" | bash
source ~/.bashrc

# Run sfoundryup
echo "Running sfoundryup... This may take some time."
sfoundryup

# Clone Seismic Devnet repository
echo "Cloning Seismic Devnet repository..."
git clone --recurse-submodules https://github.com/SeismicSystems/try-devnet.git
cd try-devnet/packages/contract/

# Deploy contract
echo "Deploying contract..."
bash script/deploy.sh

# Install Bun
echo "Installing Bun..."
curl -fsSL https://bun.sh/install | bash
source ~/.bashrc

# Install Node dependencies
echo "Installing Node dependencies..."
cd ../cli/
bun install

# Execute transactions
echo "Executing transactions..."
bash script/transact.sh

echo "✅ Seismic Devnet setup & deployment completed successfully!"
