<%@ page import="com.editor.model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
</head>
<body>

<h2>Welcome, <%= user.getUsername() %></h2>

<form action="createSession" method="post">
    <button>Create Session</button>
</form>

<br>

<form action="joinSession" method="post">
    <input type="text" name="sessionCode" placeholder="Enter Session Code" required />
    <button>Join Session</button>
</form>

</body>
</html>
