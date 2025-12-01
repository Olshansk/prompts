# Debug Timeouts Command

## Overview
Systematically analyze and debug timeout configurations across application layers to identify timeout hierarchies, conflicts, and root causes of unexpected delays.

## Usage
```
/debug-timeouts [--layer=all|http|transport|context|server] [--search-pattern=<pattern>] [--trace-path] [--suggest-fixes]
```

## Parameters
- `--layer`: Focus on specific timeout layer (default: all)
- `--search-pattern`: Custom regex pattern to find timeout configurations
- `--trace-path`: Trace timeout chain from entry point to network
- `--suggest-fixes`: Provide specific recommendations for timeout issues

## What It Does

### 1. Timeout Discovery
- **HTTP Client Timeouts**: `Timeout`, `ResponseHeaderTimeout`, `TLSHandshakeTimeout`, `ExpectContinueTimeout`
- **Transport Timeouts**: `DialTimeout`, `KeepAlive`, `IdleConnTimeout`  
- **Context Timeouts**: `WithTimeout`, `WithDeadline` calls
- **Server Timeouts**: `ReadTimeout`, `WriteTimeout`, `IdleTimeout`
- **Application Timeouts**: Custom timeout constants and configurations

### 2. Timeout Hierarchy Analysis
- **Chain of Command**: Map timeout inheritance from request entry to network I/O
- **Conflict Detection**: Identify timeouts that override each other
- **Effective Timeout**: Calculate which timeout actually triggers first
- **Gap Analysis**: Find layers missing timeout protection

### 3. Pattern Recognition
- **Common Anti-patterns**: Identify configurations that cause unexpected behavior
- **Timeout Leaks**: Find contexts that bypass timeout controls
- **Starvation Patterns**: Detect timeouts that are too aggressive/lenient
- **Recovery Delays**: Identify post-timeout connection recovery times

### 4. Debugging Output

#### Timeout Map
```
REQUEST TIMEOUT CHAIN
├── HTTP Server ReadTimeout: 60s
├── Gateway parallelRequestTimeout: 30s  ⚠️  LONGER THAN HTTP SERVER
├── Shannon sendRelayTimeout: 5s
├── HTTP Client earlyCtx: 1s            ⭐ EFFECTIVE TIMEOUT
│   ├── ResponseHeaderTimeout: 1s       ⭐ TRANSPORT OVERRIDE
│   ├── TLS HandshakeTimeout: 5s
│   └── Dial Timeout: 5s
└── HTTP Client Timeout: 80s            ❌ NEVER REACHED
```

#### Conflict Analysis
```
⚠️  TIMEOUT CONFLICTS DETECTED:
1. Gateway parallelRequestTimeout (30s) > Server ReadTimeout (60s)
   → Gateway timeout never triggers, server closes connection first
   
2. HTTP Client Timeout (80s) > ResponseHeaderTimeout (1s) 
   → ResponseHeaderTimeout will trigger first, HTTP Client timeout unused
   
3. Multiple 1s timeouts competing:
   - context.WithTimeout(1s) vs ResponseHeaderTimeout(1s)
   → Both will trigger simultaneously, creating race condition
```

#### Root Cause Suggestions
```
🔍 LIKELY ROOT CAUSE:
Based on your 15-second delays after 0.7s timeouts:

1. ✅ 1s timeout IS working (explains 0.7s response times)
2. ❌ 15s delay is NOT from configured timeouts
3. 🔍 Check: TCP connection recovery, OS socket timeouts, DNS caching

INVESTIGATION STEPS:
1. Add connection pool monitoring: transport.CloseIdleConnections() timing
2. Check OS-level TCP settings: net.core.netdev_max_backlog
3. Verify DNS resolution delays: add DNSStart/DNSDone logging
4. Monitor connection reuse: log connectionReused in httptrace
```

### 5. Fix Suggestions

