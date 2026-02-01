<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Real-Time Editor</title>
</head>
<body>

<h3>Session Code: <%= session.getAttribute("sessionCode") %></h3>

<textarea id="codeArea" rows="20" cols="80"></textarea>

<script>
    const sessionCode = "<%= session.getAttribute("sessionCode") %>";
    const editor = document.getElementById("codeArea");

    // const socket = new WebSocket(
    //     "ws://localhost:8080/realtime-editor/ws/editor/" + sessionCode
    // );

    const socket = new WebSocket("ws://localhost:8080/ws/editor/" + sessionCode);

    let remote = false;

    socket.onopen = () => console.log("WebSocket connected");

    socket.onmessage = (e) => {
        remote = true;
        editor.value = e.data;
        remote = false;
    };

    editor.addEventListener("input", () => {
        if (!remote) {
            socket.send(editor.value);
        }
    });
</script>

</body>
</html>