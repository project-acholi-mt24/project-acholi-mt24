# project-acholi-mt24
This repository hosts code for a low-resource language machine translation project involving the Acholi language. The project is a part of the course Machine Translation (5LN711) at Uppsala University, Fall 2024.

## Scripts for data extraction and preprocessing

### 1. extract_data.py

This script extracts parallel data from the Sunbird/salt dataset on Hugging Face.

**Usage:**
```
python extract_data.py
```

This script will extract raw Acholi-English parallel data

### 2. preprocess.sh

This bash script preprocesses the extracted data for use with Moses SMT.

**Usage:**
```
./preprocess.sh
```

This script will:
- Tokenize the Acholi and English texts
- Lowercase all tokens
- Clean the training corpus (remove long sentences and empty lines)
- Save the preprocessed files
## Setup

1. Clone this repository:
   ```
   git clone https://github.com/project-acholi-mt24/project-acholi-mt24.git
   cd project-acholi-mt24
   ```

2. Install required Python packages:
   ```
   pip install datasets
   ```

3. Run the data extraction script:
   ```
   python extract_data.py
   ```

4. Run the preprocessing script:
   ```
   chmod +x preprocess.sh
   ./preprocess.sh
   ```
______________________________________________________________________________________________
## How to create virtual environment on the server (UPPMAX)

1. In the appropriate directory (/proj/uppmax2024-2-13/private/acholi_mt24/project-acholi-mt24),
run the script for creating a virtual environment:
```
bash  create_mt_env.sh
	OR	
chmod +x create_mt_env.sh
./create_mt_env.sh
```

2. Activate the environment: 
```
source ~/envs/activate_acholi_mt_env.sh
```
3. When done, deactivate environment:
```
deactivate
```
__________________________________________________
Some more files:

### create_mt_env.sh

This script will:
- Create virtual environment on the server (UPPMAX) (see details above)

### preprocess_onmt.py:

This script will:

- Create a .yaml config-file for pretraining operations
- Encode data using BPE using subword-nmt
- Create a vocabulary for use with OpenNMT

### analyze_line_endings.py:

This script will:
- Compare line endings of two text files and analyze punctuation patterns.
- Return statistics about matching and mismatching line endings.

### train_baseline_model.sh

This script will:
- Load a batch job on the server in order to train a baseline model

### preprocess.py

This script will:
- Preprocess/Tokenize using nltk