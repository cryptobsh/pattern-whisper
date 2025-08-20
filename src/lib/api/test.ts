/**
 * API Test Functions
 * Use these to verify your Supabase connection works
 */

import { getStockWindow, getLatestStock, searchStocks } from './stocks'
import { getCryptoWindow, getLatestCrypto, searchCrypto } from './crypto'

/**
 * Test all API endpoints
 * Run in browser console: testAllAPIs()
 */
export async function testAllAPIs() {
  console.log('🚀 Testing Pattern Whisper APIs...\n')

  // Test 1: Stock window data
  console.log('📈 Testing stock window data...')
  const stockWindow = await getStockWindow('NVDA', 5)
  if (stockWindow.data) {
    console.log('✅ Stock window:', stockWindow.data.length, 'days of NVDA data')
    console.log('   Latest close:', stockWindow.data[0]?.close)
  } else {
    console.error('❌ Stock window failed:', stockWindow.error)
  }

  // Test 2: Latest stock data
  console.log('\n📊 Testing latest stock data...')
  const latestStock = await getLatestStock('AAPL')
  if (latestStock.data) {
    console.log('✅ Latest AAPL:', latestStock.data.close, 'PE:', latestStock.data.pe)
  } else {
    console.error('❌ Latest stock failed:', latestStock.error)
  }

  // Test 3: Stock search
  console.log('\n🔍 Testing stock search...')
  const stockSearch = await searchStocks('A')
  if (stockSearch.data) {
    console.log('✅ Found tickers:', stockSearch.data.map(s => s.ticker))
  } else {
    console.error('❌ Stock search failed:', stockSearch.error)
  }

  // Test 4: Crypto window data
  console.log('\n₿ Testing crypto window data...')
  const cryptoWindow = await getCryptoWindow('BTC-USD', 3)
  if (cryptoWindow.data) {
    console.log('✅ Crypto window:', cryptoWindow.data.length, 'days of BTC data')
    console.log('   Latest close:', cryptoWindow.data[0]?.close)
  } else {
    console.error('❌ Crypto window failed:', cryptoWindow.error)
  }

  // Test 5: Latest crypto data
  console.log('\n🪙 Testing latest crypto data...')
  const latestCrypto = await getLatestCrypto('ETH-USD')
  if (latestCrypto.data) {
    console.log('✅ Latest ETH:', latestCrypto.data.close, 'Market cap:', latestCrypto.data.market_cap)
  } else {
    console.error('❌ Latest crypto failed:', latestCrypto.error)
  }

  // Test 6: Crypto search
  console.log('\n🔎 Testing crypto search...')
  const cryptoSearch = await searchCrypto('BTC')
  if (cryptoSearch.data) {
    console.log('✅ Found crypto:', cryptoSearch.data.map(c => `${c.ticker} (${c.coin_name})`))
  } else {
    console.error('❌ Crypto search failed:', cryptoSearch.error)
  }

  console.log('\n🎉 API testing complete!')
}

/**
 * Quick connection test
 */
export async function testConnection() {
  console.log('⚡ Quick connection test...')
  
  const result = await getStockWindow('NVDA', 1)
  
  if (result.data && result.data.length > 0) {
    console.log('✅ Connection successful!')
    console.log('🎯 NVDA latest:', result.data[0])
    return true
  } else {
    console.error('❌ Connection failed:', result.error)
    return false
  }
}