import { supabase } from '../supabase/client'

export interface StockData {
  d: string
  close: number
  adj_close: number
  volume: number
  pe: number
  ps: number
  market_cap: number
}

export interface StockWindowResponse {
  data: StockData[] | null
  error: any
}

/**
 * Get stock data window for pattern analysis
 */
export async function getStockWindow(
  ticker: string, 
  days: number = 252
): Promise<StockWindowResponse> {
  try {
    const { data, error } = await supabase.rpc('get_stock_window', {
      p_ticker: ticker.toUpperCase(),
      p_days: days
    })

    if (error) {
      console.error('Error fetching stock window:', error)
      return { data: null, error }
    }

    return { data, error: null }
  } catch (err) {
    console.error('Network error:', err)
    return { data: null, error: err }
  }
}

/**
 * Get latest stock data for a ticker
 */
export async function getLatestStock(ticker: string) {
  const { data, error } = await supabase
    .from('v_stock_latest')
    .select('*')
    .eq('ticker', ticker.toUpperCase())
    .single()

  return { data, error }
}

/**
 * Search stocks by ticker (for autocomplete)
 */
export async function searchStocks(query: string, limit: number = 10) {
  const { data, error } = await supabase
    .from('stocks_daily')
    .select('ticker')
    .ilike('ticker', `${query.toUpperCase()}%`)
    .order('ticker')
    .limit(limit)

  // Remove duplicates
  const uniqueTickers = [...new Set(data?.map(row => row.ticker))]

  return { 
    data: uniqueTickers.map(ticker => ({ ticker })), 
    error 
  }
}