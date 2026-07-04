const express = require("express");
const app = express();

app.use(express.json());

//-----------------------------
// STORAGE
//-----------------------------
let queue = [];

//-----------------------------
// DEBUG MIDDLEWARE (IMPORTANT)
//-----------------------------
app.use((req, res, next) => {
    console.log("\n==============================");
    console.log("REQUEST:", req.method, req.url);
    console.log("BODY:", req.body);
    next();
});

//-----------------------------
// ADD SERVER (ROBLOX → BACKEND)
//-----------------------------
app.post("/add", (req, res) => {
    try {
        const { placeId, serverId, username } = req.body;

        if (!placeId || !serverId) {
            console.log("INVALID DATA RECEIVED");
            return res.json({ ok: false, error: "missing data" });
        }

        const entry = {
            placeId,
            serverId,
            username: username || "unknown",
            status: "pending",
            time: Date.now()
        };

        queue.push(entry);

        console.log("✅ ADDED SERVER:");
        console.log(entry);

        console.log("📦 QUEUE SIZE:", queue.length);

        return res.json({ ok: true });

    } catch (err) {
        console.log("❌ ERROR IN /add:", err);
        return res.json({ ok: false });
    }
});

//-----------------------------
// GET QUEUE (ALT READS THIS)
//-----------------------------
app.get("/queue", (req, res) => {
    res.json({ queue });
});

//-----------------------------
// HEALTH CHECK
//-----------------------------
app.get("/", (req, res) => {
    res.send("OK - backend running");
});

//-----------------------------
// START SERVER
//-----------------------------
app.listen(3000, () => {
    console.log("=================================");
    console.log("🚀 SERVER RUNNING ON PORT 3000");
    console.log("=================================");
});
