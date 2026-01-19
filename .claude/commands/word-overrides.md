---
description: Train dictation word overrides for Handy
argument-hint: <correct-word>
---

# Word Override Training

The user wants to add a custom word for: **$ARGUMENTS**

Current custom_words in the config:
@.local/share/com.pais.handy/settings_store.json

## Workflow

1. Generate 10 practice sentences containing "$ARGUMENTS" in different contexts and intonations:
   - Questions
   - Commands/imperatives
   - Casual statements
   - Technical explanations
   - Beginnings of sentences
   - Middle of sentences
   - End of sentences
   - With surrounding technical terms
   - In lists
   - In exclamations

2. Present the sentences to the user and ask them to read each one aloud using their dictation software.

3. After the user provides the transcribed results, check if "$ARGUMENTS" is being transcribed correctly.

4. If not already present, add "$ARGUMENTS" to the `custom_words` array in `.local/share/com.pais.handy/settings_store.json`.

## Important Notes
- The custom_words format is a simple array of strings: `["word1", "word2"]`
- These words help the speech recognition model correctly transcribe specific terms
- Preserve existing custom words when adding new ones
