import { supabase } from '../supabase/client'

export interface CryptoData {
  d: string
  close: number
  volume: number
  market_cap: number
  circulating_supply: number
}

export interface CryptoWindowResponse {
  data: CryptoData[] | null
  error: any
}

/**
 * Get crypto data window for pattern analysis
 */
export async function getCryptoWindow(
  ticker: string, 
  days: number = 365
): Promise<CryptoWindowResponse> {
  try {
    const { data, error } = await supabase.rpc('get_crypto_window', {
      p_ticker: ticker.toUpperCase(),
      p_days: days
    })

    if (error) {
      console.error('Error fetching crypto window:', error)
      return { data: null, error }
    }

    return { data, error: null }
  } catch (err) {
    console.error('Network error:', err)
    return { data: null, error: err }
  }
}

/**
 * Get latest crypto data for a ticker
 */
export async function getLatestCrypto(ticker: string) {
  const { data, error } = await supabase
    .from('v_crypto_latest')
    .select('*')
    .eq('ticker', ticker.toUpperCase())
    .single()

  return { data, error }
}

/**
 * Search crypto by ticker (for autocomplete)
 */
export async function searchCrypto(query: string, limit: number = 10) {
  const { data, error } = await supabase
    .from('crypto_daily')
    .select('ticker, coin_name')
    .or(`ticker.ilike.${query.toUpperCase()}%,coin_name.ilike.${query}%`)
    .order('ticker')
    .limit(limit)

  // Remove duplicates
  const unique = data?.reduce((acc, row) => {
    if (!acc.find(item => item.ticker === row.ticker)) {
      acc.push(row)
    }
    return acc
  }, [] as typeof data)

  return { data: unique, error }
}