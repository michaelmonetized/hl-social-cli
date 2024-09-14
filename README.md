# hl-social-cli (Hustle Launch Social Command Line Interface)

## Caption Generation

uses llama3.1-405b through the inference API to generate social media post captions.

```bash
curl https://api-inference.huggingface.co/models/meta-llama/Meta-Llama-3.1-405B \
        -X POST \
        -d '{"inputs": "Generate 42 $VIBE social media post captions for [company name: $COMPANY]($URL) [campaign name: $CAMPAIGN] [campaign goal(s): $GOALS] use a json array output following the example structure [{title: string, caption: string, hashtags: string[]}] it is highly important that there is strict adhearance to the output structure."}' \
        -H 'Content-Type: application/json' \
        -H "Authorization: Bearer hf_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

## Photo Generation Loop

uses black-forest-labs/FLUX.1-dev through the inference API to generate social media post photos.

```bash
for i in jq $CAPTIONS; do
curl https://api-inference.huggingface.co/models/black-forest-labs/FLUX.1-dev \
        -X POST \
        -d '{"inputs": "A hyper-realistic photo shot with a sigma f1.4 lens on kodak gold 400 film that best suits this caption: `App-solute Monarchy Rule your market with an iron app! Our development team is ready to crown your business as the app-solute monarch. Long live the king of convenience! #AppDevelopmentRoyalty, #DigitalMonarchy, #HustleLaunch`"}' \
        -H 'Content-Type: application/json' \
        -H "Authorization: Bearer hf_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" --output "./tmp/$COMPANY-$CAMPAIGN-$TITLE-$i.png"
done
```

Put your auth token in .env

```bash
export HUGGINGFACE_TOKEN=hf_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

Run the script

```bash
./src/hl-social-cli.sh
```
