---
name: component-preview
description: Create minimal frontend component preview demos with data dashboards and interaction logging. Use when user wants to preview a component, create a component demo, build a component sandbox, or debug component I/O. Triggers on "component preview", "component demo", "preview demo", "demo component", "component sandbox".
metadata:
  author: Neo
  version: "2026.06.12"
  source: Manual
---

# Component Preview Demo

> Generate minimal demo components with data dashboards and console logging for debugging frontend components (business or generic).

## When to Use

- User provides a component and wants a runnable preview/demo
- User wants to debug component input/output data flow
- User needs to verify component behavior in isolation

## Workflow

### Step 1: Collect Information

Ask the user for:

1. **Target component** - component file path or name

The demo file is always placed **in the same directory as the target component**, named `{ComponentName}.demo.vue` (or `.tsx`/`.jsx` matching the project framework).

If the user provides the component path, read the component source to understand its props, events, slots, and internal data flow before writing the demo.

### Step 2: Analyze the Component

Read the target component and identify:

- **Input data**: props, inject, store bindings, route params
- **Output data**: emits, store mutations, API calls, callback invocations
- **Key interactions**: user events (click, input, select), lifecycle hooks, watchers, async operations

### Step 3: Add Interaction Logging to Original Component

Modify the original component to add `console.log` at key interaction points. Follow these rules:

- Prefix all logs with `[ComponentName]` for easy filtering
- Log at these points:
  - Props changes (watchers or `onUpdated`)
  - User event handlers (click, input, change, submit, etc.)
  - Emits (before `$emit` or `emit()` calls)
  - Async results (API responses, computed recalculations)
  - Lifecycle hooks (`onMounted`, `onUnmounted`) if relevant
- Use `console.log` for normal flow, `console.warn` for edge cases
- Keep logs concise: `console.log('[MyButton] click', { payload })`
- Do NOT log sensitive data (tokens, passwords)

**Example - adding logs to a component:**

```typescript
// Before
function handleClick(row: RowData) {
  emit('select', row)
}

// After
function handleClick(row: RowData) {
  console.log('[DataTable] row click', { rowId: row.id, row })
  emit('select', row)
}

// Before
watch(() => props.dataSource, (val) => {
  processData(val)
})

// After
watch(() => props.dataSource, (val) => {
  console.log('[DataTable] dataSource changed', { length: val?.length, sample: val?.[0] })
  processData(val)
})
```

### Step 4: Create the Demo Component

Create a demo component at `{same-directory}/{ComponentName}.demo.{ext}`.

#### Layout

The demo uses a **left-right two-column layout**:

```
+-------------------------------------------+
|            Component Preview Demo          |
+-----------------------+-------------------+
|                       |                   |
|   Component Area      |   Data Dashboard  |
|   (left, wider)       |   (right, narrow) |
|                       |                   |
|   Target component    |   [Input Data]    |
|   rendered here with  |   JSON display    |
|   all props bound     |                   |
|                       |   [Output Data]   |
|                       |   Event log list  |
|                       |                   |
+-----------------------+-------------------+
```

- **Left side**: the target component with all props bound and events wired
- **Right side**: the data dashboard split into Input Data (top) and Output Data (bottom)

#### Required Sections

1. **Data Dashboard (right panel)**:
   - **Input Data**: current props/reactive data passed to the component, rendered as formatted JSON
   - **Output Data**: captured emit events with timestamps and payloads, shown as a scrollable list

2. **Component Area (left panel)**:
   - Simplest working instance of the target component
   - All required props bound to reactive data
   - All emitted events captured into the output panel
   - Slots filled with minimal placeholder content if needed

3. **Control Panel (optional)**: buttons/inputs at the bottom to trigger specific states

### Step 5: Verify

After creating the demo:

1. Confirm the demo file is placed alongside the target component
2. Ensure imports resolve correctly
3. If a dev server is running, suggest navigating to the demo route

## Demo Template

### Vue 3 + `<script setup>` + TypeScript

