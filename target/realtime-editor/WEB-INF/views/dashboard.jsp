<%@ page import="com.editor.model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Collaborative Editor</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;700&family=IBM+Plex+Mono:wght@500&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #2563eb;
            --primary-dark: #1d4ed8;
            --secondary: #0f172a;
            --accent: #06b6d4;
            --bg: #f8fafc;
            --surface: #ffffff;
            --border: #e2e8f0;
            --text-primary: #0f172a;
            --text-secondary: #64748b;
            --success: #10b981;
            --error: #ef4444;
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'DM Sans', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--bg);
            color: var(--text-primary);
            line-height: 1.6;
            min-height: 100vh;
        }

        .notification {
            position: fixed;
            top: 2rem;
            right: 2rem;
            background: white;
            border-radius: 12px;
            padding: 1rem 1.5rem;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
            display: flex;
            align-items: center;
            gap: 0.75rem;
            transform: translateX(400px);
            transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            z-index: 1000;
            max-width: 400px;
        }

        .notification.show {
            transform: translateX(0);
        }

        .notification.success {
            border-left: 4px solid var(--success);
        }

        .notification.error {
            border-left: 4px solid var(--error);
        }

        .notification-icon {
            width: 24px;
            height: 24px;
            flex-shrink: 0;
        }

        .notification-icon.success {
            color: var(--success);
        }

        .notification-icon.error {
            color: var(--error);
        }

        .notification-content {
            flex: 1;
        }

        .notification-title {
            font-weight: 600;
            font-size: 0.9375rem;
            margin-bottom: 0.25rem;
        }

        .notification-message {
            font-size: 0.875rem;
            color: var(--text-secondary);
        }

        .header {
            background: var(--surface);
            border-bottom: 1px solid var(--border);
            padding: 1rem 0;
            position: sticky;
            top: 0;
            z-index: 100;
            backdrop-filter: blur(8px);
            background: rgba(255, 255, 255, 0.9);
        }

        .header-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--primary);
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .logo svg {
            width: 28px;
            height: 28px;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary), var(--accent));
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: 600;
            font-size: 0.875rem;
        }

        .user-name {
            font-weight: 500;
            color: var(--text-primary);
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 3rem 2rem;
        }

        .welcome-section {
            margin-bottom: 3rem;
        }

        .welcome-section h1 {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .welcome-section p {
            color: var(--text-secondary);
            font-size: 1rem;
        }

        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 1.5rem;
            margin-top: 2rem;
        }

        .action-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 2rem;
            transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
        }

        .action-card:hover {
            border-color: var(--primary);
            box-shadow: var(--shadow-lg);
            transform: translateY(-2px);
        }

        .card-header {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .icon-wrapper {
            width: 48px;
            height: 48px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            transition: transform 0.2s;
        }

        .action-card:hover .icon-wrapper {
            transform: scale(1.05);
        }

        .create-card .icon-wrapper {
            background: #dbeafe;
            color: var(--primary);
        }

        .join-card .icon-wrapper {
            background: #cffafe;
            color: var(--accent);
        }

        .card-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }

        .card-description {
            font-size: 0.875rem;
            color: var(--text-secondary);
            margin-bottom: 1.5rem;
        }

        .form-group {
            margin-bottom: 1rem;
        }

        label {
            display: block;
            font-size: 0.875rem;
            font-weight: 500;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        input[type="text"] {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid var(--border);
            border-radius: 8px;
            font-size: 0.9375rem;
            font-family: 'IBM Plex Mono', monospace;
            transition: all 0.2s;
            background: var(--surface);
        }

        input[type="text"]:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        input[type="text"]::placeholder {
            color: #cbd5e1;
        }

        button {
            width: 100%;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-size: 0.9375rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            font-family: 'DM Sans', sans-serif;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            box-shadow: var(--shadow-md);
        }

        .btn-primary:active {
            transform: scale(0.98);
        }

        .btn-secondary {
            background: var(--accent);
            color: white;
        }

        .btn-secondary:hover {
            background: #0891b2;
            box-shadow: var(--shadow-md);
        }

        .btn-secondary:active {
            transform: scale(0.98);
        }

        .icon {
            width: 18px;
            height: 18px;
        }

        @media (max-width: 768px) {
            .header-content {
                padding: 0 1rem;
            }

            .container {
                padding: 2rem 1rem;
            }

            .welcome-section h1 {
                font-size: 1.5rem;
            }

            .actions-grid {
                grid-template-columns: 1fr;
            }

            .user-name {
                display: none;
            }

            .notification {
                top: 1rem;
                right: 1rem;
                left: 1rem;
                max-width: none;
            }
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .action-card {
            animation: fadeIn 0.4s ease-out;
        }

        .action-card:nth-child(2) {
            animation-delay: 0.1s;
        }
    </style>
</head>
<body>

<div id="notification" class="notification">
    <svg class="notification-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
        <polyline points="22 4 12 14.01 9 11.01"></polyline>
    </svg>
    <div class="notification-content">
        <div class="notification-title" id="notificationTitle">Success</div>
        <div class="notification-message" id="notificationMessage">Message here</div>
    </div>
</div>

<header class="header">
    <div class="header-content">
        <div class="logo">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/>
                <polyline points="14 2 14 8 20 8"/>
                <line x1="16" y1="13" x2="8" y2="13"/>
                <line x1="16" y1="17" x2="8" y2="17"/>
                <line x1="10" y1="9" x2="8" y2="9"/>
            </svg>
            Collaborative Editor
        </div>
        <div class="user-info">
            <span class="user-name"><%= user.getUsername() %></span>
            <div class="avatar">
                <%= user.getUsername().substring(0, 1).toUpperCase() %>
            </div>
        </div>
    </div>
</header>

<main class="container">
    <div class="welcome-section">
        <h1>Welcome back, <%= user.getUsername() %></h1>
        <p>Start collaborating by creating a new session or joining an existing one.</p>
    </div>

    <div class="actions-grid">
        <div class="action-card create-card">
            <div class="card-header">
                <div class="icon-wrapper">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="24" height="24">
                        <circle cx="12" cy="12" r="10"/>
                        <line x1="12" y1="8" x2="12" y2="16"/>
                        <line x1="8" y1="12" x2="16" y2="12"/>
                    </svg>
                </div>
                <div>
                    <h3 class="card-title">Create Session</h3>
                </div>
            </div>
            <p class="card-description">
                Start a new collaborative editing session and invite others to join.
            </p>
            <form action="createSession" method="post">
                <button type="submit" class="btn-primary">
                    <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="12" y1="5" x2="12" y2="19"/>
                        <line x1="5" y1="12" x2="19" y2="12"/>
                    </svg>
                    Create New Session
                </button>
            </form>
        </div>

        <div class="action-card join-card">
            <div class="card-header">
                <div class="icon-wrapper">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" width="24" height="24">
                        <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/>
                        <polyline points="10 17 15 12 10 7"/>
                        <line x1="15" y1="12" x2="3" y2="12"/>
                    </svg>
                </div>
                <div>
                    <h3 class="card-title">Join Session</h3>
                </div>
            </div>
            <p class="card-description">
                Enter a session code to join an ongoing collaborative session.
            </p>
            <form action="joinSession" method="post">
                <div class="form-group">
                    <label for="sessionCode">Session Code</label>
                    <input 
                        type="text" 
                        id="sessionCode" 
                        name="sessionCode" 
                        placeholder="XXXX-XXXX-XXXX" 
                        required 
                        autocomplete="off"
                    />
                </div>
                <button type="submit" class="btn-secondary">
                    <svg class="icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M15 3h4a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2h-4"/>
                        <polyline points="10 17 15 12 10 7"/>
                        <line x1="15" y1="12" x2="3" y2="12"/>
                    </svg>
                    Join Session
                </button>
            </form>
        </div>
    </div>
</main>

<script>
    // Check for URL parameters for notifications
    const urlParams = new URLSearchParams(window.location.search);
    const message = urlParams.get('message');
    const type = urlParams.get('type');

    if (message) {
        showNotification(decodeURIComponent(message), type || 'success');
        // Clean URL
        window.history.replaceState({}, document.title, window.location.pathname);
    }

    function showNotification(message, type = 'success') {
        const notification = document.getElementById('notification');
        const title = document.getElementById('notificationTitle');
        const messageEl = document.getElementById('notificationMessage');
        const icon = notification.querySelector('.notification-icon');

        // Set content
        title.textContent = type === 'success' ? 'Success' : 'Error';
        messageEl.textContent = message;

        // Set type classes
        notification.className = 'notification ' + type;
        icon.className = 'notification-icon ' + type;

        // Update icon
        if (type === 'success') {
            icon.innerHTML = '<path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline>';
        } else {
            icon.innerHTML = '<circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line>';
        }

        // Show notification
        setTimeout(() => {
            notification.classList.add('show');
        }, 100);

        // Hide after 4 seconds
        setTimeout(() => {
            notification.classList.remove('show');
        }, 4000);
    }
</script>

</body>
</html>