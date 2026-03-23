## 📡 WebSocket Integration Guide (Chat Namespace)

This guide explains how to connect to the chat gateway using Socket.IO and what events to emit or listen to.

### 🌐 Namespace

Connect to:

```
/ws/chat
```

Example connection using Socket.IO:

```ts
const socket = io('https://your-domain.com/ws/chat', {
  auth: {
    token: 'YOUR_JWT_TOKEN',
  },
});
```

---

### 🔐 Authentication

All socket connections must send a valid JWT token using the `auth.token` field.

---

### 📶 Events

#### `chat:active`

Join a chat room (only one room at a time per client).

**Payload:**

```json
{
  "chatId": "CHAT_ID"
}
```

#### `chat:inactive`

Leave a specific chat room.

**Payload:**

```json
{
  "chatId": "CHAT_ID"
}
```

#### `typing`

Notify the other user when typing.

**Payload:**

```json
{
  "fromUserId": "USER_ID",
  "toUserId": "USER_ID",
  "isTyping": true
}
```

**Emits to recipient:**

```json
{
  "fromUserId": "USER_ID",
  "isTyping": true
}
```

#### `markChatRead`

Mark messages in a chat as read.

**Payload:**

```json
{
  "chatId": "CHAT_ID",
  "userId": "YOUR_USER_ID",
  "lastReadMessageId": "MESSAGE_ID"
}
```

**Emits to the other user:**

```json
{
  "chatId": "CHAT_ID",
  "userId": "YOUR_USER_ID",
  "lastReadMessageId": "MESSAGE_ID"
}
```

---

### 📥 Incoming Events (Listen for these)

#### `receiveMessage`

Fired when a new message is received.

```json
{
  "fromUserId": "USER_ID",
  "message": {
    // full message object
  }
}
```

#### `chatUpdated`

Fired when a chat’s last message gets updated.

```json
{
  "chatId": "CHAT_ID",
  "lastMessage": {
    // full message object
  }
}
```

#### `chats`

Sent when a user’s chat list is updated.

```json
[
  {
    // chat summary object
  }
]
```

#### `userOnline` / `userOffline`

Real-time user presence.

```json
{
  "userId": "USER_ID"
}
```

#### `typing`

Typing status (see above).

#### `chatRead`

Read status update for a chat.

---

### 💡 Notes

* Only one chat room is active at a time per client.
* You must reconnect with a valid JWT if the connection drops.
* Online status is tracked via Redis and updated on connect/disconnect.
* All sent message changes to delivered once the receiver is online.

---