# Root Files Explanation

## Files That MUST Stay in Root

These files must be in root for tools to work properly:

### Build & Config Files (Required in root)
- `package.json` - Node.js project definition
- `package-lock.json` - Dependency lock file  
- `tsconfig.json` - TypeScript configuration
- `tsconfig.node.json` - TypeScript config for Vite
- `vite.config.ts` - Vite bundler configuration
- `tailwind.config.js` - Tailwind CSS configuration
- `postcss.config.js` - PostCSS configuration

### Environment Files
- `.env` - Local environment variables (git ignored)
- `.env.example` - Template for environment variables
- `.env.local` - Local overrides (git ignored)

### Project Files
- `.gitignore` - Git ignore patterns
- `README.md` - Project documentation (GitHub shows this)
- `CLAUDE.md` - AI assistant context (keep in root for easy access)

## Clean Root Structure

After organization, your root should look like:
```
pattern-whisper/
├── src/                 # Application code
├── docs/               # Documentation
├── supabase/           # Database & functions
├── public/             # Static assets
├── tests/              # Test files
├── scripts/            # Build scripts
│
├── .env                # Local env (gitignored)
├── .env.example        # Env template
├── .gitignore          # Git config
├── package.json        # Dependencies
├── package-lock.json   # Lock file
├── tsconfig.json       # TypeScript config
├── vite.config.ts      # Vite config
├── tailwind.config.js  # Tailwind config
├── postcss.config.js   # PostCSS config
├── README.md           # Project readme
└── CLAUDE.md           # AI context
```

## Why This is Normal

Most modern JavaScript projects have 10-15 files in root:
- **Config files** must be in root (tools look there)
- **Package files** must be in root (npm/yarn requirement)
- **Documentation** typically in root (GitHub/GitLab convention)

## What NOT to Put in Root

Never put these in root:
- Source code files (use `/src`)
- Component files (use `/src/components`)
- API routes (use `/supabase/functions`)
- Test files (use `/tests`)
- Documentation beyond README (use `/docs`)

This is a **standard, clean structure** that any developer will recognize!