```vue
<script setup lang="ts">
import { ref, reactive } from 'vue'
import TargetComponent from './TargetComponent.vue'

// ---- Input Data ----
const inputProps = reactive({
  title: 'Demo Title',
  items: [{ id: 1, label: 'Item 1' }],
})

// ---- Output Data ----
const outputLog = ref<Array<{ time: string; event: string; payload: unknown }>>([])

function captureEvent(eventName: string, payload: unknown) {
  outputLog.value.unshift({
    time: new Date().toLocaleTimeString(),
    event: eventName,
    payload,
  })
}
</script>

<template>
  <div class="component-demo">
    <!-- Left: Component Area -->
    <div class="component-area">
      <h3 class="section-title">Component</h3>
      <TargetComponent
        v-bind="inputProps"
        @select="(val) => captureEvent('select', val)"
        @change="(val) => captureEvent('change', val)"
      />
    </div>

    <!-- Right: Data Dashboard -->
    <div class="data-dashboard">
      <section class="dashboard-section">
        <h3 class="section-title">Input Data</h3>
        <pre class="json-block">{{ JSON.stringify(inputProps, null, 2) }}</pre>
      </section>
      <section class="dashboard-section output-section">
        <h3 class="section-title">
          Output Data
          <button class="clear-btn" @click="outputLog = []">Clear</button>
        </h3>
        <div class="output-log">
          <div v-for="(log, i) in outputLog" :key="i" class="log-entry">
            <span class="log-time">{{ log.time }}</span>
            <span class="log-event">{{ log.event }}</span>
            <pre class="json-block">{{ JSON.stringify(log.payload, null, 2) }}</pre>
          </div>
          <p v-if="!outputLog.length" class="log-empty">No events captured yet.</p>
        </div>
      </section>
    </div>
  </div>
</template>

<style scoped>
.component-demo {
  display: grid;
  grid-template-columns: 1fr 360px;
  gap: 16px;
  padding: 16px;
  height: 100vh;
  font-family: monospace;
  box-sizing: border-box;
}

.component-area {
  border: 2px dashed #ccc;
  border-radius: 8px;
  padding: 16px;
  overflow-y: auto;
}

.data-dashboard {
  display: flex;
  flex-direction: column;
  gap: 12px;
  overflow-y: auto;
}

.dashboard-section {
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  padding: 12px;
}

.output-section {
  flex: 1;
  min-height: 0;
  overflow-y: auto;
}

.section-title {
  margin: 0 0 8px;
  font-size: 14px;
  color: #666;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.clear-btn {
  font-size: 12px;
  padding: 2px 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
  background: #fff;
  cursor: pointer;
}

.json-block {
  margin: 0;
  font-size: 12px;
  white-space: pre-wrap;
  word-break: break-all;
  background: #fafafa;
  padding: 8px;
  border-radius: 4px;
}

.output-log {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.log-entry {
  padding: 6px 8px;
  background: #f5f5f5;
  border-radius: 4px;
  font-size: 12px;
}

.log-time {
  color: #999;
  margin-right: 8px;
}

.log-event {
  color: #1976d2;
  font-weight: bold;
  margin-right: 8px;
}

.log-empty {
  color: #999;
  font-style: italic;
}
</style>
```

### React (Functional Component + Hooks)

```tsx
import { useState, useCallback } from 'react'
import { TargetComponent } from './TargetComponent'

interface LogEntry {
  time: string
  event: string
  payload: unknown
}

export function TargetComponentDemo() {
  // ---- Input Data ----
  const [inputProps] = useState({
    title: 'Demo Title',
    items: [{ id: 1, label: 'Item 1' }],
  })

  // ---- Output Data ----
  const [outputLog, setOutputLog] = useState<LogEntry[]>([])

  const captureEvent = useCallback((eventName: string, payload: unknown) => {
    setOutputLog((prev) => [
      { time: new Date().toLocaleTimeString(), event: eventName, payload },
      ...prev,
    ])
  }, [])

  return (
    <div style={{
      display: 'grid',
      gridTemplateColumns: '1fr 360px',
      gap: 16,
      padding: 16,
      height: '100vh',
      fontFamily: 'monospace',
      boxSizing: 'border-box',
    }}>
      {/* Left: Component Area */}
      <div style={{ border: '2px dashed #ccc', borderRadius: 8, padding: 16, overflowY: 'auto' }}>
        <h3 style={{ margin: '0 0 8px', fontSize: 14, color: '#666' }}>Component</h3>
        <TargetComponent
          {...inputProps}
          onSelect={(val: unknown) => captureEvent('select', val)}
          onChange={(val: unknown) => captureEvent('change', val)}
        />
      </div>

      {/* Right: Data Dashboard */}
      <div style={{ display: 'flex', flexDirection: 'column', gap: 12, overflowY: 'auto' }}>
        <section style={{ border: '1px solid #e0e0e0', borderRadius: 8, padding: 12 }}>
          <h3 style={{ margin: '0 0 8px', fontSize: 14, color: '#666' }}>Input Data</h3>
          <pre style={{ margin: 0, fontSize: 12, whiteSpace: 'pre-wrap', background: '#fafafa', padding: 8, borderRadius: 4 }}>
            {JSON.stringify(inputProps, null, 2)}
          </pre>
        </section>
        <section style={{ border: '1px solid #e0e0e0', borderRadius: 8, padding: 12, flex: 1, minHeight: 0, overflowY: 'auto' }}>
          <h3 style={{ margin: '0 0 8px', fontSize: 14, color: '#666' }}>Output Data</h3>
          {outputLog.length === 0 ? (
            <p style={{ color: '#999', fontStyle: 'italic' }}>No events captured yet.</p>
          ) : (
            outputLog.map((log, i) => (
              <div key={i} style={{ padding: '6px 8px', background: '#f5f5f5', borderRadius: 4, fontSize: 12, marginBottom: 8 }}>
                <span style={{ color: '#999', marginRight: 8 }}>{log.time}</span>
                <span style={{ color: '#1976d2', fontWeight: 'bold', marginRight: 8 }}>{log.event}</span>
                <pre style={{ margin: 0, fontSize: 12, whiteSpace: 'pre-wrap' }}>
                  {JSON.stringify(log.payload, null, 2)}
                </pre>
              </div>
            ))
          )}
        </section>
      </div>
    </div>
  )
}
```

## Output Summary

For each demo created, print:

```
Demo created: {demo-file-path}
Target component: {component-path}
Logging added to original component:
  - {log point 1}: {description}
  - {log point 2}: {description}
Dashboard tracks:
  Input: {list of input data}
  Output: {list of output events}
```