#### Immediate Fixes
```go
// BEFORE: Competing 1s timeouts
earlyCtx, earlyCancel := context.WithTimeout(debugCtx, 1*time.Second)
transport.ResponseHeaderTimeout = 1*time.Second

// AFTER: Coordinated timeout strategy  
earlyCtx, earlyCancel := context.WithTimeout(debugCtx, 500*time.Millisecond)
transport.ResponseHeaderTimeout = 1*time.Second  // Backup timeout
```

#### Architecture Improvements
```go
// Add timeout tracing
type TimeoutTracer struct {
    timeouts map[string]time.Time
}

func (t *TimeoutTracer) Record(name string, timeout time.Duration) {
    t.timeouts[name] = time.Now().Add(timeout)
}

// Coordinated timeout cancellation
func NewCascadingContext(base context.Context, timeouts ...namedTimeout) context.Context {
    // Implementation that cancels contexts in proper order
}
```

### 6. Monitoring Integration
- **Metrics**: Generate timeout-specific metrics for observability
- **Alerts**: Suggest alerting rules for timeout anomalies
- **Dashboards**: Provide Grafana/Prometheus queries for timeout monitoring

## Implementation Notes

### Search Patterns
```regex
# Common timeout patterns
timeout.*=.*\d+.*time\.(Second|Millisecond|Minute)
WithTimeout\(.*,.*\d+.*time\.
ReadTimeout|WriteTimeout|IdleTimeout.*=
ResponseHeaderTimeout|TLSHandshakeTimeout
Dial.*Timeout|KeepAlive.*=
```

### Language-Specific Searches
- **Go**: `time.Duration`, `context.WithTimeout`, `http.Transport` fields
- **JavaScript/Node**: `setTimeout`, `fetch timeout`, `axios timeout`
- **Python**: `socket.settimeout`, `requests.timeout`, `asyncio.wait_for`
- **Java**: `SocketTimeout`, `ConnectionTimeout`, `ReadTimeout`

### Integration Points
- **Git blame**: Show who introduced problematic timeout configurations
- **Dependency analysis**: Find timeout configurations in external libraries
- **Environment scanning**: Check environment variables affecting timeouts
- **Configuration files**: Parse YAML/JSON for timeout settings

## Example Output for PATH Debugging

```
🔍 TIMEOUT DEBUG ANALYSIS FOR PATH

📊 DISCOVERED TIMEOUTS (8 found):
├── protocol/shannon/context.go:28    defaultShannonSendRelayTimeoutMillisec = 5_000
├── protocol/shannon/http_client.go:25 responseHeaderTimeout = 1 * time.Second  
├── protocol/shannon/http_client.go:98 TLSHandshakeTimeout: 5 * time.Second
├── protocol/shannon/http_client.go:87 DialContext Timeout: 5 * time.Second
├── gateway/request_context.go:36     parallelRequestTimeout = 30 * time.Second
├── config/router.go:26              defaultHTTPServerReadTimeout = 60 * time.Second
├── config/router.go:27              defaultHTTPServerWriteTimeout = 120 * time.Second
└── protocol/shannon/http_client.go:116 HTTP Client Timeout: 80 * time.Second

⚡ EFFECTIVE TIMEOUT CHAIN:
Request → ResponseHeaderTimeout(1s) → Shannon(5s) → Parallel(30s) → Server(60s) → Client(80s)

🎯 ROOT CAUSE ANALYSIS:
✅ Your 0.7s response times confirm ResponseHeaderTimeout(1s) is working
❌ 15s delays are NOT from any configured timeout
🔍 LIKELY CAUSE: Connection pool recovery after forced connection closure

💡 INVESTIGATION COMMANDS:
1. Add connection pool monitoring:
   transport.CloseIdleConnections() // Add timing around this call
   
2. Check for connection reuse patterns:
   httptrace.GotConn callback // Log connectionReused field
   
3. Monitor DNS resolution:
   httptrace.DNSStart/DNSDone // Check for DNS caching issues

4. OS-level TCP investigation:
   ss -tulpn | grep :3069  // Check socket states
   netstat -i  // Check network interface stats
```

This slash command would have immediately identified that your 15-second delay was NOT from any configured timeout, pointed you toward connection pool recovery as the likely cause, and provided specific debugging steps to investigate the real root cause.