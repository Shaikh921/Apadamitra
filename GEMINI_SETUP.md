# Gemini AI Assistant Setup Guide

## Overview
The Apadamitra app uses Google's Gemini AI to power the Safety Assistant chatbot, providing real-time flood safety guidance in multiple Indian languages.

## Getting Your Gemini API Key

### Step 1: Visit Google AI Studio
1. Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account

### Step 2: Create API Key
1. Click on "Get API Key" or "Create API Key"
2. Select "Create API key in new project" or choose an existing project
3. Copy the generated API key

### Step 3: Configure the App
1. Open `lib/gemini/gemini_config.dart`
2. Replace `YOUR_GEMINI_API_KEY_HERE` with your actual API key:

```dart
const String geminiApiKey = 'AIzaSy...your-actual-key-here';
```

## Features

### Multi-Language Support
The assistant responds in 9 Indian languages:
- English
- हिंदी (Hindi)
- ಕನ್ನಡ (Kannada)
- తెలుగు (Telugu)
- मराठी (Marathi)
- বাংলা (Bengali)
- தமிழ் (Tamil)
- ગુજરાતી (Gujarati)
- ଓଡ଼ିଆ (Odia)

### Safety Topics Covered
- Flood preparedness and emergency kits
- Evacuation procedures and safety measures
- Understanding flood alerts and warnings
- Post-flood recovery and safety
- Dam safety and water level monitoring
- Monsoon safety tips
- Flash flood response
- Family and property protection

## Model Configuration

The app uses **Gemini 1.5 Flash** with the following settings:
- **Temperature**: 0.7 (balanced creativity and accuracy)
- **Max Output Tokens**: 1024 (detailed responses)
- **Safety Settings**: Medium threshold for all categories

## Usage Tips

1. **Be Specific**: Ask clear questions about flood safety
2. **Use Your Language**: Select your preferred language from the dropdown
3. **Context Aware**: The assistant remembers your conversation
4. **New Conversation**: Tap the refresh icon to start fresh

## Example Questions

- "What should I include in my flood emergency kit?"
- "How do I evacuate safely during a flood?"
- "What are the warning signs of a flash flood?"
- "How can I protect my home from flood damage?"
- "What should I do if I'm trapped in a flooded building?"

## Troubleshooting

### "Configuration Required" Error
- Make sure you've added your API key in `lib/gemini/gemini_config.dart`
- Verify the API key is valid and not expired
- Check that you have internet connectivity

### No Response from Assistant
- Check your internet connection
- Verify your API key has not exceeded quota
- Try starting a new conversation

### API Quota Limits
- Free tier: 60 requests per minute
- If you need more, upgrade to a paid plan at [Google Cloud Console](https://console.cloud.google.com/)

## Security Notes

⚠️ **Important**: 
- Never commit your API key to version control
- Add `lib/gemini/gemini_config.dart` to `.gitignore` if sharing code
- For production apps, use environment variables or secure key management

## Cost Information

Gemini 1.5 Flash pricing (as of 2024):
- **Free tier**: 15 requests per minute, 1 million tokens per day
- **Paid tier**: Very affordable, check [Google AI Pricing](https://ai.google.dev/pricing)

## Support

For issues with:
- **Gemini API**: Visit [Google AI Documentation](https://ai.google.dev/docs)
- **App Issues**: Contact the Apadamitra development team

---

**Powered by Google Gemini AI** 🤖✨
