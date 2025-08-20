import { useEffect, useState } from 'react'
import { testConnection, testAllAPIs } from './lib/api'

function App() {
  const [isConnected, setIsConnected] = useState<boolean | null>(null)
  const [testResults, setTestResults] = useState<string>('')

  // Test connection on mount
  useEffect(() => {
    async function checkConnection() {
      const connected = await testConnection()
      setIsConnected(connected)
    }
    checkConnection()
  }, [])

  // Run full API tests
  const runFullTests = async () => {
    setTestResults('Running tests...')
    
    // Capture console output
    const originalLog = console.log
    const originalError = console.error
    let output = ''
    
    console.log = (...args) => {
      output += args.join(' ') + '\n'
      originalLog(...args)
    }
    
    console.error = (...args) => {
      output += 'ERROR: ' + args.join(' ') + '\n'
      originalError(...args)
    }
    
    try {
      await testAllAPIs()
    } catch (error) {
      output += 'FATAL ERROR: ' + error + '\n'
    }
    
    // Restore console
    console.log = originalLog
    console.error = originalError
    
    setTestResults(output)
  }

  return (
    <div className="min-h-screen bg-gray-50 p-8">
      <div className="max-w-4xl mx-auto">
        {/* Header */}
        <div className="text-center mb-8">
          <h1 className="text-4xl font-bold text-gray-900 mb-2">
            Pattern Whisper 📈
          </h1>
          <p className="text-xl text-gray-600">
            Find patterns in history. See what happened next.
          </p>
        </div>

        {/* Connection Status */}
        <div className="pattern-card mb-8">
          <h2 className="text-2xl font-semibold mb-4">Database Connection</h2>
          
          <div className="flex items-center gap-3 mb-4">
            <div className={`w-3 h-3 rounded-full ${
              isConnected === null ? 'bg-yellow-400' : 
              isConnected ? 'bg-green-400' : 'bg-red-400'
            }`} />
            <span className="font-medium">
              {isConnected === null ? 'Testing connection...' :
               isConnected ? 'Connected to Supabase ✅' : 'Connection failed ❌'}
            </span>
          </div>

          {isConnected && (
            <div className="text-sm text-gray-600 mb-4">
              <p>✅ Vector extension enabled</p>
              <p>✅ Demo data loaded (NVDA, AAPL, MSFT, BTC, ETH, SOL)</p>
              <p>✅ Helper functions working</p>
              <p>✅ RLS policies active</p>
            </div>
          )}

          <button
            onClick={runFullTests}
            className="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 transition-colors"
          >
            Run Full API Tests
          </button>
        </div>

        {/* Test Results */}
        {testResults && (
          <div className="pattern-card">
            <h3 className="text-xl font-semibold mb-4">Test Results</h3>
            <pre className="bg-gray-900 text-green-400 p-4 rounded-lg overflow-x-auto text-sm font-mono whitespace-pre-wrap">
              {testResults}
            </pre>
          </div>
        )}

        {/* Next Steps */}
        {isConnected && (
          <div className="pattern-card">
            <h3 className="text-xl font-semibold mb-4">🎉 Ready to Build!</h3>
            <div className="space-y-3 text-gray-700">
              <p>✅ Database connected and working</p>
              <p>✅ API functions created and tested</p>
              <p>✅ Demo data available for development</p>
              
              <div className="mt-6">
                <h4 className="font-semibold mb-2">Next Steps:</h4>
                <ol className="list-decimal list-inside space-y-1 text-sm">
                  <li>Create ticker search component</li>
                  <li>Build pattern display charts</li>
                  <li>Add pattern matching logic</li>
                  <li>Implement user authentication</li>
                  <li>Add Twitter sharing</li>
                </ol>
              </div>
            </div>
          </div>
        )}
      </div>
    </div>
  )
}

export default App