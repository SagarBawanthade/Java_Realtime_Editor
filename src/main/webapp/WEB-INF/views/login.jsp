<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>

<h2>Login</h2>

<form action="${pageContext.request.contextPath}/login" method="post">

    <input type="email" name="email" placeholder="Email" required /><br><br>

    <input type="password" name="password" placeholder="Password" required /><br><br>

    <button type="submit">Login</button>
</form>

<p>No account?<a href="signup">Signup</a></p>

</body>
</html>
