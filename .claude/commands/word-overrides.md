---
description: Train dictation word overrides for hyprwhspr
argument-hint: <correct-word>
---

# Word Override Training

The user wants to add a word override for: **$ARGUMENTS**

Current word_overrides in the config:
@.config/hyprwhspr/config.json

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

3. After the user provides the transcribed results, identify the incorrect transcription(s) for "$ARGUMENTS".

4. Add entries to the `word_overrides` object in `.config/hyprwhspr/config.json` mapping each incorrect transcription to the correct word "$ARGUMENTS".

## Important Notes
- The word_overrides format is: `"incorrect_transcription": "correct_word"`
- Multiple incorrect transcriptions can map to the same correct word
- Preserve existing overrides when adding new ones
