## ClinicalCovidBERT 

### Model and training description

- BERT base default configuration
- Cased 
- Initialized from [Bio+Clinical BERT](https://github.com/EmilyAlsentzer/clinicalBERT)
- Using English `bert_base_cased` default vocabulary
- Using whole-word masking
- Pretrained on a preprocessed version of the CORD-19 dataset including titles, abstract and body text (approx. 1.5GB)
- Tensorboard link
- Training parameters:
  - `train_batch_size`: 512
  - `max_seq_length`: 128
  - `max_predictions_per_seq`: 20
  - `num_train_steps`: 150000 
  - `num_warmup_steps`: 10000
  - `learning_rate`: 2e-5

   More information on the [covid-berts](https://github.com/manueltonneau/covid-berts) repository. 
