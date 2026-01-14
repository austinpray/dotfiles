---
name: screenshot
description: View the latest screenshot. Use when user asks to look at, view, see, or analyze a screenshot, or says "latest screenshot".
allowed-tools: Bash, Read, Glob
---

# Screenshot Viewer

## Finding the latest screenshot

Screenshots are stored in ~/screenshots. To find and read the most recent one:

```bash
ls -t ~/screenshots | head -1
```

## Reading the screenshot

Use the Read tool on the file path to view it:

```
~/screenshots/<filename>
```

The Read tool supports viewing images (PNG, JPG, etc.) and will display them visually.
