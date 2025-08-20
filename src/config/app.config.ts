/**
 * Pattern Whisper - Application Configuration
 * All adjustable parameters in one place for easy tuning
 */

export const config = {
  // Pattern Analysis Settings
  patterns: {
    defaultWindowLength: 252,        // Trading days (1 year)
    minWindowLength: 60,             // Minimum pattern window
    maxWindowLength: 504,            // Maximum pattern window (2 years)
    minSimilarityScore: 0.7,         // Minimum match threshold (70%)
    maxAnalogResults: 50,            // Maximum analogs to return
    topMatchesToShow: 10,            // Featured matches in UI
    predictionHorizons: [21, 63, 126, 252], // Days ahead (1m, 3m, 6m, 12m)
  },

  // Data Source Settings
  data: {
    historicalStartYear: 1990,       // How far back to search
    maxDataPoints: 10000,            // Max points per query
    cacheExpiry: 300,                // Seconds (5 minutes)
    updateFrequency: 'daily',        // 'realtime' | 'daily' | 'weekly'
    defaultCurrency: 'USD',
  },

  // Confidence Calculation
  confidence: {
    weights: {
      patternSimilarity: 0.6,        // Chart pattern weight
      macroSimilarity: 0.2,          // Macro context weight
      valuationSimilarity: 0.2,      // Fundamentals weight
    },
    thresholds: {
      high: 0.8,                     // >= 80% is high confidence
      medium: 0.6,                   // >= 60% is medium
      low: 0.4,                      // >= 40% is low
    },
    sectorBonus: 0.02,               // Same sector bonus
  },

  // Risk Assessment
  risk: {
    volatilityBuckets: {
      low: { max: 0.15 },            // < 15% annualized vol
      medium: { min: 0.15, max: 0.30 },
      high: { min: 0.30 },
    },
    drawdownThresholds: {
      acceptable: -0.10,             // -10% drawdown
      concerning: -0.20,             // -20% drawdown
      severe: -0.30,                 // -30% drawdown
    },
  },

  // API Rate Limiting
  rateLimit: {
    perUser: {
      perHour: 100,
      perMinute: 20,
      perSecond: 2,
    },
    perIP: {
      perHour: 50,
      perMinute: 10,
      perSecond: 1,
    },
    premium: {
      multiplier: 10,                // Premium users get 10x limits
    },
  },

  // Feature Flags
  features: {
    enableCrypto: true,
    enableIntraday: false,
    enableAlerts: false,
    enableSocialSharing: true,
    enableDemoMode: true,
    demoTickers: ['NVDA', 'AAPL', 'MSFT', 'BTC-USD', 'ETH-USD'],
  },

  // UI/UX Settings
  ui: {
    animation: {
      duration: 200,                 // ms
      easing: 'ease-out',
    },
    chart: {
      height: 400,                   // px
      mobileHeight: 300,             // px
      colors: {
        primary: '#3b82f6',          // blue-500
        success: '#10b981',          // green-500
        danger: '#ef4444',           // red-500
        neutral: '#6b7280',          // gray-500
      },
    },
    toast: {
      duration: 4000,                // ms
      position: 'bottom-right',
    },
  },

  // Twitter Sharing
  twitter: {
    imageWidth: 1200,
    imageHeight: 675,
    hashtags: ['StockPatterns', 'MarketAnalysis', 'TechnicalAnalysis'],
    via: 'PatternWhisper',
    quality: 0.95,                   // JPEG quality
  },

  // Performance
  performance: {
    debounceDelay: 300,              // ms for search input
    throttleDelay: 1000,             // ms for scroll events
    lazyLoadOffset: '50px',          // Intersection observer margin
    maxConcurrentRequests: 3,
  },

  // Sectors
  sectors: {
    codes: {
      tech: 'Technology',
      healthcare: 'Healthcare',
      finance: 'Financial Services',
      consumer: 'Consumer Discretionary',
      industrial: 'Industrials',
      energy: 'Energy',
      utilities: 'Utilities',
      realestate: 'Real Estate',
      materials: 'Materials',
      staples: 'Consumer Staples',
      telecom: 'Communication Services',
    },
  },

  // Macro Indicators Display Names
  macro: {
    indicators: {
      fed_funds: 'Fed Funds Rate',
      cpi_yoy: 'CPI (YoY)',
      ust2y: '2-Year Treasury',
      ust10y: '10-Year Treasury',
      vix: 'VIX',
      dxy: 'Dollar Index',
      wti: 'WTI Crude',
      spx_ret: 'S&P 500 Return',
    },
    criticalLevels: {
      vix: { high: 30, low: 12 },
      ust10y: { high: 5, low: 1.5 },
      cpi_yoy: { high: 4, target: 2 },
    },
  },

  // Database
  database: {
    maxRetries: 3,
    retryDelay: 1000,                // ms
    timeout: 30000,                  // ms
    batchSize: 1000,                 // Records per batch
  },

  // Development
  dev: {
    logLevel: process.env.NODE_ENV === 'production' ? 'error' : 'debug',
    showPerformanceMetrics: process.env.NODE_ENV !== 'production',
    mockDataDelay: 500,              // ms to simulate API delay
  },
} as const;

// Type exports for TypeScript
export type AppConfig = typeof config;
export type PatternConfig = typeof config.patterns;
export type RiskLevel = 'low' | 'medium' | 'high';
export type ConfidenceLevel = 'high' | 'medium' | 'low';

// Helper functions
export const getRiskLevel = (volatility: number): RiskLevel => {
  const { volatilityBuckets } = config.risk;
  if (volatility < volatilityBuckets.low.max) return 'low';
  if (volatility < volatilityBuckets.medium.max) return 'medium';
  return 'high';
};

export const getConfidenceLevel = (score: number): ConfidenceLevel => {
  const { thresholds } = config.confidence;
  if (score >= thresholds.high) return 'high';
  if (score >= thresholds.medium) return 'medium';
  return 'low';
};

// Validate config on load
if (typeof window === 'undefined') {
  // Server-side validation
  const requiredEnvVars = [
    'SUPABASE_URL',
    'SUPABASE_SERVICE_ROLE_KEY',
    'AUTH_TOKEN',
  ];
  
  const missing = requiredEnvVars.filter(v => !process.env[v]);
  if (missing.length > 0) {
    console.warn(`Missing environment variables: ${missing.join(', ')}`);
  }
}