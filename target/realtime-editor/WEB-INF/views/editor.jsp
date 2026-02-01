<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.editor.model.User" %>

<%
    User user = (User) session.getAttribute("user");
    String sessionCode = (String) session.getAttribute("sessionCode");
    String code = (String) request.getAttribute("code"); // loaded by EditorServlet
%>

<!DOCTYPE html>
<html>
<head>
    <title>Real-Time Code Editor</title>
</head>
<body>

<h3>Session Code: <%= sessionCode %></h3>
<h4>Logged in as: <%= user.getUsername() %></h4>

<div id="typingStatus" style="color: gray; margin-bottom: 5px;"></div>

<textarea id="codeArea" rows="20" cols="80"><%= code != null ? code : "" %></textarea>

<script>
    const sessionCode = "<%= sessionCode %>";
    const username = "<%= user.getUsername() %>";
    const editor = document.getElementById("codeArea");
    const typingStatus = document.getElementById("typingStatus");

    const socket = new WebSocket(
        "ws://localhost:8080/ws/editor/" + sessionCode
    );

    let remoteUpdate = false;
    let typingTimeout;

    socket.onopen = () => {
        console.log("WebSocket connected");
    };

    socket.onmessage = (event) => {
        const data = JSON.parse(event.data);

        if (data.type === "CODE") {
            if (data.username !== username) {
                remoteUpdate = true;
                editor.value = data.code;
                remoteUpdate = false;
            }
        }

        if (data.type === "TYPING") {
            if (data.username !== username) {
                typingStatus.innerText = data.username + " is typing...";
            }
        }

        if (data.type === "STOP_TYPING") {
            typingStatus.innerText = "";
        }
    };

    editor.addEventListener("input", () => {
        if (remoteUpdate || socket.readyState !== WebSocket.OPEN) return;

        // send code
        socket.send(JSON.stringify({
            type: "CODE",
            username: username,
            code: editor.value
        }));

        // send typing
        socket.send(JSON.stringify({
            type: "TYPING",
            username: username
        }));

        clearTimeout(typingTimeout);
        typingTimeout = setTimeout(() => {
            socket.send(JSON.stringify({
                type: "STOP_TYPING",
                username: username
            }));
        }, 1500);
    });
</script>

</body>
</html>
