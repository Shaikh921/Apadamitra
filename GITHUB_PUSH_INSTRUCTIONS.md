# Push to GitHub Instructions

## ✅ Step 1: Create GitHub Repository (Done in Browser)

1. Go to https://github.com
2. Click the **+** icon (top right) → **New repository**
3. Fill in:
   - **Repository name**: `apadamitra` (or your preferred name)
   - **Description**: Flood Monitoring & Safety System
   - **Visibility**: Choose Public or Private
   - **DO NOT** initialize with README, .gitignore, or license (we already have these)
4. Click **Create repository**

## ✅ Step 2: Link Local Repository to GitHub

After creating the repository, GitHub will show you commands. Use these:

```bash
# Add the remote repository (replace YOUR_USERNAME with your GitHub username)
git remote add origin https://github.com/YOUR_USERNAME/apadamitra.git

# Verify the remote was added
git remote -v

# Push to GitHub
git branch -M main
git push -u origin main
```

## Alternative: Using SSH (if you have SSH keys set up)

```bash
git remote add origin git@github.com:YOUR_USERNAME/apadamitra.git
git branch -M main
git push -u origin main
```

## ✅ Step 3: Verify Upload

1. Go to your GitHub repository page
2. You should see all your files
3. README.md will be displayed on the main page

## 🔐 Important: Secure Your Credentials

Your Supabase credentials are currently in the code. For better security:

### Option 1: Use Environment Variables (Recommended for Production)

1. Create a `.env` file (already in .gitignore):
```
SUPABASE_URL=https://dgepxgnrviugwnxrrsxl.supabase.co
SUPABASE_ANON_KEY=your_anon_key_here
```

2. Update `lib/supabase/supabase_config.dart` to read from environment

### Option 2: Keep Credentials Private

Add this line to `.gitignore`:
```
lib/supabase/supabase_config.dart
```

Then create a template file `lib/supabase/supabase_config.dart.example`:
```dart
class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String anonKey = 'YOUR_ANON_KEY';
  // ... rest of code
}
```

## 📝 Future Updates

After making changes to your code:

```bash
# Check what changed
git status

# Add all changes
git add .

# Commit with a message
git commit -m "Description of your changes"

# Push to GitHub
git push
```

## 🌿 Working with Branches

```bash
# Create a new branch for a feature
git checkout -b feature/new-feature

# Make changes, commit them
git add .
git commit -m "Add new feature"

# Push the branch
git push -u origin feature/new-feature

# Then create a Pull Request on GitHub
```

## 🔄 Pull Latest Changes

```bash
# Pull latest changes from GitHub
git pull origin main
```

## ✅ Your Current Status

- ✅ Git initialized
- ✅ All files committed
- ✅ .gitignore configured
- ✅ README.md created
- ⏳ Waiting for GitHub remote setup

## Next Step

**Create the GitHub repository now, then run the commands from Step 2!**
