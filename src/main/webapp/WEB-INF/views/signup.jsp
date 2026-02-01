<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - Collaborative Editor</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #2563eb;
            --primary-dark: #1d4ed8;
            --bg: #f8fafc;
            --surface: #ffffff;
            --border: #e2e8f0;
            --text-primary: #0f172a;
            --text-secondary: #64748b;
            --error: #ef4444;
            --success: #10b981;
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
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
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

        .container {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 3rem;
            max-width: 440px;
            width: 100%;
            box-shadow: var(--shadow-lg);
            animation: fadeIn 0.4s ease-out;
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

        .logo {
            text-align: center;
            margin-bottom: 2rem;
        }

        .logo svg {
            width: 48px;
            height: 48px;
            color: var(--primary);
            margin-bottom: 1rem;
        }

        .logo h1 {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        .logo p {
            font-size: 0.9375rem;
            color: var(--text-secondary);
        }

        .form-group {
            margin-bottom: 1.25rem;
        }

        label {
            display: block;
            font-size: 0.875rem;
            font-weight: 500;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }

        input {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid var(--border);
            border-radius: 8px;
            font-size: 0.9375rem;
            font-family: 'DM Sans', sans-serif;
            transition: all 0.2s;
            background: var(--surface);
        }

        input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        input::placeholder {
            color: #cbd5e1;
        }

        button {
            width: 100%;
            padding: 0.875rem 1.5rem;
            border: none;
            border-radius: 8px;
            font-size: 0.9375rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            font-family: 'DM Sans', sans-serif;
            background: var(--primary);
            color: white;
            margin-top: 0.5rem;
        }

        button:hover {
            background: var(--primary-dark);
            transform: translateY(-1px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        button:active {
            transform: scale(0.98);
        }

        button:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        .footer-link {
            text-align: center;
            font-size: 0.9375rem;
            color: var(--text-secondary);
            margin-top: 1.5rem;
        }

        .footer-link a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s;
        }

        .footer-link a:hover {
            color: var(--primary-dark);
            text-decoration: underline;
        }

        @media (max-width: 480px) {
            .container {
                padding: 2rem 1.5rem;
            }

            body {
                padding: 1rem;
            }

            .notification {
                top: 1rem;
                right: 1rem;
                left: 1rem;
                max-width: none;
            }
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

<div class="container">
    <div class="logo">
        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
            <path d="M14.5 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V7.5L14.5 2z"/>
            <polyline points="14 2 14 8 20 8"/>
            <line x1="16" y1="13" x2="8" y2="13"/>
            <line x1="16" y1="17" x2="8" y2="17"/>
            <line x1="10" y1="9" x2="8" y2="9"/>
        </svg>
        <h1>Create Account</h1>
        <p>Get started with collaborative editing</p>
    </div>

    <form action="${pageContext.request.contextPath}/signup" method="post" id="signupForm">
        <div class="form-group">
            <label for="username">Username</label>
            <input 
                type="text" 
                id="username" 
                name="username" 
                placeholder="Choose a username" 
                required 
                autocomplete="username"
            />
        </div>

        <div class="form-group">
            <label for="email">Email Address</label>
            <input 
                type="email" 
                id="email" 
                name="email" 
                placeholder="you@example.com" 
                required 
                autocomplete="email"
            />
        </div>

        <div class="form-group">
            <label for="password">Password</label>
            <input 
                type="password" 
                id="password" 
                name="password" 
                placeholder="Create a strong password" 
                required 
                autocomplete="new-password"
            />
        </div>

        <div class="form-group">
            <label for="confirmPassword">Confirm Password</label>
            <input 
                type="password" 
                id="confirmPassword" 
                name="confirmPassword" 
                placeholder="Re-enter your password" 
                required 
                autocomplete="new-password"
            />
        </div>

        <button type="submit" id="submitBtn">Create Account</button>
    </form>

    <p class="footer-link">
        Already have an account? <a href="login">Sign in</a>
    </p>
</div>

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

    // Form submission handling
    document.getElementById('signupForm').addEventListener('submit', function(e) {
        const submitBtn = document.getElementById('submitBtn');
        submitBtn.disabled = true;
        submitBtn.textContent = 'Creating account...';
        
        // Re-enable after 3 seconds in case of error
        setTimeout(() => {
            submitBtn.disabled = false;
            submitBtn.textContent = 'Create Account';
        }, 3000);
    });
</script>

</body>
</html>