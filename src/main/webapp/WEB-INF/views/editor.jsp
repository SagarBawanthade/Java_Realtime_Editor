<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.editor.model.User" %>

<%
    User user = (User) session.getAttribute("user");
    String sessionCode = (String) session.getAttribute("sessionCode");
    String code = (String) request.getAttribute("code");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editor - <%= sessionCode %> | Collaborative Editor</title>
    
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500;600&display=swap" rel="stylesheet">
    
    <!-- CodeMirror CSS -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/codemirror.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/theme/material-darker.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/addon/hint/show-hint.min.css">
    
    <style>
        :root {
            --primary: #3b82f6;
            --primary-dark: #2563eb;
            --primary-light: #60a5fa;
            --accent: #06b6d4;
            --accent-dark: #0891b2;
            --bg: #0f1419;
            --surface: #1a1f2e;
            --surface-light: #252d3d;
            --border: #2d3748;
            --text-primary: #f8fafc;
            --text-secondary: #94a3b8;
            --text-muted: #64748b;
            --success: #10b981;
            --success-dark: #059669;
            --warning: #f59e0b;
            --error: #ef4444;
            --editor-bg: #1e293b;
            --terminal-bg: #0a0e1a;
            --shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.3);
            --shadow-lg: 0 20px 25px -5px rgba(0, 0, 0, 0.4);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--bg);
            color: var(--text-primary);
            height: 100vh;
            overflow: hidden;
            display: flex;
            flex-direction: column;
        }

        /* Header */
        .header {
            background: linear-gradient(135deg, var(--surface) 0%, #1e2532 100%);
            border-bottom: 1px solid var(--border);
            padding: 1rem 1.5rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-shrink: 0;
            box-shadow: var(--shadow);
            position: relative;
            z-index: 10;
        }

        .header-left {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }

        .logo {
            font-size: 1.25rem;
            font-weight: 700;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            display: flex;
            align-items: center;
            gap: 0.625rem;
        }

        .logo svg {
            width: 28px;
            height: 28px;
            stroke: url(#logo-gradient);
        }

        .session-badge {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            background: var(--surface-light);
            padding: 0.625rem 1.125rem;
            border-radius: 10px;
            border: 1px solid var(--border);
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
            transition: all 0.3s ease;
        }

        .session-badge:hover {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .session-label {
            font-size: 0.75rem;
            color: var(--text-muted);
            text-transform: uppercase;
            font-weight: 600;
            letter-spacing: 0.05em;
        }

        .session-code-wrapper {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .session-code {
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.9375rem;
            color: var(--accent);
            font-weight: 600;
            letter-spacing: 0.05em;
        }

        .copy-btn {
            background: transparent;
            border: none;
            color: var(--text-secondary);
            cursor: pointer;
            padding: 0.25rem;
            border-radius: 6px;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .copy-btn:hover {
            background: rgba(59, 130, 246, 0.1);
            color: var(--primary);
        }

        .copy-btn:active {
            transform: scale(0.9);
        }

        .copy-btn svg {
            width: 16px;
            height: 16px;
        }

        .copy-btn.copied {
            color: var(--success);
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .run-button {
            display: flex;
            align-items: center;
            gap: 0.625rem;
            padding: 0.625rem 1.5rem;
            background: linear-gradient(135deg, var(--success), var(--success-dark));
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 0.875rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px rgba(16, 185, 129, 0.3);
            position: relative;
            overflow: hidden;
        }

        .run-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(16, 185, 129, 0.4);
        }

        .run-button:active {
            transform: translateY(0);
        }

        .run-button svg {
            width: 16px;
            height: 16px;
        }

        .user-badge {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.5rem 1rem;
            background: var(--surface-light);
            border-radius: 10px;
            border: 1px solid var(--border);
            transition: all 0.2s;
        }

        .user-badge:hover {
            border-color: var(--primary-light);
        }

        .user-icon {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.875rem;
            font-weight: 600;
            box-shadow: 0 2px 8px rgba(59, 130, 246, 0.3);
        }

        .username {
            font-size: 0.875rem;
            font-weight: 500;
            color: var(--text-primary);
        }

        /* Status Bar */
        .status-bar {
            background: var(--surface);
            border-bottom: 1px solid var(--border);
            padding: 0.75rem 1.5rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            min-height: 48px;
            flex-shrink: 0;
        }

        .status-left {
            display: flex;
            align-items: center;
            gap: 1.5rem;
        }

        .status-indicator {
            display: flex;
            align-items: center;
            gap: 0.625rem;
            font-size: 0.8125rem;
            font-weight: 500;
        }

        .status-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: var(--success);
            animation: pulse 2s infinite;
            box-shadow: 0 0 8px var(--success);
        }

        .status-dot.disconnected {
            background: var(--error);
            box-shadow: 0 0 8px var(--error);
            animation: none;
        }

        .status-dot.connecting {
            background: var(--warning);
            box-shadow: 0 0 8px var(--warning);
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; transform: scale(1); }
            50% { opacity: 0.6; transform: scale(0.95); }
        }

        .typing-indicator {
            color: var(--accent);
            font-size: 0.8125rem;
            font-style: italic;
            min-height: 20px;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .typing-dots {
            display: inline-flex;
            gap: 3px;
        }

        .typing-dot {
            width: 4px;
            height: 4px;
            background: var(--accent);
            border-radius: 50%;
            animation: typingDot 1.4s infinite;
        }

        .typing-dot:nth-child(2) { animation-delay: 0.2s; }
        .typing-dot:nth-child(3) { animation-delay: 0.4s; }

        @keyframes typingDot {
            0%, 60%, 100% { opacity: 0.3; transform: translateY(0); }
            30% { opacity: 1; transform: translateY(-4px); }
        }

        /* Main Layout */
        .main-container {
            flex: 1;
            display: flex;
            overflow: hidden;
        }

        /* Participants Sidebar */
        .participants-sidebar {
            width: 280px;
            background: var(--surface);
            border-right: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
        }

        .sidebar-header {
            padding: 1.25rem 1rem;
            border-bottom: 1px solid var(--border);
            background: linear-gradient(135deg, var(--surface) 0%, var(--surface-light) 100%);
        }

        .sidebar-title {
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.5rem;
        }

        .participant-count {
            font-size: 1.125rem;
            color: var(--text-primary);
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .participant-count-badge {
            background: linear-gradient(135deg, var(--primary), var(--accent));
            padding: 0.25rem 0.625rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 700;
        }

        .participants-list {
            flex: 1;
            overflow-y: auto;
            padding: 0.75rem;
        }

        .participants-list::-webkit-scrollbar {
            width: 6px;
        }

        .participants-list::-webkit-scrollbar-track {
            background: transparent;
        }

        .participants-list::-webkit-scrollbar-thumb {
            background: var(--border);
            border-radius: 3px;
        }

        .participant-item {
            display: flex;
            align-items: center;
            gap: 0.875rem;
            padding: 0.875rem;
            border-radius: 8px;
            margin-bottom: 0.5rem;
            transition: all 0.2s;
            border: 1px solid transparent;
        }

        .participant-item:hover {
            background: var(--surface-light);
            border-color: var(--border);
        }

        .participant-item.active {
            background: rgba(59, 130, 246, 0.1);
            border-color: rgba(59, 130, 246, 0.3);
        }

        .participant-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.875rem;
            font-weight: 600;
            flex-shrink: 0;
            box-shadow: 0 2px 8px rgba(59, 130, 246, 0.3);
        }

        .participant-info {
            flex: 1;
            min-width: 0;
        }

        .participant-name {
            font-size: 0.9375rem;
            font-weight: 600;
            color: var(--text-primary);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            margin-bottom: 0.125rem;
        }

        .participant-status {
            font-size: 0.75rem;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            gap: 0.375rem;
        }

        .participant-indicator {
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background: var(--success);
            flex-shrink: 0;
            box-shadow: 0 0 6px var(--success);
            animation: pulse 2s infinite;
        }

        /* Editor Panel */
        .editor-panel {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .split-container {
            flex: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .code-editor-section {
            flex: 1;
            display: flex;
            flex-direction: column;
            min-height: 0;
            border-bottom: 1px solid var(--border);
        }

        .section-header {
            padding: 0.75rem 1.25rem;
            background: var(--surface);
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .section-title {
            font-size: 0.75rem;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .section-title svg {
            width: 14px;
            height: 14px;
        }

        .editor-info {
            font-size: 0.75rem;
            color: var(--text-secondary);
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .editor-info-item {
            display: flex;
            align-items: center;
            gap: 0.375rem;
        }

        .editor-wrapper {
            flex: 1;
            position: relative;
            overflow: hidden;
            background: var(--editor-bg);
        }

        .CodeMirror {
            height: 100% !important;
            font-family: 'JetBrains Mono', monospace !important;
            font-size: 14px !important;
            line-height: 1.6 !important;
        }

        .CodeMirror-gutters {
            background: var(--surface) !important;
            border-right: 1px solid var(--border) !important;
        }

        .CodeMirror-linenumber {
            color: var(--text-muted) !important;
            padding: 0 8px !important;
        }

        /* Terminal */
        .terminal-section {
            height: 280px;
            display: flex;
            flex-direction: column;
            background: var(--terminal-bg);
            flex-shrink: 0;
        }

        .terminal-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0.75rem 1.25rem;
            background: var(--surface);
            border-bottom: 1px solid var(--border);
        }

        .terminal-actions {
            display: flex;
            gap: 0.5rem;
        }

        .terminal-btn {
            background: var(--surface-light);
            border: 1px solid var(--border);
            color: var(--text-secondary);
            padding: 0.375rem 0.875rem;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 0.375rem;
        }

        .terminal-btn:hover {
            background: var(--border);
            color: var(--text-primary);
        }

        .terminal-btn svg {
            width: 12px;
            height: 12px;
        }

        .terminal-output {
            flex: 1;
            overflow-y: auto;
            padding: 1rem;
            font-family: 'JetBrains Mono', monospace;
            font-size: 13px;
            line-height: 1.6;
            color: #e2e8f0;
        }

        .terminal-output::-webkit-scrollbar {
            width: 10px;
        }

        .terminal-output::-webkit-scrollbar-track {
            background: var(--terminal-bg);
        }

        .terminal-output::-webkit-scrollbar-thumb {
            background: var(--surface-light);
            border-radius: 5px;
        }

        .terminal-output::-webkit-scrollbar-thumb:hover {
            background: var(--border);
        }

        .terminal-line {
            margin-bottom: 0.25rem;
            display: flex;
            align-items: flex-start;
            gap: 0.5rem;
        }

        .terminal-line .icon {
            flex-shrink: 0;
            margin-top: 2px;
        }

        .terminal-line.info { color: var(--accent); }
        .terminal-line.success { color: var(--success); }
        .terminal-line.error { color: var(--error); }
        .terminal-line.output { color: #e2e8f0; }
        .terminal-line.debug { color: var(--warning); }

        .terminal-prompt { color: var(--success); font-weight: 600; }

        /* Tooltip */
        .tooltip {
            position: absolute;
            background: var(--surface-light);
            color: var(--text-primary);
            padding: 0.5rem 0.75rem;
            border-radius: 6px;
            font-size: 0.75rem;
            white-space: nowrap;
            pointer-events: none;
            opacity: 0;
            transition: opacity 0.2s;
            z-index: 1000;
            border: 1px solid var(--border);
            box-shadow: var(--shadow);
        }

        /* Responsive */
        @media (max-width: 1024px) {
            .participants-sidebar { width: 240px; }
            .terminal-section { height: 240px; }
        }

        @media (max-width: 768px) {
            .participants-sidebar {
                position: absolute;
                left: -280px;
                height: 100%;
                z-index: 10;
                transition: left 0.3s;
            }
            .participants-sidebar.show { left: 0; }
            .username { display: none; }
            .terminal-section { height: 200px; }
            .editor-info { display: none; }
        }

        /* Loading Overlay */
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(15, 20, 25, 0.9);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            opacity: 1;
            transition: opacity 0.3s;
        }

        .loading-overlay.hidden {
            opacity: 0;
            pointer-events: none;
        }

        .spinner {
            width: 50px;
            height: 50px;
            border: 4px solid var(--border);
            border-top-color: var(--primary);
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }
    </style>
</head>
<body>

<!-- Loading Overlay -->
<div class="loading-overlay" id="loadingOverlay">
    <div class="spinner"></div>
</div>

<!-- SVG Gradient Definition -->
<svg width="0" height="0">
    <defs>
        <linearGradient id="logo-gradient" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" style="stop-color:#3b82f6;stop-opacity:1" />
            <stop offset="100%" style="stop-color:#06b6d4;stop-opacity:1" />
        </linearGradient>
    </defs>
</svg>

<header class="header">
    <div class="header-left">
        <div class="logo">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/>
                <polyline points="14 2 14 8 20 8"/>
            </svg>
            CodeSync
        </div>
        <div class="session-badge">
            <span class="session-label">Session</span>
            <div class="session-code-wrapper">
                <span class="session-code"><%= sessionCode %></span>
                <button class="copy-btn" id="copySessionBtn" title="Copy session code">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>
                        <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
                    </svg>
                </button>
            </div>
        </div>
    </div>
    <div class="header-right">
        <button class="run-button" onclick="runCode()">
            <svg viewBox="0 0 24 24" fill="currentColor">
                <polygon points="5 3 19 12 5 21 5 3"></polygon>
            </svg>
            Run Code
        </button>
        <div class="user-badge">
            <div class="user-icon">
                <%= user.getUsername().substring(0, 1).toUpperCase() %>
            </div>
            <span class="username"><%= user.getUsername() %></span>
        </div>
    </div>
</header>

<div class="status-bar">
    <div class="status-left">
        <div class="status-indicator">
            <span class="status-dot" id="statusDot"></span>
            <span id="statusText">Connecting...</span>
        </div>
        <div id="typingStatus" class="typing-indicator"></div>
    </div>
    <div class="editor-info">
        <div class="editor-info-item">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M17 3a2.828 2.828 0 1 1 4 4L7.5 20.5 2 22l1.5-5.5L17 3z"/>
            </svg>
            <span id="editorLines">1 line</span>
        </div>
        <div class="editor-info-item">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <polyline points="16 18 22 12 16 6"></polyline>
                <polyline points="8 6 2 12 8 18"></polyline>
            </svg>
            <span>Java</span>
        </div>
    </div>
</div>

<div class="main-container">
    <!-- Participants Sidebar -->
    <aside class="participants-sidebar">
        <div class="sidebar-header">
            <div class="sidebar-title">Participants</div>
            <div class="participant-count">
                <span class="participant-count-badge" id="participantCount">1</span>
                <span>online</span>
            </div>
        </div>
        <div class="participants-list" id="participantsList">
            <div class="participant-item active" data-username="<%= user.getUsername() %>">
                <div class="participant-avatar"><%= user.getUsername().substring(0, 1).toUpperCase() %></div>
                <div class="participant-info">
                    <div class="participant-name"><%= user.getUsername() %> (You)</div>
                    <div class="participant-status">
                        <span class="participant-indicator"></span>
                        Active now
                    </div>
                </div>
            </div>
        </div>
    </aside>

    <!-- Editor Panel -->
    <div class="editor-panel">
        <div class="split-container">
            <!-- Code Editor -->
            <div class="code-editor-section">
                <div class="section-header">
                    <div class="section-title">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="16 18 22 12 16 6"></polyline>
                            <polyline points="8 6 2 12 8 18"></polyline>
                        </svg>
                        Code Editor
                    </div>
                    <div class="editor-info">
                        <div class="editor-info-item">
                            <span id="cursorPosition">Ln 1, Col 1</span>
                        </div>
                    </div>
                </div>
                <div class="editor-wrapper">
                    <textarea id="codeArea" style="display:none;"><%= code != null ? code : "" %></textarea>
                </div>
            </div>

            <!-- Terminal -->
            <div class="terminal-section">
                <div class="terminal-header">
                    <div class="section-title">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <polyline points="4 17 10 11 4 5"></polyline>
                            <line x1="12" y1="19" x2="20" y2="19"></line>
                        </svg>
                        Terminal Output
                    </div>
                    <div class="terminal-actions">
                        <button class="terminal-btn" onclick="clearTerminal()" title="Clear terminal">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <polyline points="3 6 5 6 21 6"></polyline>
                                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>
                            </svg>
                            Clear
                        </button>
                    </div>
                </div>
                <div class="terminal-output" id="terminalOutput">
                    <div class="terminal-line info">
                        <span class="icon">ℹ</span>
                        <span>CodeSync Collaborative Editor v1.0</span>
                    </div>
                    <div class="terminal-line info">
                        <span class="icon">✓</span>
                        <span>Ready to execute Java code...</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- CodeMirror JS -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/codemirror.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/mode/clike/clike.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/addon/edit/closebrackets.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/addon/edit/matchbrackets.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/addon/selection/active-line.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/addon/hint/show-hint.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/addon/hint/anyword-hint.min.js"></script>

<script>
    const sessionCode = "<%= sessionCode %>";
    const username = "<%= user.getUsername() %>";
    const terminalOutput = document.getElementById("terminalOutput");
    const participantsList = document.getElementById("participantsList");
    const participantCount = document.getElementById("participantCount");
    const statusDot = document.getElementById("statusDot");
    const statusText = document.getElementById("statusText");
    const typingStatus = document.getElementById("typingStatus");
    const loadingOverlay = document.getElementById("loadingOverlay");

    let socket = null;
    let remoteUpdate = false;
    let typingTimeout = null;
    let participants = new Map();
    let reconnectAttempts = 0;
    const MAX_RECONNECT_ATTEMPTS = 5;
    let codeMirrorEditor = null;

    // Initialize CodeMirror
    const textarea = document.getElementById("codeArea");
    codeMirrorEditor = CodeMirror.fromTextArea(textarea, {
        mode: "text/x-java",
        theme: "material-darker",
        lineNumbers: true,
        matchBrackets: true,
        autoCloseBrackets: true,
        styleActiveLine: true,
        indentUnit: 4,
        indentWithTabs: false,
        lineWrapping: false,
        extraKeys: {
            "Ctrl-Space": "autocomplete",
            "Tab": function(cm) {
                if (cm.somethingSelected()) {
                    cm.indentSelection("add");
                } else {
                    cm.replaceSelection("    ", "end");
                }
            }
        }
    });

    // Initialize participants with current user
    participants.set(username, {
        name: username,
        isCurrentUser: true,
        lastSeen: Date.now()
    });

    // CodeMirror change handler
    codeMirrorEditor.on("change", function(cm, change) {
        if (remoteUpdate) return;

        const code = cm.getValue();
        
        // Update line count
        const lineCount = cm.lineCount();
        document.getElementById("editorLines").textContent = lineCount + (lineCount === 1 ? " line" : " lines");

        // Send code update
        sendMessage({
            type: "CODE",
            username: username,
            code: code,
            sessionCode: sessionCode
        });

        // Send typing indicator
        sendMessage({
            type: "TYPING",
            username: username,
            sessionCode: sessionCode
        });

        // Clear previous timeout
        if (typingTimeout) clearTimeout(typingTimeout);

        // Set timeout to send stop typing
        typingTimeout = setTimeout(() => {
            sendMessage({
                type: "STOP_TYPING",
                username: username,
                sessionCode: sessionCode
            });
        }, 1500);
    });

    // Update cursor position
    codeMirrorEditor.on("cursorActivity", function(cm) {
        const cursor = cm.getCursor();
        document.getElementById("cursorPosition").textContent = 
            `Ln ${cursor.line + 1}, Col ${cursor.ch + 1}`;
    });

    // WebSocket connection
    function connectWebSocket() {
        const wsUrl = "ws://" + window.location.host + "/ws/editor/" + sessionCode;
        
        addTerminalLine("Connecting to WebSocket...", "debug", "⚡");
        statusDot.className = "status-dot connecting";
        statusText.textContent = "Connecting...";

        try {
            socket = new WebSocket(wsUrl);

            socket.onopen = () => {
                console.log("WebSocket connected");
                addTerminalLine("WebSocket connected successfully", "success", "✓");
                addTerminalLine("Session: " + sessionCode, "info", "ℹ");
                statusDot.className = "status-dot";
                statusText.textContent = "Connected";
                reconnectAttempts = 0;
                
                // Hide loading overlay
                setTimeout(() => {
                    loadingOverlay.classList.add("hidden");
                }, 500);

                // Send initial join message
                sendMessage({
                    type: "JOIN",
                    username: username,
                    sessionCode: sessionCode
                });
            };

            socket.onmessage = (event) => {
                console.log("WebSocket message received:", event.data);
                
                try {
                    const data = JSON.parse(event.data);
                    handleWebSocketMessage(data);
                } catch (e) {
                    console.error("Error parsing WebSocket message:", e);
                    addTerminalLine("Error parsing message: " + e.message, "error", "✗");
                }
            };

            socket.onerror = (error) => {
                console.error("WebSocket error:", error);
                addTerminalLine("WebSocket error occurred", "error", "✗");
                statusDot.className = "status-dot disconnected";
                statusText.textContent = "Connection Error";
            };

            socket.onclose = (event) => {
                console.log("WebSocket closed:", event.code, event.reason);
                addTerminalLine("WebSocket disconnected (Code: " + event.code + ")", "error", "✗");
                statusDot.className = "status-dot disconnected";
                statusText.textContent = "Disconnected";

                // Attempt to reconnect
                if (reconnectAttempts < MAX_RECONNECT_ATTEMPTS) {
                    reconnectAttempts++;
                    const delay = Math.min(1000 * reconnectAttempts, 5000);
                    addTerminalLine("Reconnecting in " + (delay/1000) + "s... (Attempt " + reconnectAttempts + "/" + MAX_RECONNECT_ATTEMPTS + ")", "info", "⟳");
                    setTimeout(connectWebSocket, delay);
                } else {
                    addTerminalLine("Max reconnection attempts reached. Please refresh the page.", "error", "✗");
                }
            };

        } catch (e) {
            console.error("Error creating WebSocket:", e);
            addTerminalLine("Failed to create WebSocket: " + e.message, "error", "✗");
        }
    }

    // Handle WebSocket messages
    function handleWebSocketMessage(data) {
        console.log("Handling message type:", data.type, data);

        switch(data.type) {
            case "CODE":
                if (data.username !== username) {
                    remoteUpdate = true;
                    const cursor = codeMirrorEditor.getCursor();
                    codeMirrorEditor.setValue(data.code);
                    codeMirrorEditor.setCursor(cursor);
                    remoteUpdate = false;
                    addTerminalLine("Code updated by: " + data.username, "debug", "↻");
                }
                break;

            case "TYPING":
                if (data.username !== username) {
                    typingStatus.innerHTML = `
                        <span>${data.username} is typing</span>
                        <span class="typing-dots">
                            <span class="typing-dot"></span>
                            <span class="typing-dot"></span>
                            <span class="typing-dot"></span>
                        </span>
                    `;
                    addParticipant(data.username);
                }
                break;

            case "STOP_TYPING":
                if (data.username !== username) {
                    typingStatus.textContent = "";
                }
                break;

            case "JOIN":
                addParticipant(data.username);
                if (data.username !== username) {
                    addTerminalLine(data.username + " joined the session", "info", "👋");
                }
                break;

            case "LEAVE":
                removeParticipant(data.username);
                if (data.username !== username) {
                    addTerminalLine(data.username + " left the session", "info", "👋");
                }
                break;

            default:
                console.log("Unknown message type:", data.type);
        }
    }

    // Send WebSocket message
    function sendMessage(message) {
        if (socket && socket.readyState === WebSocket.OPEN) {
            socket.send(JSON.stringify(message));
            console.log("Sent message:", message);
            return true;
        } else {
            console.warn("WebSocket not ready, state:", socket ? socket.readyState : "null");
            return false;
        }
    }

    // Run Code
    function runCode() {
        const code = codeMirrorEditor.getValue().trim();
        
        if (!code) {
            addTerminalLine("No code to execute", "error", "✗");
            return;
        }

        addTerminalLine("", "output");
        addTerminalLine("Running Java code...", "info", "▶");
        addTerminalLine("Compiling...", "info", "⚙");

        // Simulate compilation and execution
        setTimeout(() => {
            addTerminalLine("Compilation successful", "success", "✓");
            addTerminalLine("", "output");
            addTerminalLine("--- Program Output ---", "info", "▶");
            
            // Dummy output based on code content
            const lowerCode = code.toLowerCase();
            if (lowerCode.includes("hello") || lowerCode.includes("system.out.println")) {
                if (lowerCode.includes('"hello')) {
                    addTerminalLine("Hello, World!", "output", "→");
                } else {
                    addTerminalLine("Output from your program", "output", "→");
                }
            } else {
                addTerminalLine("Program executed successfully", "output", "→");
            }
            
            addTerminalLine("", "output");
            addTerminalLine("Execution completed in 0.23s", "success", "✓");
            addTerminalLine("Exit code: 0", "success", "✓");
        }, 1200);
    }

    // Clear Terminal
    function clearTerminal() {
        terminalOutput.innerHTML = `
            <div class="terminal-line info">
                <span class="icon">ℹ</span>
                <span>Terminal cleared</span>
            </div>
        `;
    }

    // Add terminal line
    function addTerminalLine(text, type = "output", icon = null) {
        const line = document.createElement("div");
        line.className = "terminal-line " + type;
        
        const iconSpan = document.createElement("span");
        iconSpan.className = "icon";
        iconSpan.textContent = icon || (type === "debug" ? "⚡" : type === "success" ? "✓" : type === "error" ? "✗" : type === "info" ? "ℹ" : "→");
        
        const textSpan = document.createElement("span");
        textSpan.textContent = text;
        
        line.appendChild(iconSpan);
        line.appendChild(textSpan);
        terminalOutput.appendChild(line);
        terminalOutput.scrollTop = terminalOutput.scrollHeight;

        // Limit terminal lines
        while (terminalOutput.children.length > 500) {
            terminalOutput.removeChild(terminalOutput.firstChild);
        }
    }

    // Add participant
    function addParticipant(name) {
        if (name === username) return; // Don't add current user again
        
        if (participants.has(name)) {
            participants.get(name).lastSeen = Date.now();
            return;
        }
        
        participants.set(name, {
            name: name,
            isCurrentUser: false,
            lastSeen: Date.now()
        });
        
        participantCount.textContent = participants.size;

        const participantItem = document.createElement("div");
        participantItem.className = "participant-item";
        participantItem.setAttribute("data-username", name);
        participantItem.innerHTML = `
            <div class="participant-avatar">${name.substring(0, 1).toUpperCase()}</div>
            <div class="participant-info">
                <div class="participant-name">${name}</div>
                <div class="participant-status">
                    <span class="participant-indicator"></span>
                    Active now
                </div>
            </div>
        `;
        participantsList.appendChild(participantItem);
    }

    // Remove participant
    function removeParticipant(name) {
        if (participants.has(name) && name !== username) {
            participants.delete(name);
            participantCount.textContent = participants.size;

            const participantItem = participantsList.querySelector(`[data-username="${name}"]`);
            if (participantItem) {
                participantItem.style.opacity = "0";
                setTimeout(() => participantItem.remove(), 200);
            }
        }
    }

    // Copy session code
    document.getElementById("copySessionBtn").addEventListener("click", function() {
        const btn = this;
        navigator.clipboard.writeText(sessionCode).then(() => {
            btn.classList.add("copied");
            btn.innerHTML = `
                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <polyline points="20 6 9 17 4 12"></polyline>
                </svg>
            `;
            addTerminalLine("Session code copied to clipboard", "success", "✓");
            
            setTimeout(() => {
                btn.classList.remove("copied");
                btn.innerHTML = `
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>
                        <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
                    </svg>
                `;
            }, 2000);
        }).catch(err => {
            addTerminalLine("Failed to copy session code", "error", "✗");
        });
    });

    // Initialize
    connectWebSocket();

    // Send leave message when page unloads
    window.addEventListener("beforeunload", () => {
        sendMessage({
            type: "LEAVE",
            username: username,
            sessionCode: sessionCode
        });
    });

    // Focus editor on load
    setTimeout(() => {
        codeMirrorEditor.refresh();
        codeMirrorEditor.focus();
    }, 100);
</script>

</body>
</html>