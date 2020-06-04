## BioCovidBERT

### Model and training description

- BERT large default configuration
- Cased 
- Initialized from [BioBERT-Large v1.1 (+ PubMed 1M)](https://github.com/dmis-lab/biobert) using their custom 30k vocabulary
- Using whole-word masking
- Pretrained on the same preprocessed version of the CORD-19 dataset including titles, abstract and body text (approx. 1.5GB)
- Tensorboard link
- Training parameters:
  - `train_batch_size`: 512
  - `max_seq_length`: 128
  - `max_predictions_per_seq`: 20
  - `num_train_steps`: 200000 
  - `num_warmup_steps`: 10000
  - `learning_rate`: 2e-5
  
  More information on the [covid-berts](https://github.com/manueltonneau/covid-berts) repository. 
