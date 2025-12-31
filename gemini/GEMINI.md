## Gemini Added Memories
- The `make ghd-pre-process-images` target is implemented and fully functional, wrapping `scripts/process_ghd_data.py` to run the GHD pipeline with Surya OCR.
- The GHD pipeline now supports single-image processing via the `--image` flag in `scripts/process_ghd_data.py`, and data cleaning is modularized in `src/ghd_pipeline/steps/data_cleaner.py`.
- I've implemented robust orientation correction in `src/ghd_pipeline/steps/orientation.py` that uses EXIF data followed by Tesseract OSD (with Otsu thresholding preprocessing) to ensure images are upright based on text legibility.
- I increased the Tesseract OSD confidence threshold to 2.0 in `src/ghd_pipeline/steps/orientation.py` to prevent false positive rotations on noisy soil images, as low-confidence detection (e.g., 1.01) was causing incorrect flips.
- I've implemented a relaxed regex fallback in `src/ghd_pipeline/steps/label_reader.py` that can extract Lab IDs like `WLT1321` from messy text (e.g., `WLT1321 23-02...`), logging a "🚨 Fuzzy match" warning when this occurs.
- I've updated the regex in `src/ghd_pipeline/steps/label_reader.py` to support Lab IDs with hyphens between the prefix and number (e.g., `WLT-1349-9`).
- The images `IMG_1986.JPEG` and `IMG_2427.JPEG` are unreadable by both Surya and Tesseract OCR despite upscaling (2x), rotation (180/EXIF), preprocessing (Otsu/CLAHE), and card cropping attempts, due to low contrast and noise.
