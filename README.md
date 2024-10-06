# project-acholi-mt24
This repository hosts code for a low-resource language machine translation project involving the Acholi language. The project is a part of the course Machine Translation (5LN711) at Uppsala University, Fall 2024.

## Scripts for data extraction and preprocessing

### 1. extract_data.py

This script extracts parallel data from the Sunbird/salt dataset on Hugging Face.

**Usage:**
```
python extract_data.py
```

This script will:
- Load the Sunbird/salt dataset
- Extract Acholi-English parallel sentences
- Split the data into train, dev, and test sets
- Save the extracted data in the `raw_corpus` directory

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
- Save the preprocessed files in the `processed_corpus` directory

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

## Directory Structure

- `data/`: Contains the raw extracted data
- `processed_corpus/`: Contains the preprocessed data ready for Moses SMT
- `extract_data.py`: Python script for data extraction
- `preprocess.sh`: Bash script for data preprocessing

## Note

The `data and `processed_corpus` directories are not tracked by Git. You need to run the scripts to generate these directories and their contents locally.
