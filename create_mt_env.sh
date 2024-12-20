#!/bin/bash

# Creates virtual environment for Project Acholi MT24
# Exit on error
set -e

# Environment name and path
ENV_NAME="acholi_mt_env"
ENV_PATH="$HOME/envs/$ENV_NAME"

# Function to print messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Function to check if a command was successful
check_status() {
    if [ $? -eq 0 ]; then
        log_message "✓ $1 successful"
    else
        log_message "✗ Error during $1"
        exit 1
    fi
}

# Load required Python module
log_message "Loading Python 3.9.5 module..."
module load python/3.9.5
check_status "Python module load"

# Create virtual environment directory if it doesn't exist
mkdir -p $HOME/envs

# Create virtual environment
log_message "Creating virtual environment at $ENV_PATH..."
python -m venv $ENV_PATH
check_status "Virtual environment creation"

# Activate the virtual environment
log_message "Activating virtual environment..."
source "$ENV_PATH/bin/activate"
check_status "Virtual environment activation"

# Create tools directory for Moses
TOOLS_PATH="$ENV_PATH/tools"
log_message "Creating tools directory..."
mkdir -p $TOOLS_PATH
check_status "Tools directory creation"

# Clone and set up Moses
log_message "Setting up Moses..."
cd $TOOLS_PATH
if [ ! -d "mosesdecoder" ]; then
    git clone https://github.com/moses-smt/mosesdecoder.git
    check_status "Moses clone"
else
    log_message "Moses already exists, skipping clone"
fi
cd - # Return to original directory

# Upgrade pip
log_message "Upgrading pip..."
pip install --upgrade pip
check_status "pip upgrade"

# Install dependencies in order with specific versions
log_message "Installing packages with specific versions..."

# Install urllib3 first with compatible version
pip install 'urllib3<2.0.0'
check_status "urllib3 installation"

# Install requests
pip install requests
check_status "requests installation"

# First install PyOnmtTok (required by OpenNMT-py)
pip install "pyonmttok>=1.37,<2"
check_status "pyonmttok installation"

# Install torch with specific version
pip install "torch>=2.0.1,<2.2"
check_status "PyTorch installation"

# Install OpenNMT with specific version
pip install "OpenNMT-py==3.4.3"
check_status "OpenNMT-py installation"
 
# Install other dependencies
log_message "Installing additional packages..."
pip install "datasets>=2.14.0"
check_status "datasets installation"

pip install subword-nmt
check_status "subword-nmt installation"

pip install "nltk>=3.8"
check_status "NLTK installation"

pip install "sentencepiece>=0.1.99"
check_status "sentencepiece installation"

pip install "sacrebleu>=2.3"
check_status "sacrebleu installation"

pip install "numpy<2.0" #downgraded because of conflicts during training
check_status "numpy installation"

pip install "unbabel-comet"
check_status "comet installation"

# Download NLTK data to user's home directory
log_message "Downloading NLTK data..."
python -m nltk.downloader -d ~/nltk_data punkt
check_status "NLTK data download"

# Create activation script
ACTIVATE_SCRIPT="$HOME/envs/activate_${ENV_NAME}.sh"
log_message "Creating activation script at $ACTIVATE_SCRIPT..."

cat > "$ACTIVATE_SCRIPT" << EOL
#!/bin/bash
# Activation script for ${ENV_NAME}

# Load required Python module
module load python/3.9.5

# Activate the virtual environment
source "${ENV_PATH}/bin/activate"

# Add OpenNMT command-line tools to PATH
export PATH="\$VIRTUAL_ENV/bin:\$PATH"

# Add Moses tools to PATH
export PATH="\$PATH:${TOOLS_PATH}/mosesdecoder/scripts"
export PATH="\$PATH:${TOOLS_PATH}/mosesdecoder/scripts/tokenizer"
export PATH="\$PATH:${TOOLS_PATH}/mosesdecoder/scripts/recaser"

# Print confirmation
echo "\$(date '+%Y-%m-%d %H:%M:%S') - ${ENV_NAME} environment activated"
echo "Python version: \$(python --version)"
echo "Using python at: \$(which python)"
echo "OpenNMT tools available at: \$(which onmt_build_vocab 2>/dev/null || echo 'Not found')"
echo "Moses scripts available at: ${TOOLS_PATH}/mosesdecoder/scripts"
EOL

chmod +x "$ACTIVATE_SCRIPT"
check_status "Activation script creation"

# Create a README file with usage instructions
README_FILE="$HOME/envs/README_${ENV_NAME}.md"
cat > "$README_FILE" << EOL
# ${ENV_NAME} Environment Setup

This environment is set up for Project Acholi MT24 with OpenNMT-py and related tools.

## Activation
To activate this environment:
\`\`\`bash
source ~/envs/activate_${ENV_NAME}.sh
\`\`\`

## Included Tools
- OpenNMT-py ${ONMT_VERSION}
- PyTorch
- NLTK
- sentencepiece
- subword-nmt
- sacrebleu
- Moses SMT tools (tokenizer, truecaser, cleaning scripts)
- numpy < version 2.0

## Verification
After activation, you can verify the setup:
\`\`\`bash
# Check OpenNMT command availability
which onmt_build_vocab
which onmt_train
which onmt_translate

# Check Python packages
pip list | grep -E "OpenNMT-py|torch|nltk|sentencepiece|sacrebleu"

# Check Moses scripts availability
ls ${TOOLS_PATH}/mosesdecoder/scripts/tokenizer/tokenizer.perl
ls ${TOOLS_PATH}/mosesdecoder/scripts/recaser/truecase.perl
\`\`\`

## Notes
- The environment adds OpenNMT command-line tools to your PATH
- Moses scripts are available in PATH
- NLTK data is installed in ~/nltk_data
EOL

log_message "Setup completed successfully! Environment is ready to use."
log_message "To activate this environment in the future, run:"
log_message "source ~/envs/activate_${ENV_NAME}.sh"
log_message "See $README_FILE for more information"

# Deactivate the virtual environment
deactivate