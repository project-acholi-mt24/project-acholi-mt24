# project-acholi-mt24
This repository hosts code for a low-resource language machine translation project involving the Acholi language. The project is a part of the course Machine Translation (5LN711) at Uppsala University, Fall 2024.

To clone the depository use:
```
git clone https://github.com/project-acholi-mt24/project-acholi-mt24.git
```

# Training the baseline model
### Step 1: Create virtual environment

1. In an appropriate directory (On UPPMAX),
- Clone this repository
- Run the script for creating a virtual environment:
```
bash create_mt_env.sh
```

2. Activate the environment: 
```
source ~/envs/activate_acholi_mt_env.sh
```
3. To deactivate the environment:
```
deactivate
```
### Step 2: Extract data for baseline model

Run extract_data.py:
```
python extract_data.py
```
### Step 3: Tokenize and clean the data
Run preprocess.sh:
```
bash preprocess.sh
```
### Step 4: Create vocabulary, Encode data using BPE, create .yaml-file with data configuration

Run preprocess_onmt.py:
Example:
```
python preprocess_onmt.py \
  --train-src processed_data_moses/salt.train.tk.lc.clean.ach \
  --train-tgt processed_data_moses/salt.train.tk.lc.clean.eng \
  --dev-src processed_data_moses/salt.dev.tk.lc.ach \
  --dev-tgt processed_data_moses/salt.dev.tk.lc.eng \
  --src-lang ach \
  --tgt-lang en \
  --output-dir onmt_data \
  --save-prefix data \
  --src-vocab-size 7000 \
  --tgt-vocab-size 7000 \
  --src-min-frequency 2 \
  --tgt-min-frequency 2 \
  --src-bpe-operations 7000 \
  --tgt-bpe-operations 7000
```
### Step 5: *Manually* create the file train_config.yaml
Use the newly created file *data_config.yaml* as a base. Set parameters. See example-file: *train_config.yaml.example*.

### Step 6: Submit job to Snowy (Uppmax cluster):
If needed update DATA_DIR in train_baseline_model.sh with the the full path to data directory
```
sbatch train_baseline_model.sh
```
### Step 7 Preprocess test data
Run script to preprocess the test set using the same encoding as for the test and dev set
```
python preprocess_test_data.py
```
### Step 8: Translate using the newly trained model
Use the the newly trained model to translate the data in the test set

```
sbatch batch_translate.py
```

This script will:

- Try all available checkpoints
- Test different beam sizes and batch sizes
- Calculate BLEU and chrF scores for each configuration
- Save all translations and results
- Identify the best performing configuration

The script will also create a timestamped directory with:
- Translations for each configuration
- A CSV file with all results
- Logs showing the best configuration

Example:
python batch_translate.py \
    --project-dir /[name of your PROJECT DIRECTORY] \
    --test-src processed_data_moses/salt.test.tk.lc.ach \
    --test-ref processed_data_moses/salt.test.tk.lc.eng \
    --bpe-codes onmt_data/data.ach.codes \
    --beam-sizes 3 5 7 \
    --batch-sizes 16 32 64

## Baseline Training:
![Translation Results](images/baseline_result.png)

| Checkpoint | Best BLEU | Best chrF | Optimal Beam Size |
|------------|-----------|-----------|-------------------|
| 2000 steps | 7.54      | 31.70     | 7                |
| 4000 steps | 6.89      | 32.94     | 7                |
| 6000 steps | 7.17      | 32.23     | 7                |
| 6500 steps | 7.07      | 31.44     | 7                |

________________________________________________________________________________________________________

# Scripts for data extraction and tokenization/initial preprocessing

### extract_data.py

This script extracts raw parallel Acholi-English data from the Sunbird/salt dataset on Hugging Face.

**Usage:**
```
python extract_data.py
```

### preprocess.sh

This script preprocesses the extracted data for use with Moses SMT.

**Usage:**
```
bash preprocess.sh
```
The script will:
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

# Some more scripts:

### create_mt_env.sh

This script will:
- Create virtual environment on the server (UPPMAX) (see details above)

### preprocess_onmt.py:

This script will:

- Create a .yaml config-file for pretraining operations
- Encode data using BPE using subword-nmt
- Create a vocabulary for use with OpenNMT

### train_baseline_model.sh

This script will:
- Load a batch job on the server in order to train a baseline model

### evaluation.py

This script will:

Evaluate the output translations of a machine translation model using these metrics:
- BLEU
- METEOR
- COMET

### bootstrap_evaluation.py

This script will:
- Perform statistical significance testing for comparing two machine translation models using paired bootstrap resampling. It integrates with OpenNMT-py and uses the eval class in evaluation.py for evaluation.
- Provide detailed statistics:
    - Mean scores and standard deviations
    - Win counts and ratios
    - Approximate p-values
    - Confidence intervals
  
[Note: argparse is yet to be implemented]

### tools\analyze_line_endings.py:

This script will:
- Compare line endings of two text files and analyze punctuation patterns.
- Return statistics about matching and mismatching line endings.

### tools\analyze_vocabulary.py

This script will:
- Analyze vocabulary and token frequencies in (parallel) text files.
- Produce a chart showing token frequencies at different thresholds
- Print basic stats to terminal

### tools\analyze_overlap.py
This script will:
- Analyse overlap between two parallel langauge data files

# Additional files

### train_config.yaml.example
An example .yaml file, used for configuring training parameters. These parameters were/can be used during baseline training
- Use this for creating the file *train_config.yaml*.
- Make sure to use the data parameters in *data_config.yaml* (created during preprocessing) in your train_config.yaml.
