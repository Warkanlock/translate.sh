# translate.sh

Use Whisper to transcribe audio from your microphone and copy the transcript to your clipboard.

⚙️ Requirements

```bash
brew install whisper-cli ffmpeg
```

Download the fast English model:

```bash
mkdir -p ~/Warkanlock/models
cd ~/Warkanlock/models
curl -O https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.en.bin
```

📜 Script Setup
	1.	Save the script as translate (or any name) in your path:

```bash
sudo mv translate /usr/local/bin/translate
chmod +x /usr/local/bin/translate
```
	2.	Set your mic input index:

```bash
ffmpeg -f avfoundation -list_devices true -i ""
```

Update `INPUT_DEVICE=":1"` in the script as needed.

▶️ Usage

Run in terminal:

```bash
translate
```

- Recording starts
- Press Z to stop
- Transcript is copied to clipboard

