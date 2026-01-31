<%@ page import="com.editor.model.User" %>
<%@ page import="com.editor.dao.SessionCodeDAO" %>

<%
    User user = (User) session.getAttribute("user");
    Integer sessionId = (Integer) session.getAttribute("sessionId");
    String sessionCode = (String) session.getAttribute("sessionCode");

    if (user == null || sessionId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    SessionCodeDAO codeDAO = new SessionCodeDAO();
    String code = codeDAO.getCode(sessionId);
%>


<%
    String role = (String) session.getAttribute("role");
%>

<% if ("HOST".equals(role)) { %>
    <form action="endSession" method="post">
        <button style="color:red;">End Session</button>
    </form>
<% } %>

<!DOCTYPE html>
<html>
<head>
    <title>Editor</title>
</head>
<body>

<h3>Session Code: <%= sessionCode %></h3>

<textarea id="codeArea" rows="20" cols="80"><%= code %></textarea>

<br><br>

<button onclick="runCode()">Run</button>

<pre id="output"></pre>

<script>
    function runCode() {
        alert("Run will be implemented next");
    }
</script>

</body>
</html>
